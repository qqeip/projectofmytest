unit UnitDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient, ComCtrls, StdCtrls, ImgList,
  ExtCtrls;

type
  TFormDemo = class(TForm)
    Splitter1: TSplitter;
    Panel1: TPanel;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    TreeViewTest: TTreeView;
    GroupBox2: TGroupBox;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DBGrid1: TDBGrid;
    GroupBox3: TGroupBox;
    BtnOK: TButton;
    BtnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDemo: TFormDemo;

implementation

uses UnitDllPublic;

{$R *.dfm}

procedure TFormDemo.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormDemo.FormShow(Sender: TObject);
begin
//
end;

procedure TFormDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDllCloseRecall(FormDemo);
end;

procedure TFormDemo.FormDestroy(Sender: TObject);
begin
//
end;

end.
