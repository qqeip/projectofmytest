unit UnitDRS_Math;

interface

uses
  SysUtils, IdGlobal, StrUtils, Math, Variants;

const
  gpoly='10001000000100001';
const   
      cBinStrings:   array[0..15]   of   string   =   
  (   
  '0000',   '0001',   '0010',   '0011',   
  '0100',   '0101',   '0110',   '0111',   
  '1000',   '1001',   '1010',   '1011',   
  '1100',   '1101',   '1110',   '1111'   
  );   


  //取部分字符值
  function GetMsgParams(Msg:TIdBytes; aFromIndex, aToIndex: integer): TIdBytes;
  function GetIdBytesString(EnCode :TIdBytes; aFromIndex, aToIndex: integer): string;
  function GetSubStr(aStr: string; aFromIndex, aToIndex: integer): string;
  //CRC
  function GetCrcCode(aStr: string; var aL, aH: integer): string;
  function checkbyte(aStr: string): String;
  function CheckCrcCode(aSource, aTarget: string): boolean;
  //二进制转十进制
  function BinToDecStr(Value :string): integer;
  function BinToInt(InStr:String):Integer;
  function BintoIntSign(aBinStr: string): string;//带符号位的二进制转十进制
  //十六进制转十进制
  function HexToInt(aHex: string): integer;
  //字符串转16进制
  function StrToIdBytes(sValue :String): TIdBytes;
  //ascii转字符串
  function HexAsciiToStr(FBytes:TIdBytes):String;
  //16进制转2进制
  function BCDHexToBin(Hexadecimal: string): string;
  //10进制转2进制
  function IdBytesToBinStr(EnCode :TIdBytes): string;
  function IdBytesToStr(EnCode :TIdBytes): string;
  //
  function StrToAscII(FValue:String):TIdBytes;
  //直放站編號置反
  function OffGetDrsNo(aStr: string): string;
  function GetDRSHEXCODE(aValue: TIdBytes): string;
  //按位取数
  function LeftPad(PadString : string ; HowMany : integer ; PadValue : string): string;
  function RightPad(PadString : string ; HowMany : integer ; PadValue : string): string;
  //二进制转十六进制
  function BinToHex(mBin: string): string;
  //10进制转 2进制 
  function IntToBinStr(Value: LongInt; Size: Integer): String;


implementation

function IntToBinStr(Value: LongInt; Size: Integer): String;
var
  i: Integer;
begin
  Result:='';
  for i:=Size-1 downto 0 do
  begin
    if Value and (1 shl i)<>0 then
      Result:=Result+'1'
    else
      Result:=Result+'0';
  end;
end;

function BintoIntSign(aBinStr: string): string;
var
  I: Integer;
  lValue: integer;
  lIndex: integer;
  lValueStr: string;
begin
  //符号位  负的取反 正为本身
  lValueStr:= aBinStr;
  if copy(lValueStr,1,1)='1' then
  begin
    //先二进制到十进制
    lValue:= 0;
    lIndex:= 0;
    for I := length(lValueStr) downto 2 do
    begin
      if lValueStr[i]='1' then
      begin
        lValue:= lValue + 1*strtoint(vartostr(power(2,lIndex)));
      end;
      inc(lIndex);
    end;
    //减1
    lValue := strtoint(inttostr(lValue-1));
    //十进制转二进制
    lValueStr:= '1'+copy(IntToBinStr(lValue,8),2,maxint);
    //取反  保留第一位不动
    for I := length(lValueStr) downto 2 do
    begin                                                      
      if lValueStr[i]='1' then
        lValueStr[i]:= '0'
      else
        lValueStr[i]:= '1'
    end;
  end;
  //二进制到十进制
  lValue:= 0;
  lIndex:= 0;
  for I := length(lValueStr) downto 2 do
  begin
    if lValueStr[i]='1' then
    begin
      lValue:= lValue + 1*strtoint(vartostr(power(2,lIndex)));
    end;
    inc(lIndex);
  end;
  //符号位
  if copy(lValueStr,1,1)='1' then
    result:= '-'+inttostr(lValue)
  else
    result:= inttostr(lValue);
