unit UnitDRSSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxContainer, cxGroupBox, ExtCtrls, CxGridUnit;

type
  TFormDRSSearch = class(TForm)
    Panel1: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGridDRSSearch: TcxGrid;
    cxGridDRSSearchDBTableView1: TcxGridDBTableView;
    cxGridDRSSearchLevel1: TcxGridLevel;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGridDRSSearchDBTableView1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCxGridHelper : TCxGridSet;
    FSearchCondition: string;

    procedure AddField_DRS;
    { Private declarations }
  public
    { Public declarations }
    FDRSID: Integer;
    FIsBuilding: Boolean;
  published
    property SearchCondition: string read FSearchCondition write FSearchCondition;
    property DRSID: Integer read FDRSID write FDRSID;
    property IsBuilding: Boolean read FIsBuilding write FIsBuilding;
  end;

var
  FormDRSSearch: TFormDRSSearch;

implementation

uses Ut_Common;

{$R *.dfm}


procedure TFormDRSSearch.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDRSSearch,false,false,true);
  AddField_DRS;
end;

procedure TFormDRSSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FCxGridHelper.Free;
end;

procedure TFormDRSSearch.FormShow(Sender: TObject);
begin
//
end;

procedure TFormDRSSearch.AddField_DRS;
begin
  AddViewField(cxGridDRSSearchDBTableView1,'DRSid','�ڲ����');
  AddViewField(cxGridDRSSearchDBTableView1,'DRSno','ֱ��վ���');
  AddViewField(cxGridDRSSearchDBTableView1,'isprogramname','�Ƿ��ҷ�');
  AddViewField(cxGridDRSSearchDBTableView1,'buildingname','�����ҷ�');
  AddViewField(cxGridDRSSearchDBTableView1,'drsname','ֱ��վ����');
  AddViewField(cxGridDRSSearchDBTableView1,'drsstatus','״̬');
  AddViewField(cxGridDRSSearchDBTableView1,'drsadress','��ַ');
  AddViewField(cxGridDRSSearchDBTableView1,'drsphone','�绰����');   
end;

procedure TFormDRSSearch.cxGridDRSSearchDBTableView1DblClick(Sender: TObject);
var
  lDRS_Index, lRecordIndex, lDRSID, lIsProgram_Index, i: Integer;
begin
  try
    lDRS_Index:=cxGridDRSSearchDBTableView1.GetColumnByFieldName('DRSID').Index;
    lIsProgram_Index:=cxGridDRSSearchDBTableView1.GetColumnByFieldName('isprogramname').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�DRSID��IsProgram��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  
  if cxGridDRSSearchDBTableView1.DataController.GetSelectedCount<>1 then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK+64);
    Exit;
  end;

  lRecordIndex:= cxGridDRSSearchDBTableView1.DataController.GetSelectedRowIndex(0);
  lDRSID := cxGridDRSSearchDBTableView1.DataController.GetValue(lRecordIndex,lDRS_Index);

  FDRSID:= lDRSID;
  if cxGridDRSSearchDBTableView1.DataController.GetValue(lRecordIndex,lIsProgram_Index)= '����' then
    FIsBuilding:= True
  else
  if cxGridDRSSearchDBTableView1.DataController.GetValue(lRecordIndex,lIsProgram_Index)= '����' then
    FIsBuilding:= False;

  ModalResult:= mrOk;
end;

end.
