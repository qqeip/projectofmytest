unit Unit1;

interface
uses DesignEditors, DesignIntf, Dialogs, Forms, SysUtils, DesignMenus;

type
  TOnMenuClick = Procedure(sender:TObject) of object;

  TMyTest = class(TComponentEditor)
  public
//    procedure Edit;override;
    FOnMenuClick:TOnMenuClick;
    procedure Copy; override;
    procedure PrepareItem(Index: Integer; const AItem: IMenuItem);override;
    procedure ExecuteVerb(Index: Integer);override;
    function GetVerb(Index: Integer): string;override;
    function GetVerbCount: Integer;override;
    procedure ShowMenu(Sender:TObject);
  end;

  procedure Register;

implementation

{ TMyTest }

//procedure TMyTest.Edit;
//begin
//  inherited;
//  ShowMessage('Edit');
//end;

procedure TMyTest.Copy;
begin
  inherited;
  ShowMessage('copy')
end;

procedure TMyTest.ExecuteVerb(Index: Integer);
begin
  inherited;

    ShowMessage('Menu ' + IntToStr(Index));
    
end;

function TMyTest.GetVerb(Index: Integer): string;
begin
  //²Ëµ¥Ãû×Ö
//  ShowMessage(inttostr(index));

    Result:= 'Menu ' + IntToStr(Index);

end;

function TMyTest.GetVerbCount: Integer;
begin
//  ShowMessage('te');
  Result:= 3;
end;

procedure Register;
begin
  RegisterComponentEditor(TForm,TMyTest);
end;

procedure TMyTest.PrepareItem(Index: Integer; const AItem: IMenuItem);
begin
  inherited;
  if Index=0 then
  begin
    FOnMenuClick := ShowMenu;
    aitem.checked:= True;
    AItem.AddItem('Menu11',0,True,True,FOnMenuClick);
  end;
  if Index=1 then
  begin
    aitem.checked:= True;
    AItem.AddItem('Menu112',0,True,True,ShowMenu);
  end;
end;

//procedure showMenu1;
//begin
//  ShowMessage('Menu  11');
//end;

procedure TMyTest.ShowMenu(Sender: TObject);
begin
  ShowMessage('Menu 0111');
end;

end.
 