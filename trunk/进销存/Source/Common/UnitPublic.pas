unit UnitPublic;

interface

uses Classes, SysUtils, Controls, cxGridDBTableView, cxGridTableView,
     cxTreeView, cxDataStorage, ADODB, IniFiles, DateUtils;

type
  TItemObj = class
  private
    FFieldID: Integer;
  public
    constructor Create(aFieldID: Integer);
  published
    property FieldID: Integer read FFieldID write FFieldID;
  end;

type
  TIniOptions = class(TObject)
  private

  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
end;

  
  //给cxGrid加字段
  procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
  procedure ClearTStrings(List: TStrings);
  function GetItemCode(DicName:string;Items:TStrings):integer;  //Combbox读取对象ID
  procedure SetItemCode(aTableName, aFieldID, aFieldName, aWhere: string; DicCodeItems:TStrings);
  function IsExistID(aFieldID, aTableName, aFieldValue: string): Boolean; //添加、修改操作时-判断编号是否已存在
  function GetID(aFieldID, aTableName: string): string;     //获取ID
  procedure InPutChar(var key: Char); //输入框只允许输入【0..9,.】不允许输入字母

  procedure OnWorkRegister;
  procedure OffWorkRegister;

  function SolarDateToLunarDateStr(aDate: TDate): String;//转换指定日期为农历日期字符串
  
implementation

uses UnitDataModule, UnitPublicResourceManager, UnitResource, DateCn;

   { TItemObj }
constructor TItemObj.Create(aFieldID: Integer);
begin
  FFieldID:= aFieldID;
end;

{ TIniOptions }

procedure TIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      LoadSettings(Ini);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TIniOptions.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    CurBackUPDir  := Ini.ReadString(sIniSectionName,sIniFilePath,'');
  end;
end;

procedure TIniOptions.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    Ini.WriteString(sIniSectionName,sIniFilePath,CurBackUPDir);
  end;
end;

