unit Ut_SystemSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, StdCtrls, DB, ADODB, BaseGrid,AdvGridUnit,AdvGrid,
  Spin;

type
  TFm_SystemSet = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Btn_Ok: TButton;
    Btn_Refresh: TButton;
    Button3: TButton;
    Ado_Query: TADOQuery;
    Label1: TLabel;
    Et_Name: TEdit;
    Label2: TLabel;
    Et_Ip: TEdit;
    Label3: TLabel;
    Et_FtpIp: TEdit;
    Label4: TLabel;
    Et_FtpUser: TEdit;
    Label5: TLabel;
    Et_FtpPass: TEdit;
    Label6: TLabel;
    Et_FtpPath: TEdit;
    Label7: TLabel;
    Et_FtpPort: TEdit;
    Label8: TLabel;
    Et_Remark: TEdit;
    adv_mtucontrol: TAdvStringGrid;
    adv_Thread: TAdvStringGrid;
    Button1: TButton;
    Btn_ThredResh: TButton;
    Button4: TButton;
    Label9: TLabel;
    Sp_CycTime: TSpinEdit;
    Label10: TLabel;
    cbb_State: TComboBox;
    Label11: TLabel;
    Et_ThreadName: TEdit;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SpinEdit1: TSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label17: TLabel;
    Button2: TButton;
    ButtonPoint: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    procedure Btn_RefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button3Click(Sender: TObject);
    procedure Btn_OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure adv_mtucontrolClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Btn_ThredReshClick(Sender: TObject);
    procedure adv_ThreadClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Et_IpKeyPress(Sender: TObject; var Key: Char);
    procedure Et_FtpPortKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonPointClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FAdvGridSet:TAdvGridSet;
  public
    { Public declarations }
  end;

var
  Fm_SystemSet: TFm_SystemSet;

implementation
uses Ut_Main_Collect;
{$R *.dfm}

procedure TFm_SystemSet.Btn_RefreshClick(Sender: TObject);
const
  SQLSTR =' select a.name  地市 , a.id  地市编号,mtucontrol MTU控制器名称,'+
          ' ip MTU控制器IP,ftpip FTPIP地址, ftpport FTP端口, ftppath FTP路径, username FTP用户, passwd FTP口令, remark 备注 from area_info a '+
          ' left join mtu_controlconfig b on a.id=b.cityid where a.layer=1';
begin
  with Ado_Query do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLSTR);
    Open;
    FAdvGridSet.DrawGrid(Ado_Query,adv_mtucontrol);
  end;
end;

procedure TFm_SystemSet.Btn_ThredReshClick(Sender: TObject);
const
  SQLSTR =' select threadid 线程编号, threadname 线程名称, cyctime 执行周期, decode(state,0,''手动'',1,''自动'')  执行状态 from mtu_threadconfig';
begin
  with Ado_Query do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLSTR);
    Open;
    FAdvGridSet.DrawGrid(Ado_Query,adv_Thread);
  end;
end;

procedure TFm_SystemSet.adv_mtucontrolClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  with TAdvStringGrid(Sender) do
  begin
    Et_Name.Text := Rows[Row].Strings[3];
    Et_Ip.Text := Rows[Row].Strings[4];
    Et_FtpIp.Text := Rows[Row].Strings[5];
    Et_FtpPort.Text := Rows[Row].Strings[6];
    Et_FtpPath.Text := Rows[Row].Strings[7];
    Et_FtpUser.Text := Rows[Row].Strings[8];
    Et_FtpPass.Text := Rows[Row].Strings[9];
    Et_Remark.Text := Rows[Row].Strings[10];
  end;
end;

procedure TFm_SystemSet.adv_ThreadClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  with TAdvStringGrid(Sender) do
  begin
    Et_ThreadName.Text := Rows[Row].Strings[2];
    Sp_CycTime.Value :=StrToInt(Trim(Rows[Row].Strings[3]));
    cbb_State.ItemIndex := cbb_State.Items.IndexOf(Rows[Row].Strings[4]);
  end;
end;

procedure TFm_SystemSet.Btn_OkClick(Sender: TObject);
const
  SQLSTR ='select * from mtu_controlconfig';
begin
  try
    with Ado_Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add(SQLSTR);
      Open;
      if Locate('cityid',adv_mtucontrol.Rows[adv_mtucontrol.Row].Strings[2],[loPartialKey,loCaseInsensitive]) then
        Edit
      else
        Append;
      FieldByName('mtucontrol').AsString := Et_Name.Text;
      FieldByName('IP').AsString :=Et_Ip.Text;
      FieldByName('ftpip').AsString := Et_FtpIp.Text;
      FieldByName('ftpport').AsString :=Et_FtpPort.Text;
      FieldByName('username').AsString :=Et_FtpUser.Text;
      FieldByName('passwd').AsString :=Et_FtpPass.Text;
      FieldByName('ftppath').AsString :=Et_FtpPath.Text;
      FieldByName('remark').AsString :=Et_Remark.Text;
      FieldByName('cityid').asinteger :=StrToInt(adv_mtucontrol.Rows[adv_mtucontrol.Row].Strings[2]);
      Post;
      application.MessageBox('操作成功!','提示',mb_ok+mb_defbutton1);
      Btn_RefreshClick(Btn_Refresh);
    end;
  Except
    On E:exception do
        application.MessageBox(Pchar('操作过程中出错-'+E.Message),'提示');
    end;
