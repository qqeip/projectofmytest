
{*****************************************}
{                                         }
{          Report Machine v2.0            }
{             Report Pars                 }
{                                         }
{*****************************************}

unit RM_Parser;

{$I RM.INC}

interface

uses
  Windows, SysUtils, Classes, Forms, DB
  {$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMGetPValueEvent = procedure(aVariableName: string; var aValue: Variant) of object;
  TRMFunctionEvent = procedure(aFunctionName: string; aParams: array of Variant;
    var val: Variant; var aFound: Boolean) of object;

  // TRMVariables is tool class intended for storing variable name and its
  // value. Value is of type Variant.
  // Call TRMVariables['VarName'] := VarValue to set variable value and
  // VarValue := TRMVariables['VarName'] to retrieve it.

  PRMVariable = ^TRMVariable;
  TRMVariable = record
    Value: Variant;
    IsExpression: Boolean;
  end;

  { TRMVariables }
  TRMVariables = class(TObject)
  private
    FList: TStringList;

    function GetVariable(const Name: string): Variant;
    function GetValue(Index: Integer): Variant;
    function GetName(Index: Integer): string;
    function GetCount: Integer;
    function GetSorted: Boolean;

    procedure SetVariable(const Name: string; Value: Variant);
    procedure SetStringVariable(const Name: string; Value: Variant);
    procedure SetValue(Index: Integer; Value: Variant);
    procedure SetName(Index: Integer; Value: string);
    procedure SetSorted(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    function IndexOf(const Name: string): Integer;
    procedure Assign(Value: TRMVariables);
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Insert(Index: Integer; const Name: string);

    property Items: TStringList read FList;
    property Variable[const Name: string]: Variant read GetVariable write SetVariable; default;
    property Value[Index: Integer]: Variant read GetValue write SetValue;
    property Name[Index: Integer]: string read GetName write SetName;
    property AsString[const Name: string]: Variant read GetVariable write SetStringVariable;
    property Count: Integer read GetCount;
    property Sorted: Boolean read GetSorted write SetSorted;
  end;

  // TRMParser is intended for calculating expressions passed as string
  // parameter like '1 + 2 * (a + b)'. Expression can contain variables and
  // functions. There is two events in TfrParser: OnGetValue and OnFunction
  // intended for substitute var/func value instead of var/func name.
  // Call TRMParser.Calc(Expression) to get expression value.

   { TRMParser }
  TRMParser = class
  private
    FInScript: Boolean;
    FParentReport: TComponent;
    FOnGetValue: TRMGetPValueEvent;
    FOnFunction: TRMFunctionEvent;
    function GetIdentify(const s: string; var i: Integer): string;
    function GetString(const s: string; var i: Integer): string;
    procedure GetParameters(const s: string; var Index: Integer; var params: array of Variant);
  public
    function Str2OPZ(s: string): string;
    function CalcOPZ(const s: string): Variant;
    function Calc(s: Variant): Variant;

    property ParentReport: TComponent read FParentReport write FParentReport;
    property OnGetValue: TRMGetPValueEvent read FOnGetValue write FOnGetValue;
    property OnFunction: TRMFunctionEvent read FOnFunction write FOnFunction;
    property InScript: Boolean read FInScript write FInScript;
  end;

  // TRMFunctionSplitter is internal class, you typically don't need to use it.
  // It intended for splitting expression onto several parts and checking
  // if it contains some specified functions.
  // TRMFunctionSplitter used when checking if objects has aggregate functions
  // inside.

  TRMFunctionSplitter = class
  protected
    FMatchFuncs, FSplitTo: TStrings;
    FParser: TRMParser;
    FVariables: TRMVariables;
  public
    constructor Create(MatchFuncs, SplitTo: TStrings; Variables: TRMVariables);
    destructor Destroy; override;
    procedure Split(s: string);
  end;

implementation

uses RM_Const, RM_Utils, RM_Class;

const
  ttGe = #1;
  ttLe = #2;
  ttNe = #3;
  ttOr = #4;
  ttAnd = #5;
  ttInt = #6;
  ttFrac = #7;
  ttUnMinus = #9;
  ttUnPlus = #10;
  ttStr = #11;
  ttNot = #12;
  ttMod = #13;
  ttRound = #14;

  {------------------------------------------------------------------------------}
  {------------------------------------------------------------------------------}
  {TRMVariables}

constructor TRMVariables.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FList.Duplicates := dupIgnore;
end;

destructor TRMVariables.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TRMVariables.Clear;
begin
  while FList.Count > 0 do
    Delete(0);
end;

procedure TRMVariables.Assign(Value: TRMVariables);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Value.Count - 1 do
    SetVariable(Value.Name[i], Value.Value[i]);
end;

procedure TRMVariables.SetVariable(const Name: string; Value: Variant);
var
  i: Integer;
  p: PRMVariable;
begin
  i := IndexOf(Name);
  if i <> -1 then
    p := PRMVariable(FList.Objects[i])
  else
  begin
    New(p);
    FList.AddObject(Name, TObject(p));
  end;
  p^.Value := Value;
  p^.IsExpression := True;
end;

procedure TRMVariables.SetStringVariable(const Name: string; Value: Variant);
var
  i: Integer;
  p: PRMVariable;
begin
  i := IndexOf(Name);
  Value := '''' + Value + '''';
  if i >= 0 then
    p := PRMVariable(FList.Objects[i])
  else
  begin
    New(p);
    FList.AddObject(Name, TObject(p));
  end;
  p^.Value := Value;
  p^.IsExpression := True;
end;

function TRMVariables.GetVariable(const Name: string): Variant;
var
  i: Integer;
begin
  i := IndexOf(Name);
  if i >= 0 then
    Result := PRMVariable(FList.Objects[i]).Value
  else
    Result := Null;
end;

procedure TRMVariables.SetValue(Index: Integer; Value: Variant);
begin
  if (Index < 0) or (Index >= FList.Count) then Exit;
  PRMVariable(FList.Objects[Index])^.Value := Value;
end;

function TRMVariables.GetValue(Index: Integer): Variant;
begin
  Result := 0;
  if (Index < 0) or (Index >= FList.Count) then Exit;
  Result := PRMVariable(FList.Objects[Index])^.Value;
end;

function TRMVariables.IndexOf(const Name: string): Integer;
begin
  Result := FList.IndexOf(Name);
end;

procedure TRMVariables.Insert(Index: Integer; const Name: string);
begin
  SetVariable(Name, 0);
  FList.Move(FList.IndexOf(Name), Index);
end;

function TRMVariables.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TRMVariables.SetName(Index: Integer; Value: string);
begin
  if (Index < 0) or (Index >= FList.Count) then Exit;
  FList[Index] := Value;
end;

function TRMVariables.GetName(Index: Integer): string;
begin
  Result := '';
  if (Index < 0) or (Index >= FList.Count) then Exit;
  Result := FList[Index];
end;

procedure TRMVariables.Delete(Index: Integer);
var
  p: PRMVariable;
begin
  if (Index < 0) or (Index >= FList.Count) then Exit;
  p := PRMVariable(FList.Objects[Index]);
  Dispose(p);
  FList.Delete(Index);
end;

procedure TRMVariables.SetSorted(Value: Boolean);
begin
  FList.Sorted := Value;
end;

function TRMVariables.GetSorted: Boolean;
begin
  Result := FList.Sorted;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMParser}

function TRMParser.CalcOPZ(const s: string): Variant;
var
  i, j, k, i1, st: Integer;
  s1: string;
  lParams: array[0..10] of Variant;
  nm: array[1..11] of Variant;
  v: Double;
  lFound: Boolean;

  procedure _RMSetNullValue;

    procedure _SetValue(var aValue1: Variant; const aValue2: Variant);
    begin
      if (TVarData(aValue2).VType = varString) or (TVarData(aValue2).VType = varOleStr) then
        aValue1 := ''
      else if TVarData(aValue2).VType = varBoolean then
        aValue1 := False
      else
        aValue1 := 0;
    end;

  begin
		if (FParentReport = nil) or TRMReport(FParentReport).ConvertNulls then Exit;
//    if not RMUseNull then Exit;

    if (nm[st - 2] = Null) or (nm[st - 1] = Null) then
    begin
      if nm[st - 2] = Null then
      begin
        _SetValue(nm[st - 2], nm[st - 1]);
      end
      else if nm[st - 1] = Null then
      begin
        _SetValue(nm[st - 1], nm[st - 2]);
      end;
    end;
  end;

begin
  st := 1;
  i := 1;
  nm[1] := 0;
  while i <= Length(s) do
  begin
    j := i;
    case s[i] of
      '+', ttOr:
        begin
          _RMSetNullValue;
          nm[st - 2] := nm[st - 2] + nm[st - 1];
        end;
      '-':
        begin
          _RMSetNullValue;
          nm[st - 2] := nm[st - 2] - nm[st - 1];
        end;
      '*', ttAnd:
        begin
          _RMSetNullValue;
          nm[st - 2] := nm[st - 2] * nm[st - 1];
        end;
      '/':
        begin
          _RMSetNullValue;
          if nm[st - 1] <> 0 then
            nm[st - 2] := nm[st - 2] / nm[st - 1]
          else
            nm[st - 2] := 0;
        end;
      '>':
        begin
          _RMSetNullValue;
          if nm[st - 2] > nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      '<':
        begin
          _RMSetNullValue;
          if nm[st - 2] < nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      '=':
        begin
          _RMSetNullValue;
          if nm[st - 2] = nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      ttNe:
        begin
          _RMSetNullValue;
          if nm[st - 2] <> nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      ttGe:
        begin
          _RMSetNullValue;
          if nm[st - 2] >= nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      ttLe:
        begin
          _RMSetNullValue;
          if nm[st - 2] <= nm[st - 1] then
            nm[st - 2] := 1
          else
            nm[st - 2] := 0;
        end;
      ttInt:
        begin
          _RMSetNullValue;
          v := nm[st - 1];
          if Abs(Round(v) - v) < 1E-10 then
            v := Round(v)
          else
            v := Int(v);
          nm[st - 1] := v;
        end;
      ttFrac:
        begin
          _RMSetNullValue;
          v := nm[st - 1];
          if Abs(Round(v) - v) < 1E-10 then
            v := Round(v);
          nm[st - 1] := Frac(v);
        end;
      ttRound:
        begin
          if nm[st - 1] = Null then
            nm[st - 1] := 0;

          nm[st - 1] := Integer(Round(nm[st - 1]));
        end;
      ttUnMinus:
        begin
          if nm[st - 1] = Null then
            nm[st - 1] := 0;

          nm[st - 1] := -nm[st - 1];
        end;
      ttUnPlus: ;
      ttStr:
        begin
          if nm[st - 1] <> Null then
            s1 := nm[st - 1]
          else
            s1 := '';

          nm[st - 1] := s1;
        end;
      ttNot:
        begin
          if nm[st - 1] = Null then
            nm[st - 1] := False;

          if nm[st - 1] = 0 then
            nm[st - 1] := 1
          else
            nm[st - 1] := 0;
        end;
      ttMod:
        begin
          _RMSetNullValue;
          nm[st - 2] := nm[st - 2] mod nm[st - 1];
        end;
      ' ': ;
      '[':
        begin
          k := i;
          s1 := RMGetBrackedVariable(s, k, i);
          if Assigned(FOnGetValue) then
            FOnGetValue(s1, nm[st]);
          Inc(st);
        end
    else //case else
      if s[i] = '''' then
      begin
        s1 := GetString(s, i);
        s1 := Copy(s1, 2, Length(s1) - 2);
        while Pos('''' + '''', s1) <> 0 do
          Delete(s1, Pos('''' + '''', s1), 1);
        nm[st] := s1;
        k := i;
      end
      else
      begin
        k := i;
        s1 := GetIdentify(s, k);
        if (s1 <> '') and (s1[1] in ['0'..'9', '.', ',']) then
        begin
          for i1 := 1 to Length(s1) do
          begin
            if s1[i1] in ['.', ','] then
              s1[i1] := DecimalSeparator;
          end;
          nm[st] := StrToFloat(s1);
        end
        else if RMCmp(s1, 'TRUE') then
          nm[st] := 1
        else if RMCmp(s1, 'FALSE') then
          nm[st] := 0
        else if s[k] = '[' then
        begin
          s1 := 'GETARRAY(' + s1 + ', ' + RMGetBrackedVariable(s, k, i) + ')';
          nm[st] := Calc(s1);
          k := i;
        end
        else if s[k] = '(' then
        begin
          s1 := AnsiUpperCase(s1);
          GetParameters(s, k, lParams);
          if Assigned(FOnFunction) then
            FOnFunction(s1, lParams, nm[st], lFound);
          Dec(k);
        end
        else if Assigned(FOnGetValue) then
        begin
          if not VarIsEmpty(nm[st]) then
            VarClear(nm[st]);
          FOnGetValue(AnsiUpperCase(s1), nm[st]);
        end;
      end;

      i := k;
      Inc(st);
    end; //case

    if s[j] in ['+', '-', '*', '/', '>', '<', '=', ttGe, ttLe, ttNe, ttOr, ttAnd, ttMod] then
      Dec(st);
    Inc(i);
  end; // do

  Result := nm[1];
end;

function TRMParser.GetIdentify(const s: string; var i: Integer): string;
var
  k, n: Integer;
begin
  n := 0;
  while (i <= Length(s)) and (s[i] <= ' ') do
    Inc(i);
  k := i;
  Dec(i);
  repeat
    Inc(i);
    while (i <= Length(s)) and
      not (s[i] in [' ', #13, '+', '-', '*', '/', '>', '<', '=', '(', ')', '[']) do
    begin
      if s[i] = '"' then
        Inc(n);
      Inc(i);
    end;
  until (n mod 2 = 0) or (i >= Length(s));
  Result := Copy(s, k, i - k);
end;

function TRMParser.GetString(const s: string; var i: Integer): string;
var
  k: Integer;
  f: Boolean;
begin
  k := i;
  Inc(i);
  repeat
    while (i <= Length(s)) and (s[i] <> '''') do
      Inc(i);
    f := True;
    if (i < Length(s)) and (s[i + 1] = '''') then
    begin
      f := False;
      Inc(i, 2);
    end;
  until f;
  Result := Copy(s, k, i - k + 1);
  Inc(i);
end;

procedure TRMParser.GetParameters(const s: string; var Index: Integer;
  var params: array of Variant);
var
  c, d, oi, ci: Integer;
  i: Integer;
begin
  c := 1;
  d := 1;
  oi := Index + 1;
  ci := 1;
  repeat
    Inc(Index);
    if s[Index] = '''' then
    begin
      if d = 1 then
        Inc(d)
      else
        d := 1;
    end;
    if d = 1 then
    begin
      if s[Index] = '(' then
        Inc(c)
      else if s[Index] = ')' then
        Dec(c);
      if (s[Index] = ',') and (c = 1) then
      begin
        params[ci - 1] := Copy(s, oi, Index - oi);
        oi := Index + 1;
        Inc(ci);
      end;
    end;
  until (c = 0) or (Index >= Length(s));

  params[ci - 1] := Copy(s, oi, Index - oi);
  if c <> 0 then
    raise Exception.Create('');
  Inc(Index);
  for i := ci to High(params) do
    params[i] := '';
end;

function TRMParser.Str2OPZ(s: string): string;
label
  1;
var
  i, i1, j, p: Integer;
  stack: string;
  res, s1, s2: string;
  params: array[0..10] of Variant;
  vr: Boolean;
  c: Char;

  function _Priority(c: Char): Integer;
  begin
    case c of
      '(': Result := 5;
      ')': Result := 4;
      '=', '>', '<', ttGe, ttLe, ttNe: Result := 3;
      '+', '-', ttUnMinus, ttUnPlus: Result := 2;
      '*', '/', ttOr, ttAnd, ttNot, ttMod: Result := 1;
      ttInt, ttFrac, ttRound, ttStr: Result := 0;
    else
      Result := 0;
    end;
  end;

begin
  res := '';
  stack := '';
  i := 1;
  vr := False;
  while i <= Length(s) do
  begin
    case s[i] of
      '(':
        begin
          stack := '(' + stack;
          vr := False;
        end;
      ')':
        begin
          p := Pos('(', stack);
          res := res + Copy(stack, 1, p - 1);
          stack := Copy(stack, p + 1, Length(stack) - p);
        end;
      '+', '-', '*', '/', '>', '<', '=':
        begin
          if (s[i] = '<') and (s[i + 1] = '>') then
          begin
            Inc(i);
            s[i] := ttNe;
          end
          else if (s[i] = '>') and (s[i + 1] = '=') then
          begin
            Inc(i);
            s[i] := ttGe;
          end
          else if (s[i] = '<') and (s[i + 1] = '=') then
          begin
            Inc(i);
            s[i] := ttLe;
          end;

          1: if not vr then
          begin
            if s[i] = '-' then
              s[i] := ttUnMinus;
            if s[i] = '+' then
              s[i] := ttUnPlus;
          end;
          vr := False;
          if stack = '' then
            stack := s[i] + stack
          else if _Priority(s[i]) < _Priority(stack[1]) then
            stack := s[i] + stack
          else
          begin
            repeat
              res := res + stack[1];
              stack := Copy(stack, 2, Length(stack) - 1);
            until (stack = '') or (_Priority(stack[1]) > _Priority(s[i]));
            stack := s[i] + stack;
          end;
        end;
      ';': break;
      ' ', #13: ;
    else
      vr := True;
      s2 := '';
      i1 := i;
      if s[i] = '%' then
      begin
        s2 := '%' + s[i + 1];
        Inc(i, 2);
      end;
      if s[i] = '''' then
        s2 := s2 + GetString(s, i)
      else if s[i] = '[' then
      begin
        s2 := s2 + '[' + RMGetBrackedVariable(s, i, j) + ']';
        i := j + 1;
      end
      else
      begin
        s2 := s2 + GetIdentify(s, i);
        if s[i] = '[' then
        begin
          s2 := s2 + '[' + RMGetBrackedVariable(s, i, j) + ']';
          i := j + 1;
        end;
      end;
      c := s[i];
      if (Length(s2) > 0) and (s2[1] in ['0'..'9', '.', ',']) then
        res := res + s2 + ' '
      else
      begin
        s1 := AnsiUpperCase(s2);
        if s1 = 'INT' then
        begin
          s[i - 1] := ttInt;
          Dec(i);
          goto 1;
        end
        else if s1 = 'FRAC' then
        begin
          s[i - 1] := ttFrac;
          Dec(i);
          goto 1;
        end
        else if s1 = 'ROUND' then
        begin
          s[i - 1] := ttRound;
          Dec(i);
          goto 1;
        end
        else if s1 = 'OR' then
        begin
          s[i - 1] := ttOr;
          Dec(i);
          goto 1;
        end
        else if s1 = 'AND' then
        begin
          s[i - 1] := ttAnd;
          Dec(i);
          goto 1;
        end
        else if s1 = 'NOT' then
        begin
          s[i - 1] := ttNot;
          Dec(i);
          goto 1;
        end
        else if s1 = 'STR' then
        begin
          s[i - 1] := ttStr;
          Dec(i);
          goto 1;
        end
        else if s1 = 'MOD' then
        begin
          s[i - 1] := ttMod;
          Dec(i);
          goto 1;
        end
        else if c = '(' then
        begin
          GetParameters(s, i, params);
          res := res + Copy(s, i1, i - i1);
        end
        else
          res := res + s2 + ' ';
      end;
      Dec(i);
    end;
    Inc(i);
  end;

  if stack <> '' then
    res := res + stack;
  Result := res;
end;

function TRMParser.Calc(s: Variant): Variant;
begin
  if FInScript then
    Result := s
  else
    Result := CalcOPZ(Str2OPZ(s));
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMFunctionSplitter}

constructor TRMFunctionSplitter.Create(MatchFuncs, SplitTo: TStrings; Variables: TRMVariables);
begin
  inherited Create;
  FParser := TRMParser.Create;
  FMatchFuncs := MatchFuncs;
  FSplitTo := SplitTo;
  FVariables := Variables;
end;

destructor TRMFunctionSplitter.Destroy;
begin
  FParser.Free;
  inherited Destroy;
end;

procedure TRMFunctionSplitter.Split(s: string);
var
  i, k: Integer;
  s1: string;
  params: array[0..10] of Variant;
begin
  i := 1;
  s := Trim(s);
  if (Length(s) > 0) and (s[1] = '''') then
    Exit;
  while i <= Length(s) do
  begin
    k := i;
    if s[1] = '[' then
    begin
      s1 := RMGetBrackedVariable(s, k, i);
      if FVariables.IndexOf(s1) <> -1 then
        s1 := FVariables[s1];
      Split(s1);
      k := i + 1;
    end
    else
    begin
      s1 := FParser.GetIdentify(s, k);
      if s[k] = '(' then
      begin
        FParser.GetParameters(s, k, params);
        Split(params[0]);
        Split(params[1]);
        Split(params[2]);
        if FMatchFuncs.IndexOf(s1) <> -1 then
          FSplitTo.Add(Copy(s, i, k - i));
      end
      else if FVariables.IndexOf(s1) <> -1 then
      begin
        s1 := FVariables[s1];
        Split(s1);
      end
      else if s[k] in [' ', #13, '+', '-', '*', '/', '>', '<', '='] then
        Inc(k)
      else if s1 = '' then
        break;
    end;
    i := k;
  end;
end;

end.

