unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,BaseForm, StdCtrls, ExtCtrls, jpeg, ComCtrls, ToolWin, Menus;

type
  TFrmMain = class(TFrmBase)
    StatusBar1: TStatusBar;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    Image4: TImage;
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N38Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses ComeUnit, Storage, DWareInfo, DBill, DWareMoveBill, StorageCount,
  GatherOne, GatherTwo, Gatherfour, Gatherfive, User, PassWordEdit;

{$R *.dfm}

procedure TFrmMain.N8Click(Sender: TObject);
begin
  inherited;
  TFrmComeUnit.Show;
end;

procedure TFrmMain.N9Click(Sender: TObject);
begin
  inherited;
  TFrmStorage.Show;
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin
  inherited;
  TFrmWareInfo.Show;
end;

procedure TFrmMain.N15Click(Sender: TObject);
begin
  inherited;
  TFrmStockBill.ShowStockInStorage;
end;

procedure TFrmMain.N16Click(Sender: TObject);
begin
  inherited;
  TFrmStockBill.ShowStockOutStorage;
end;

procedure TFrmMain.N18Click(Sender: TObject);
begin
  inherited;
  TFrmStockBill.ShowSellOutStorage;
end;

procedure TFrmMain.N19Click(Sender: TObject);
begin
  inherited;
  TFrmStockBill.ShowSellInStorage;
end;

procedure TFrmMain.N21Click(Sender: TObject);
begin
  inherited;
  TFrmWareMove.ShowWareMove;
end;

procedure TFrmMain.N22Click(Sender: TObject);
begin
  inherited;
  TFrmStorageCount.ShowStorageCount;
end;

procedure TFrmMain.N26Click(Sender: TObject);
begin
  inherited;
  TFrmGatherOne.ShowStockInStorageQuery;
end;

procedure TFrmMain.N27Click(Sender: TObject);
begin
  inherited;
  TFrmGatherOne.ShowSellOutStorageQuery;
end;

procedure TFrmMain.N28Click(Sender: TObject);
begin
  inherited;
  TFrmGatherOne.ShowStockOutStorageQuery;
end;

procedure TFrmMain.N29Click(Sender: TObject);
begin
  inherited;
  TFrmGatherOne.ShowSellInStorageQuery;
end;

procedure TFrmMain.N31Click(Sender: TObject);
begin
  inherited;
  TFrmGatherTwo.ShowStockInWare;
end;

procedure TFrmMain.N32Click(Sender: TObject);
begin
  inherited;
  TFrmGatherTwo.ShowStockOutWare;
end;

procedure TFrmMain.N34Click(Sender: TObject);
begin
  inherited;
  TFrmGatherTwo.ShowSellOutWare;
end;

procedure TFrmMain.N35Click(Sender: TObject);
begin
  inherited;
  TFrmGatherTwo.ShowSellInWare;
end;

procedure TFrmMain.N37Click(Sender: TObject);
begin
  inherited;
  TFrmGatherfour.ShowStorageMoveGather;
end;

procedure TFrmMain.N38Click(Sender: TObject);
begin
  inherited;
  TFrmGatherfive.ShowStorageMoveDetailGather;
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  inherited;
  TFrmPassWordEdit.ShowEditPassWord;
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  inherited;
  TFrmUser.ShowUserManage;
end;

procedure TFrmMain.N6Click(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