end;

procedure TFm_SystemSet.Button1Click(Sender: TObject);
const
  SQLSTR ='update mtu_threadconfig set threadname=:threadname, cyctime = :cyctime , state= :state where threadid=:threadid';
begin
  try
    with Ado_Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add(SQLSTR);
      Parameters.ParamByName('threadname').Value := Trim(Et_ThreadName.Text);
      Parameters.ParamByName('cyctime').Value := Sp_CycTime.Value;
      Parameters.ParamByName('state').Value := cbb_State.ItemIndex;
      Parameters.ParamByName('threadid').Value := adv_Thread.Rows[adv_Thread.Row].Strings[1];
      ExecSQL;
      application.MessageBox('操作成功!','提示');
      Btn_ThredReshClick(Btn_ThredResh);
    end;
  Except
    On E:exception do
        application.MessageBox(Pchar('操作过程中出错-'+E.Message),'提示');
    end;
end;

procedure TFm_SystemSet.Button2Click(Sender: TObject);
var
  lSqlstr: string;
begin
  try
    with Ado_Query do
    begin
      Close;
      lSqlstr:= 'update mtu_funanalyse_content'+
          ' set intervaltime = '+inttostr(SpinEdit1.Value)+','+
          ' rangetime = '+inttostr(SpinEdit2.Value)+','+
          ' setvalue = '+inttostr(SpinEdit3.Value)+','+
          ' ifineffect = '+inttostr(ord(CheckBox1.Checked))+''+
          ' where analysecode = 1';
      Sql.Text:= lSqlstr;
      ExecSQL;
      application.MessageBox('保存成功!','提示');
    end;
  Except
    on E:exception do
      application.MessageBox(Pchar('操作过程中出错-'+E.Message),'提示');
  end;
end;

procedure TFm_SystemSet.Button3Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFm_SystemSet.ButtonPointClick(Sender: TObject);
var
  lSqlstr: string;
begin
  try
    with Ado_Query do
    begin
      close;
      lSqlstr:= 'select * from mtu_funanalyse_content where analysecode=1';
      Sql.Text:= lSqlstr;
      open;
      if recordcount=1 then
      begin
        SpinEdit1.Value:= FieldbyName('intervaltime').AsInteger;
        SpinEdit2.Value:= FieldbyName('rangetime').AsInteger;
        SpinEdit3.Value:= FieldbyName('setvalue').AsInteger;
        if FieldbyName('ifineffect').AsInteger=1 then
          CheckBox1.Checked:= true
        else
          CheckBox1.Checked:= false
      end
      else
        application.MessageBox('导频污染初始化数据失败','提示');
    end;
  except

  end;
end;

procedure TFm_SystemSet.DBGrid1CellClick(Column: TColumn);
begin
  with TDBGrid(Column.Grid).DataSource.DataSet do
  begin
    if not Active then Exit;
    Et_Name.Text := FieldByName('mtucontrol').AsString;
    Et_Ip.Text := FieldByName('IP').AsString;
    Et_FtpIp.Text := FieldByName('ftpip').AsString;
    Et_FtpPort.Text := FieldByName('ftpport').AsString;
    Et_FtpUser.Text := FieldByName('username').AsString;
    Et_FtpPass.Text := FieldByName('passwd').AsString;
    Et_FtpPath.Text := FieldByName('ftppath').AsString;
    Et_Remark.Text := FieldByName('remark').AsString;
  end;
end;

procedure TFm_SystemSet.Et_FtpPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8,#13,#38,#40,#46]) then
    begin
      Key := #0;
      MessageBeep(1);
    end;
end;

procedure TFm_SystemSet.Et_IpKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9','.',#8,#13,#38,#40,#46]) then
    begin
      Key := #0;
      MessageBeep(1);
    end;
end;

procedure TFm_SystemSet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAdvGridSet.Free;
end;

procedure TFm_SystemSet.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(adv_mtucontrol);
  FAdvGridSet.AddGrid(adv_Thread);
  FAdvGridSet.SetGridStyle;
end;

procedure TFm_SystemSet.FormShow(Sender: TObject);
begin
  Btn_RefreshClick(Btn_Refresh);
  Btn_ThredReshClick(Btn_ThredResh);
  ButtonPointClick(ButtonPoint);
end;

end.
