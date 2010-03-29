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


end.
