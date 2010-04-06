unit UnitPublic;

interface

uses Classes, SysUtils, cxGridDBTableView, cxGridTableView, cxTreeView, cxDataStorage, ADODB;

type
  TItemObj = class
  private
    FFieldID: Integer;
  public
    constructor Create(aFieldID: Integer);
  published
    property FieldID: Integer read FFieldID write FFieldID;
  end;
  
  //给cxGrid加字段
  procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
  procedure ClearTStrings(List: TStrings);
  function GetItemCode(DicName:string;Items:TStrings):integer;  //Combbox读取对象ID
  procedure SetItemCode(aTableName, aFieldID, aFieldName, aWhere: string; DicCodeItems:TStrings);
  function IsExistID(aFieldID, aTableName, aFieldValue: string): Boolean; //添加、修改操作时-判断编号是否已存在
  function GetID(aFieldID, aTableName: string): Integer;     //获取ID
  
implementation

uses UnitDataModule;

   { TItemObj }
constructor TItemObj.Create(aFieldID: Integer);
begin
  FFieldID:= aFieldID;
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

  function GetID(aFieldID, aTableName: string): Integer;     //获取ID
  var
    lAdoQuery: TAdoQuery;
  begin
    Result:= -1;
    lAdoQuery:= TAdoQuery.Create(nil);
    try
      with lAdoQuery do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT Max(' + aFieldID + ') AS NEWID from ' + aTableName;
        Active:= True;
        Result:= FieldByName('NEWID').AsInteger + 1;
        Close;
      end;
    finally
      lAdoQuery.Free;
    end;
  end;

end.