end;

function   BinToHex(mBin:   string):   string;
var
    I,   J,   L:   Integer;
    S:   string;   
begin
    S   :=   '';   
    L   :=   Length(mBin);   
    if   L   mod   4   <>   0   then   
        for   I   :=   1   to   4   -   (L   mod   4)   do   
            mBin   :=   '0'   +   mBin;   
  
    for   I   :=   Length(mBin)   downto   1   do   begin
        S   :=   mBin[I]   +   S;
        if   Length(S)   =   4   then   begin
            for   J   :=   0   to   15   do
                if   S   =   cBinStrings[J]   then   begin
                    S   :=   IntToHex(J,   1);
                    Break;
                end;
            if   Length(S)   >   1   then
                Result   :=   '0'   +   Result
            else   Result   :=   S   +   Result;
            S   :=   '';
        end   ;
    end;
end;

function LeftPad(PadString : string ; HowMany : integer ; PadValue : string): string;
var
   Counter : integer;
   x : integer;
   NewString : string;
begin
   Counter := HowMany - Length(PadString);
   for x := 1 to Counter do
   begin
      NewString := NewString + PadValue;
   end;
   Result := NewString + PadString;
end;

function RightPad(PadString : string ; HowMany : integer ; PadValue : string): string;
var
   Counter : integer;
   x : integer;
   NewString : string;
begin
   Counter := HowMany - Length(PadString);
   for x := 1 to Counter do
   begin
      NewString := NewString + PadValue;
   end;
   Result := PadString+ NewString;
end;

function CheckCrcCode(aSource, aTarget: string): boolean;
begin
  result:= false;


  result:= true;
end;

function GetSubStr(aStr: string; aFromIndex, aToIndex: integer): string;
begin
  result:= copy(aStr, aFromIndex, aToIndex- aFromIndex+ 1);
end;

function BinToInt(InStr:String):Integer;
var
  LoopCounter:Integer;
begin
  Result:= 0;
  for LoopCounter   :=   1   to   Length(Instr)   do
    Result   :=   Result   +   Trunc(   StrToInt(InStr[LoopCounter])*Power(2,   Length(InStr)-LoopCounter   )   );
end;

function GetDRSHEXCODE(aValue: TIdBytes): string;
var
  i: integer;
  lByteValue: TIdBytes;
begin
  for I := 1 to 5 do
    result :=result+Format('%-.2x',[aValue[i]]);
  setlength(lByteValue,8);
  lByteValue:= Copy(aValue,6,8);
  result:= result+HexAsciiToStr(lByteValue);
  for I := 14 to length(aValue)-1 do
    result :=result+Format('%-.2x',[aValue[i]]);
end;

function OffGetDrsNo(aStr: string): string;
var
  lstr: string;
begin
  lstr:= aStr;
  result:= '';
  while length(lstr)<>0 do
  begin
    result:= result+ rightstr(lstr,2);
    lstr:= copy(lstr,1,length(lstr)-2);
  end;
end;

function StrToAscII(FValue:String):TIdBytes;
var
  i : integer;
begin
  result := nil;
  SetLength(result,Length(FValue));
  for i :=1 to Length(FValue) do
    result[i-1] := Ord(FValue[i]);
end;

function GetMsgParams(Msg: TIdBytes; aFromIndex,
  aToIndex: integer): TIdBytes;
var
  lData: TIdBytes;
  lCounts: integer;
begin
  lData:= nil;
  lCounts:= aToIndex-aFromIndex+1;
  SetLength(lData,lCounts);
  lData :=Copy(Msg,aFromIndex,lCounts);
  result:= lData;
end;

function GetIdBytesString(EnCode: TIdBytes; aFromIndex,
  aToIndex: integer): string;
