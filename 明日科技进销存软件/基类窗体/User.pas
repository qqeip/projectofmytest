unit User;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, DB, ADODB, Grids,
  DBGrids;

type
  TFrmUser = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    DBGrid1: TDBGrid;
    DSMaster: TDataSource;
    ADOMaster: TADODataSet;
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    class procedure ShowUserManage;
  end;

var
  FrmUser: TFrmUser;

implementation

uses DataModu, UserEdit, md5, PubConst;

{$R *.dfm}

procedure TFrmUser.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmUser.FormShow(Sender: TObject);
begin
  inherited;
  ADOMaster.Active := False;
  ADOMaster.Active := True;
end;

procedure TFrmUser.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  FrmUserEdit := TFrmUserEdit.Create(Self);
  if FrmUserEdit.ShowModal = mrOK then
  begin
    ADOMaster.Append;
    ADOMaster.FieldByName('UserName').AsString := FrmUserEdit.Edit1.Text;
    ADOMaster.FieldByName('PassWord').AsString := MD5Print(MD5String(''));
    ADOMaster.Post;
  end;
  FrmUserEdit.Free;
end;

procedure TFrmUser.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  if ADOMaster.FieldByName('isManage').AsBoolean then
  begin
    Application.MessageBox('系统用户不能修改！', '系统提示', MB_OKCANCEL + MB_ICONINFORMATION);
    Exit;
  end;
  FrmUserEdit := TFrmUserEdit.Create(Self);
  FrmUserEdit.Edit1.Text := ADOMaster.FieldByName('UserName').AsString;
  if FrmUserEdit.ShowModal = mrOK then
  begin
    ADOMaster.Edit;
    ADOMaster.FieldByName('UserName').AsString := FrmUserEdit.Edit1.Text;
    ADOMaster.Post;
  end;
  FrmUserEdit.Free;
end;

procedure TFrmUser.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  if ADOMaster.FieldByName('isManage').AsBoolean then
  begin
    Application.MessageBox('系统用户不能删除！', '系统提示', MB_OKCANCEL + MB_ICONINFORMATION);
    Exit;
  end;

  if Application.MessageBox('是否要删除此记录！', '系统提示', MB_OKCANCEL + MB_ICONINFORMATION) = IDOK 
    then
  begin
    ADOMaster.Delete;
  end;

end;

procedure TFrmUser.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

class procedure TFrmUser.ShowUserManage;
begin
  FrmUser := TFrmUser.Create(Application);
  FrmUser.ShowModal;
  FrmUser.Free;
end;

end.
