unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, WinSkinData, WinSkinStore;

type
  TFormMain = class(TForm)
    RG_PartternSelect: TRadioGroup;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Help1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Help2: TMenuItem;
    StatusBar1: TStatusBar;
    Skin1: TMenuItem;
    SkinOfficeStyle1: TMenuItem;
    SkinMSNStyle1: TMenuItem;
    SkinWindowsStyle1: TMenuItem;
    SkinStore1: TSkinStore;
    SkinData1: TSkinData;
    Panel1: TPanel;
    Btn_Reset: TButton;
    Btn_OK: TButton;
    Edt_Price: TEdit;
    Edt_Number: TEdit;
    Label_Price: TLabel;
    Label_Number: TLabel;
    Memo1: TMemo;
    Label_Type: TLabel;
    CBB_Type: TComboBox;
    procedure SkinOfficeStyle1Click(Sender: TObject);
    procedure SkinMSNStyle1Click(Sender: TObject);
    procedure SkinWindowsStyle1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses UnitSimpleFactoryPattern, UnitStrategyPattern, UnitCommon,
  UnitFactoryUnionStrategyPattern;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  SkinData1.LoadFromCollection(skinstore1,0);
  if not SkinData1.active then SkinData1.active:=true;
end;

procedure TFormMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.SkinOfficeStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= True;
  SkinMSNStyle1.Checked:= False;
  SkinWindowsStyle1.Checked:= False;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.SkinMSNStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= False;
  SkinMSNStyle1.Checked:= True;
  SkinWindowsStyle1.Checked:= False;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.SkinWindowsStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= False;
  SkinMSNStyle1.Checked:= False;
  SkinWindowsStyle1.Checked:= True;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.Btn_OKClick(Sender: TObject);
var
  FPattern: string;
  
  FMoney, FCashCount: Double; //简单工厂模式
  FCash: TCash;               //简单工厂模式
  FCashFactory: TCashFactory; //简单工厂模式

  FContext: TContext;                //策略模式
  FStrategyNomal: TStrategyNomal;    //策略模式
  FStrategyRebate: TStrategyRebate;  //策略模式
  FStrategyReturn: TStrategyReturn;  //策略模式

  FCashContext: TCashContext; //简单工厂模式和策略模式的结合
begin
  if Edt_Price.Text='' then begin
    Application.MessageBox('请输入单价！','提示',MB_OK+64);
    Exit;
  end;
  if Edt_Price.Text='' then begin
    Application.MessageBox('请输入数量！','提示',MB_OK+64);
    Exit;
  end;
  if CBB_Type.ItemIndex=-1 then begin
    Application.MessageBox('请选择打折方式！','提示',MB_OK+64);
    Exit;
  end;

  FMoney:= StrToFloat(Edt_Price.Text) * StrToInt(Edt_Number.Text);
  case RG_PartternSelect.ItemIndex of
    0: begin
         FPattern:= '简单工厂模式-';
         FCashFactory:= TCashFactory.Create;
         case CBB_Type.ItemIndex of
         0: begin
              FCash:= FCashFactory.CashAccept(aNormal);
              FCashCount:= FCash.AcceptCash(FMoney);
            end;
         1: begin
              FCash:= FCashFactory.CashAccept(aRebate);
              FCashCount:= FCash.AcceptCash(FMoney);
            end;
         2: begin
              FCash:= FCashFactory.CashAccept(aReturn);
              FCashCount:= FCash.AcceptCash(FMoney);
            end;
         end;
       end;
    1: begin
         FPattern:= '策略模式-';
         case CBB_Type.ItemIndex of
         0: begin
              FStrategyNomal:= TStrategyNomal.Create;
              FContext:= TContext.Create(FStrategyNomal);
            end;
         1: begin
              FStrategyRebate:= TStrategyRebate.Create(0.8);
              FContext:= TContext.Create(FStrategyRebate);
            end;
         2: begin
              FStrategyReturn:= TStrategyReturn.Create(300,100);
              FContext:= TContext.Create(FStrategyReturn);
            end;
         end;
         FCashCount:= FContext.ContextInterface(FMoney);
       end;
    2: begin
         FPattern:= '简单工厂模式和策略模式的结合-';
         case CBB_Type.ItemIndex of
         0: FCashContext:= TCashContext.Create(aNormal);
         1: FCashContext:= TCashContext.Create(aRebate);
         2: FCashContext:= TCashContext.Create(aReturn);
         end;
         FCashCount:= FCashContext.GetMoney(FMoney)
       end;
  end;

  Memo1.Lines.Add(FPattern + '结果金额：' + FloatToStr(FCashCount))
end;

end.