procedure TIniOptions.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

  procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
  begin
      //aView.BeginUpdate;
    try
      with aView.CreateColumn as TcxGridColumn do
      begin
        Caption := aCaption;
        DataBinding.FieldName:= aFieldName;
        DataBinding.ValueTypeClass := TcxStringValueType;
        HeaderAlignmentHorz := taCenter;
        Width:=aWidth;
      end;
    finally
      //aView.EndUpdate;
    end;
  end;

  procedure ClearTStrings(List: TStrings);
  var
    i:integer;
  begin
    for  i:=List.Count-1  downto 0 do
    begin
      List.Objects[i].Free;
      List.Delete(i);
    end;
    List.Clear;
  end;

  function GetItemCode(DicName:string;Items:TStrings):integer;
  var
    i: Integer;
    lItemObj:TItemObj;
  begin
    result:=-1;
    for i := 0 to Items.Count - 1 do
    begin
      if uppercase(DicName)=uppercase(Items.Strings[i]) then
      begin
        lItemObj:=TItemObj(Items.Objects[i]);
        result:=lItemObj.FieldID;
        break;
      end;
    end;
  end;

  procedure SetItemCode(aTableName, aFieldID, aFieldName, aWhere: string; DicCodeItems:TStrings);
  var
    lItemObj:TItemObj;
    lAdoQuery: TAdoQuery;
  begin
    ClearTStrings(DicCodeItems);
    lAdoQuery:= TAdoQuery.Create(nil);
    try
      with lAdoQuery do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'select * from ' + aTableName + aWhere + ' order by ' + aFieldID;
        Active:= True;
        First;
        while not eof do
        begin
          lItemObj:=TItemObj.Create(Fieldbyname(aFieldID).AsInteger);
          DicCodeItems.AddObject(Fieldbyname(aFieldName).AsString,lItemObj);
          next;
        end;
        Close;
      end;
    finally
      lAdoQuery.Free;
    end;
  end;

  function IsExistID(aFieldID, aTableName, aFieldValue: string): Boolean; //添加、修改操作时-判断编号是否已存在
  var
    lAdoQuery: TAdoQuery;
  begin
    Result:= False;
    lAdoQuery:= TAdoQuery.Create(nil);
    try
      with lAdoQuery do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT * from ' + aTableName + ' where ' + aFieldID + '=' + aFieldValue;
        Active:= True;
        if RecordCount=0 then
          Result:= False
        else
          Result:= True;
        Close;
      end;
    finally
      lAdoQuery.Free;
    end;
  end;

  function GetID(aFieldID, aTableName: string): string;     //获取ID
  var
    lAdoQuery: TAdoQuery;
    i: Integer;
    lID: string;
  begin
    Result:= '-1';
    lAdoQuery:= TAdoQuery.Create(nil);
    try
      with lAdoQuery do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT iif(Max(' + aFieldID + ') is null,''00000000'',iif(Max(' + aFieldID + ') is not null,Max(' + aFieldID + '))) AS NEWID from ' + aTableName;
        Active:= True;
        lID:= IntToStr(FieldByName('NEWID').AsInteger + 1);
        for i:= 0 to (7-(Length(lID))) do
          lID:= '0' + lID;
        Result:= lID;
        Close;
      end;
    finally
      lAdoQuery.Free;
    end;
  end;

  procedure InPutChar(var key: Char);
  begin
    if not (key in ['0'..'9',#8,#13,#38,#40]) then  //#3-复制,#22-粘贴
    begin
      Key := #0;
    end;
  end;

  procedure OnWorkRegister;
  var
    lSqlStr: string;
  begin
    with TADOQuery.Create(nil) do
    begin
      try
        Active:= False;
        Connection:= dm.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT * FROM Attendance WHERE UserID=' + IntToStr(CurUser.UserID) +
                   ' AND Format(Attendance.CreateDate,''YYYY-MM-DD'')=Format(''' + DateToStr(Now) + ''',''YYYY-MM-DD'')';
        Active:= True;
        if IsEmpty then
          with TADOQuery.Create(nil) do
          begin
            try
              Active:= False;
              Connection:= dm.ADOConnection;
              SQL.Clear;
              lSqlStr:= 'Insert into Attendance(UserID, OnWork, CreateDate) Values (' +
                         IntToStr(CurUser.UserID) + ',' +
                         'Format(''' + TimeToStr(Time) + ''',''hh:mm:ss'')' + ',' +
                         'Format(''' + IntToStr(YearOf(Now))+'-'+IntToStr(MonthOf(Now))+'-'+IntToStr(DayOf(Now)) + ''',''YYYY-MM-DD'')' + ')' ;
              SQL.Text:= lSqlStr;
              ExecSQL;
            finally
              Free;
            end;
          end
        else
        begin
          IF FieldByName('OnWork').AsDateTime>Time then
            with TADOQuery.Create(nil) do
            begin
              try
                Active:= False;
                Connection:= dm.ADOConnection;
                SQL.Clear;
                lSqlStr:= 'Update Attendance Set OnWork=' +
                           'Format(''' + TimeToStr(Time) + ''',''hh:mm:ss'')' +
                           ' Where UserID=' + IntToStr(CurUser.UserID) +
                           '   AND Format(Attendance.CreateDate,''YYYY-MM-DD'')=Format(''' + DateToStr(Now) + ''',''YYYY-MM-DD'')';
                SQL.Text:= lSqlStr;
                ExecSQL;
              finally
                Free;
              end;
            end
        end;
      finally
        Free;
      end;
    end;
  end;

  procedure OffWorkRegister;
  var
    lSqlStr: string;
  begin
    with TADOQuery.Create(nil) do
    begin
      try
        Active:= False;
        Connection:= dm.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT * FROM Attendance WHERE UserID=' + IntToStr(CurUser.UserID) +
                   ' AND Format(Attendance.CreateDate,''YYYY-MM-DD'')=Format(''' + DateToStr(Now) + ''',''YYYY-MM-DD'')';
        Active:= True;
        if IsEmpty then
          with TADOQuery.Create(nil) do
          begin
            try
              Active:= False;
              Connection:= dm.ADOConnection;
              SQL.Clear;
              lSqlStr:= 'Insert into Attendance(UserID, OffWork, CreateDate) Values (' +
                         IntToStr(CurUser.UserID) + ',' +
                         'Format(''' + TimeToStr(Time) + ''',''hh:mm:ss'')' + ',' +                          
                         'Format(''' + IntToStr(YearOf(Now))+'-'+IntToStr(MonthOf(Now))+'-'+IntToStr(DayOf(Now)) + ''',''YYYY-MM-DD'')' + ')' ;
              SQL.Text:= lSqlStr;
              ExecSQL;
            finally
              Free;
            end;
          end
        else
        begin
          IF FieldByName('OffWork').AsDateTime<Time then
            with TADOQuery.Create(nil) do
            begin
              try
                Active:= False;
                Connection:= dm.ADOConnection;
                SQL.Clear;
                lSqlStr:= 'Update Attendance Set OffWork=' +
                           'Format(''' + TimeToStr(Time) + ''',''hh:mm:ss'')' +
                           ' Where UserID=' + IntToStr(CurUser.UserID) +
                           '   AND Format(Attendance.CreateDate,''YYYY-MM-DD'')=Format(''' + DateToStr(Now) + ''',''YYYY-MM-DD'')';
                SQL.Text:= lSqlStr;
                ExecSQL;
              finally
                Free;
              end;
            end
        end;
      finally
        Free;
      end;
    end;
  end;

  function SolarDateToLunarDateStr(aDate: TDate): String;//转换指定日期为农历日期字符串
  begin
    Result := CnDateOfDateStr(aDate);
  end;

end.
