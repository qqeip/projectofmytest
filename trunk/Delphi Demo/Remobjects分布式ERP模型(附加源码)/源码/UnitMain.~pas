unit UnitMain;

{by 滕启荣 5月31日 QQ：317877706；Tel:15850543069}
{索取DLL源码请联系我}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient, StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    Cds: TClientDataSet;
    DBGrid1: TDBGrid;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  FRServerAddress:string;
  Fiport:Integer;

implementation
  uses UnitRemoteLibary;//实际开发时需要引用该单元
{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
  vDatas:OleVariant;
begin
   FRServerAddress:=Edit1.Text;
   Fiport:=StrToInt(Edit2.Text);
   vDatas:='select * from tbspda';
   if Getdatas(FRServerAddress,Fiport,vDatas) then
   Cds.Data:=vDatas
   else
   ShowVarError(Handle,vDatas,'查询时出错!');
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  vDatas:OleVariant;
begin
  FRServerAddress:=Edit1.Text;
  Fiport:=StrToInt(Edit2.Text);
  vDatas:='insert into tbdev(mycode)values(''100'')';
  if not Setdatas(FRServerAddress,Fiport,vDatas) then
   ShowVarError(Handle,vDatas,'保存失败!');
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  vDatas:OleVariant;
  Tsql:TStringList;
  i:integer;
begin
  FRServerAddress:=Edit1.Text;
  Fiport:=StrToInt(Edit2.Text);
  Tsql:=TStringList.create;
  Tsql.Clear;
  Tsql.Append('insert into tbGoods(GoodsCode)values(''00012'')');
  Tsql.Append('insert into tbUser(UserCode)values(''9999'')');
  for i := 0 to 1000 do
  Tsql.Append('insert into tbdev(mycode)values('''+IntToStr(i)+''')');
  if not MakeVarSql(Tsql,vDatas) then
  begin
      FreeAndNil(Tsql);
      messagebox(Handle,'生成SQL语句失败!','错误',MB_ICONError+mb_ok);
      exit;
  end;
  FreeAndNil(Tsql);
  if not Setdatas(FRServerAddress,Fiport,vDatas) then
   ShowVarError(Handle,vDatas,'保存失败!');
end;
end.
