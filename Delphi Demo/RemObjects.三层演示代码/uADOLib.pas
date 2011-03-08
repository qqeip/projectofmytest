unit uADOLib;

{----------------------------------------------------------------------------}
{ RemObjects SDK Library - Core Library                                      }
{                                                                            }
{ compiler: Delphi 5 and up, Kylix 2 and up                                  }
{ platform: Win32, Linux                                                     }
{                                                                            }
{ (c)opyright RemObjects Software. all rights reserved.                      }
{                                                                            }
{ Using this code requires a valid license of the RemObjects SDK             }
{ which can be obtained at http://www.remobjects.com.                        }
{----------------------------------------------------------------------------}
                
{$I RemObjects.inc}

interface

uses ADODB_TLB;//ADODB26_TLB;

const CRLF = #13#10;

type TStoredProcInputParam = record
       Name: WideString;
       Type_: DataTypeEnum;
       Size: Integer;
       Value: OleVariant;
     end;

     PStoredProcOutputParam = ^TStoredProcOutputParam;
     TStoredProcOutputParam = record
       Name : WideString;
       Type_: DataTypeEnum;
       Size: Integer;
       Value : OleVariant;
     end;

{ Connection }
procedure OpenConnection(const aConnectionString : string;
                         const aUserID, aPassword : string;
                         out aConnection : _Connection);
procedure CloseConnection(const aConnection : _Connection);

{ Recordset }
procedure OpenRecordset(const aConnection : OleVariant;
                        const aSQLCommand : string;
                        Arguments : array of const;
                        aCursorType : CursorTypeEnum;
                        aLockType: LockTypeEnum;
                        out aRecordset : _Recordset;
                        CursorLocation : CursorLocationEnum = adUseClient);

function GetValues(const aConnection : OleVariant;
                   const aSQLCommand : string;
                   Arguments : array of const) : OleVariant;
procedure OpenFireHoseRecordset(const aConnection : OleVariant;
                                const aSQLCommand : string;
                                Arguments : array of const;
                                out aRecordset : _Recordset;
                                ReadOnly : boolean = FALSE);

procedure DoBatchUpdate(const aConnection : _Connection;
                        const aRecordset : _Recordset);

procedure CloseRecordset(const aRecordset : _Recordset);

{ Commands }

procedure ExecuteCommand(const aConnection : _Connection;
                         const aSQLCommand : string;
                         Arguments : array of const;
                         out RecordsAffected : integer);

{ StoredProcedures }
function NewInputParameter(const Name: WideString;
                           Type_: DataTypeEnum;
                           Size: Integer;
                           const Value: OleVariant) : TStoredProcInputParam;
function NewOutputParameter(const Name: WideString;
                           Type_: DataTypeEnum;
                           Size: Integer) : TStoredProcOutputParam;

procedure ExecuteStoredProcedure(const aConnection : _Connection;
                                 const aStoredProcedureName : string;
                                 InputParameters : array of TStoredProcInputParam;
                                 OutputParameters : array of PStoredProcOutputParam);


{ XML and Recordset }
function OpenXMLRecordset(const aConnection : OleVariant;
                          const aSQLCommand : string;
                          Arguments : array of const;
                          IncludeSchema : boolean = FALSE) : string;
function RecordsetUpdatesToXML(const aRecordSet : _Recordset) : widestring;
procedure DoXMLBatchUpdate(const aConnection : _Connection;
                           const XML : widestring);
function RecordsetToXML(const aRecordSet : _Recordset;
                        IncludeSchema : boolean = FALSE) : widestring;

procedure XMLToRecordset(const XML : widestring; out aRecordSet : _Recordset);

{ SQL }

function AddFilter(const aSQLCommand, aFilter : string) : string;
function SelectTable(const aTableName : string;
                     const someFieldNames : array of string;
                     const aFilter : string = '';
                     const anOrderBy : string = '') : string;

{ Misc }

function RemoveSingleQuote(const aString : string) : string;
function LastInc(const aConnection : _Connection) : integer;
function GenerateKey: string;
procedure SaveText(const someText, aFileName : string);
function LoadFieldFromFile(const aField : Field; const aFileName : string; aChunkSize : integer = 256) : integer;
function SaveFieldAsFile(const aField : Field; const aFileName : string; aChunkSize : integer = 256) : integer;

implementation

uses uROMSXML2_TLB, Classes, ActiveX, ComObj, SysUtils {$IFDEF DELPHI6UP}, Variants {$ENDIF};

// Connection
procedure OpenConnection(const aConnectionString : string;
                         const aUserID, aPassword : string;
                         out aConnection : _Connection);
begin
  aConnection := CoConnection.Create;
  aConnection.Open(aConnectionString, aUserID, aPassword, 0);
end;

procedure CloseConnection(const aConnection : _Connection);
begin
  if (aConnection<>NIL) and (aConnection.State=adStateOpen)
    then aConnection.Close;
end;

// Recordset
procedure OpenRecordset(const aConnection : OleVariant;
                        const aSQLCommand : string;
                        Arguments : array of const;
                        aCursorType : CursorTypeEnum;
                        aLockType: LockTypeEnum;
                        out aRecordset : _Recordset;
                        CursorLocation : CursorLocationEnum = adUseClient);
var sql : string;
begin
  try
    sql := aSQLCommand;
    //sql := Format(aSQLCommand, Arguments);  
    aRecordset := CoRecordset.Create;
    aRecordset.CursorLocation := CursorLocation;
    aRecordset.Open(sql, aConnection, aCursorType, aLockType, 0);
  except
    aRecordset := NIL;
    raise;
  end;
end;

function GetValues(const aConnection : OleVariant;
                   const aSQLCommand : string;
                   Arguments : array of const) : OleVariant;
var rs : _Recordset;
    i  : integer;
begin
  try
    OpenFireHoseRecordset(aConnection, aSQLCommand, Arguments, rs, TRUE);
    if (rs.Fields.Count>1) then begin
      result := VarArrayCreate([0, rs.Fields.Count-1], varVariant);
      for i := 0 to (rs.Fields.Count-1) do result[i] := rs.Fields[i].Value;
    end
    else result := rs.Fields[0].Value;
  finally
    rs.Close;
    rs := NIL;
  end;
end;

procedure OpenFireHoseRecordset(const aConnection : OleVariant;
                                const aSQLCommand : string;
                                Arguments : array of const;
                                out aRecordset : _Recordset;
                                ReadOnly : boolean = FALSE);
var _lock : LockTypeEnum;
begin
  if ReadOnly then _lock := adLockReadOnly else _lock := adLockBatchOptimistic;
  OpenRecordset(aConnection, aSQLCommand, Arguments, adOpenForwardOnly, _lock, aRecordset);
end;

procedure DoBatchUpdate(const aConnection : _Connection;
                        const aRecordset : _Recordset);
begin
  aRecordset.Set_ActiveConnection(aConnection);
  aRecordset.UpdateBatch(adAffectAll);
end;

procedure CloseRecordset(const aRecordset : _Recordset);
begin
  if (aRecordset<>NIL) and (aRecordset.State=adStateOpen)
    then aRecordset.Close;
end;

// Commands
procedure ExecuteCommand(const aConnection : _Connection;
                         const aSQLCommand : string;
                         Arguments : array of const;
                         out RecordsAffected : integer);
var raff : OleVariant;
    sql : string;
begin
  sql := aSQLCommand;
 // sql := Format(aSQLCommand, Arguments);
  aConnection.Execute(sql, raff, 0);
  RecordsAffected := raff;
end;

// StoredProcedures
function NewInputParameter(const Name: WideString;
                           Type_: DataTypeEnum;
                           Size: Integer;
                           const Value: OleVariant) : TStoredProcInputParam;
begin
  result.Name      := Name;
  result.Type_     := Type_;
  result.Size      := Size;
  result.Value     := Value;
end;

function NewOutputParameter(const Name: WideString;
                           Type_: DataTypeEnum;
                           Size: Integer) : TStoredProcOutputParam;
begin
  result.Name      := Name;
  result.Type_     := Type_;
  result.Size      := Size;
end;

procedure ExecuteStoredProcedure(const aConnection : _Connection;
                                 const aStoredProcedureName : string;
                                 InputParameters : array of TStoredProcInputParam;
                                 OutputParameters : array of PStoredProcOutputParam);
var i : integer;
    cmd : OleVariant;
begin
  cmd := CoCommand.Create;
  cmd.ActiveConnection := aConnection;
  cmd.CommandText := aStoredProcedureName;
  cmd.CommandType := adCmdStoredProc;

  for i := 0 to High(InputParameters) do
    cmd.Parameters.Append(cmd.CreateParameter(
        InputParameters[i].Name,
        InputParameters[i].Type_,
        adParamInput,
        InputParameters[i].Size,
        InputParameters[i].Value));

  for i := 0 to High(OutputParameters) do
    cmd.Parameters.Append(cmd.CreateParameter(
        OutputParameters[i].Name,
        OutputParameters[i].Type_,
        adParamOutput,
        OutputParameters[i].Size));

  cmd.Execute(, , adExecuteNoRecords);

  for i := 0 to High(OutputParameters) do 
    OutputParameters[i]^.Value := cmd.Parameters[OutputParameters[i].Name].Value;
end;

// XML and Recordset
function OpenXMLRecordset(const aConnection : OleVariant;
                          const aSQLCommand : string;
                          Arguments : array of const;
                          IncludeSchema : boolean = FALSE) : string;
var rs : _Recordset;
begin
  OpenFireHoseRecordset(aConnection, aSQLCommand, Arguments, rs);
  result := RecordsetToXML(rs, IncludeSchema);
  rs.Close;
  rs := NIL;
end;

procedure DoXMLBatchUpdate(const aConnection : _Connection;
                           const XML : widestring);
var rs : _Recordset;
begin
  XMLToRecordset(XML, rs);
  DoBatchUpdate(aConnection, rs);
  rs.Close;
end;

function RecordsetToXML(const aRecordSet : _Recordset;
                        IncludeSchema : boolean = FALSE) : widestring;
var xmldoc : DOMDocument30;
begin
  result := '';

  xmldoc := CoDOMDocument30.Create;
  xmldoc.async := FALSE;
  //xmldoc := CreateXMLDocument;
  
  aRecordset.Save(xmldoc, adPersistXML);

  if not IncludeSchema
    then result := xmldoc.childNodes[0].childNodes[1].XML
    else result := xmldoc.XML;
end;

function RecordsetUpdatesToXML(const aRecordSet : _Recordset) : widestring;
var xmldoc   : DOMDocument30;
    datanode : IXMLDOMNode;
    sel      : IXMLDOMNodeList;
    i        : integer;
begin
  result := '';

  xmldoc := CoDOMDocument30.Create;
  xmldoc.async := FALSE;
  //xmldoc := CreateXMLDocument;
  aRecordset.Save(xmldoc, adPersistXML);

  datanode := xmldoc.childNodes[0].childNodes[1];

  sel := datanode.selectNodes('*');
  for i := (sel.length-1) downto 0 do
    if (sel.item[i].nodeName='z:row') then datanode.removeChild(sel.item[i]);

  result := xmldoc.XML;
end;

procedure XMLToRecordset(const XML : widestring; out aRecordSet : _Recordset);
var xmldoc : DOMDocument30;
    rs     : OleVariant;
begin
  //xmldoc := CreateXMLDocument;
  xmldoc := CoDOMDocument30.Create;
  xmldoc.async := FALSE;


  if not xmldoc.loadXML(XML)
    then with xmldoc.parseError do
     raise Exception.CreateFmt('%s [%d, %d]', [reason, linepos, line]);

  rs := CoRecordset.Create;
  rs.Open(xmldoc);

  aRecordSet := IUnknown(rs) as _Recordset;
end;

// SQL
function AddFilter(const aSQLCommand, aFilter : string) : string;
var sql : string;
    whereidx, orderbyidx : integer;
begin
  sql := StringReplace(Trim(aSQLCommand), #13, ' ', [rfReplaceAll]);
  sql := StringReplace(sql, #10, ' ', [rfReplaceAll]);

  if (Trim(aFilter)<>'') then begin
    whereidx   := Pos(' WHERE ', UpperCase(sql));
    orderbyidx := Pos(' ORDER ', UpperCase(sql));

    if (whereidx>0) and (orderbyidx>0) then begin
      Insert('(', sql, whereidx+6);
      Insert(') AND ('+aFilter+')', sql, orderbyidx+1);
    end
    else if (whereidx>0) then begin
      Insert('('+aFilter+') AND (', sql, whereidx+6);
      sql := sql+')';
    end
    else if (orderbyidx>0) then Insert(' WHERE ('+aFilter+')', sql, orderbyidx)
    else sql := sql+' WHERE ('+aFilter+')'
  end;

  result := sql;
end;

function SelectTable(const aTableName : string;
                     const someFieldNames : array of string;
                     const aFilter : string = '';
                     const anOrderBy : string = '') : string;
var i     : integer;
    tname : string;
begin
  result := 'SELECT ';
  if (High(someFieldNames)=-1) then result := result+'* '
  else begin
    for i := 0 to High(someFieldNames)-1 do result := result+someFieldNames[i]+', ';
    result := result+someFieldNames[High(someFieldNames)];
  end;

  tname := Trim(aTableName);
  if (Pos(' ', tname)>0) then tname := '"'+tname+'"';
  result := result+' FROM '+tname;
  if (Trim(aFilter)<>'') then result := result+' WHERE ('+aFilter+') ';
  if (Trim(anOrderBy)<>'') then result := result+' ORDER BY '+anOrderBy;
end;

// Misc
function LastInc(const aConnection : _Connection) : integer;
var rs : _Recordset;
    ra : OleVariant;
begin
  rs := aConnection.Execute('SELECT @@IDENTITY', ra, 0);
  result := rs.Fields[0].Value;
  rs.Close;
end;

function RemoveSingleQuote(const aString : string) : string;
begin
  result := StringReplace(aString, '''', '"', [rfReplaceAll]);
end;

function GenerateKey: string;
var guid : TGUID;
begin
  CoCreateGuid(guid);
  result := GUIDToString(guid);
  result := StringReplace(result, '-', '', [rfReplaceAll]);
  result := Copy(result,2,Length(result)-2);
end;

procedure SaveText(const someText, aFileName : string);
var f : textfile;
begin
  AssignFile(f, aFileName);
  try
    Rewrite(f);
    Write(f, someText);
  finally
    {$I-}CloseFile(f){$I+}
  end;
end;

function LoadFieldFromFile(const aField : Field; const aFileName : string; aChunkSize : integer = 256) : integer;
{ From http://groups.google.com/groups?q=appendchunk%2Brecordset%2Bdelphi&hl=en&selm=7njoji%2445e13%40forums.borland.com&rnum=3
  Open recordset with adOpenDynamic, adLockOptimistic,adCmdTable }
var mem    : TMemoryStream;
    buffer : array of Byte;
begin
  mem := TMemoryStream.Create;
  try
    mem.LoadFromFile(aFileName);

    SetLength(Buffer, aChunkSize);
    mem.Position := 0;
    while (mem.Position < mem.Size) do begin
      mem.Read(buffer[0], aChunkSize);
      aField.AppendChunk(Buffer);
    end;

    mem.Position := 0;
    result := mem.Size;
  finally
    mem.Free;
  end;
end;

function SaveFieldAsFile(const aField : Field; const aFileName : string; aChunkSize : integer = 256) : integer;
var mem    : TMemoryStream;
    buffer : array of Byte;
begin
  mem := TMemoryStream.Create;
  try
    SetLength(Buffer, aChunkSize);

    mem.SetSize(aField.ActualSize);
    mem.Position := 0;

    while (mem.Position<mem.Size) do begin
      buffer := aField.GetChunk(aChunkSize);
      mem.Write(buffer[0], aChunkSize);
    end;
    mem.Position := 0; {Very very important, unless set to 0 you cant load it !!!}
    mem.SaveToFile(aFileName);
    
    result := mem.Size;
  finally
    mem.Free;
  end;
end;

end.