var
  I: integer;
  s: string;
begin
  for I := aFromIndex to aToIndex do
    s :=s+' '+Format('%-.2x',[EnCode[i]]);
  result:= s;
end;

function GetCrcCode(aStr: string; var aL, aH: integer): string;
var
  lstr, lAppendStr: string;
  i: integer;
begin
  result:= '';
  lstr:= BCDHexToBin(aStr);
  //左移加0
  for I := 0 to 15 do
    lAppendStr:= lAppendStr + '0';
  lstr:= lstr+lAppendStr;

  while length(lstr)>16 do
  begin
    lstr:= checkbyte(lstr);
  end;
  //二进制转十进制
//  aL:= BinToInt(copy(lstr,length(lstr)-8,maxint));
//  aH:= BinToInt(copy(lstr,1,length(lstr)-8));
//  result:= inttohex(aL,2)+inttohex(aH,2);
  //转十六进制
  result:= BinToHex(rightstr(lstr,8));
  result:= result+ BinToHex(leftstr(lstr,length(lstr)-8));
end;

function checkbyte(aStr: string): String;
var
  lisNeedCut: boolean;
  I: Integer;
begin
  lisNeedCut:= true;
  result:= '';
  for I := 1 to length(gpoly) do
  begin
    if char(gpoly[i])<>char(aStr[i]) then
    begin
      lisNeedCut:= false;
      result:= result+'1';
    end
    else
    begin
      if not lisNeedCut then
        result:= result+'0';
    end;
  end;
  result:= result+ copy(aStr,length(gpoly)+1,maxint);
end;

function BinToDecStr(Value: string): integer;
var
 str : String;
 Int : Integer;
 i : integer;
begin
  Str := UpperCase(Value);
  Int := 0;
  for i := 1 to Length(str) do
   Int := Int * 2+ ORD(str[i]) - 48;
  //Result := IntToStr(Int);
  result:=  int;
end;

function HexToInt(aHex: string): integer;
begin
  result:= Strtoint('$'+ aHex);
end;

function StrToIdBytes(sValue: String): TIdBytes;
var
  i : integer;
  Msg :String;
begin
  Msg := StringReplace(sValue,' ','',[rfReplaceAll]);
  if Msg<>'' then
  begin
    SetLength(Result,Length(Msg) div 2);
    for I := 0 to Length(Msg) div 2-1 do
      Result[i] :=StrToInt('$'+Copy(Msg,i*2+1,2));
  end;
end;

function HexAsciiToStr(FBytes: TIdBytes): String;
var
  i,l : integer;
  s :string;
begin
  for i :=0 to High(FBytes) do
  begin
    l := FBytes[i];
    //l :=StrToInt('$'+IntToStr(l));
    s := s+chr(l);
  end;
  result :=s;
end;

function BCDHexToBin(Hexadecimal: string): string;
const
  BCD:   array   [0..15]   of   string   =
('0000',   '0001',   '0010',   '0011',   '0100',   '0101',   '0110',   '0111',

'1000',   '1001',   '1010',   '1011',   '1100',   '1101',   '1110',   '1111');
var
    i:   integer;
begin
  Result:= '';
  for   i   :=   Length(Hexadecimal)   downto   1   do
    Result   :=   BCD[StrToInt('$'   +   Hexadecimal[i])]   +   Result;
end;

function IdBytesToBinStr(EnCode: TIdBytes): string;
var
  i : integer;
  s :string;
begin
  for I := Low(EnCode) to High(EnCode) do
    s :=s+Format('%-.2x',[EnCode[i]]);
  s:= BCDHexToBin(s);
end;

function IdBytesToStr(EnCode: TIdBytes): string;
var
  i : integer;
  s :string;
begin
  for I := Low(EnCode) to High(EnCode) do
    s :=s+' '+Format('%-.2x',[EnCode[i]]);
  result:= s;
end;

end.
