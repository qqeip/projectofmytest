unit Ut_LDM_MTS;

interface

uses
  SysUtils, Classes, uConnectionPool, uADOConnectionPool,IniFiles,Controls,Forms;
  
type
  //首次启动应服及
  TServiceInfo = Record
    ServiceName: String;
    UserName: String;
    Password: String;
    MsgPort :integer;
  end;

type
  TLDM_MTS = class(TDataModule)
    ADOConnPool: TADOConnectionPool;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ServiceInfo :TServiceInfo;
    ConnectionString:WideString;//数据库联接串
    function Action_FirstLoginInit():boolean;
  end;

var
  LDM_MTS: TLDM_MTS;

implementation
uses Ut_ServerSet,Ut_SqlDeclare_Define;
{$R *.dfm}

{ TLDM_MTS }

function TLDM_MTS.Action_FirstLoginInit: boolean;
var
  IniFile : TIniFile;
  temForm : TFm_ServerSet;
begin
  with ServiceInfo do
  begin
    iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'MTS_Service.ini');
    try
       ServiceName := IniFile.ReadString('Server Config','DB_ServiceName','0');
       UserName := IniFile.ReadString('Server Config','DB_LoginName','0');
       Password := IniFile.ReadString('Server Config','DB_LoginPassword','0');
       MsgPort := IniFile.ReadInteger('Server Config','MsgPort',0);
       if (ServiceName = '0') or (UserName = '0') or (Password = '0') or (MsgPort = 0) then
       begin
         temForm := TFm_ServerSet.Create(nil);
         try
            if temForm.ShowModal = mrOk then
            with temForm do
            begin
              ServiceName := Trim(Ed_ServiceName.Text);
              UserName := Trim(Ed_UserName.Text);
              Password := Trim(Ed_Password.Text);
              MsgPort := StrToInt(Trim(Ed_ComPort.Text));
              iniFile.WriteString('Server Config','DB_ServiceName', ServiceName);
              iniFile.WriteString('Server Config','DB_LoginName', UserName);
              iniFile.WriteString('Server Config','DB_LoginPassword', Password);
              iniFile.WriteInteger('Server Config','MsgPort', MsgPort);
              Result := true;
            end
            else
              Result := false;
         finally
           temForm.Free;
         end;
       end
       else
         Result := True;
       ADOConnPool.ConnectionString:='PLSQLRSET=1;Provider=OraOLEDB.Oracle.1;Password='+Password+';User ID='+UserName+';Data Source='+ServiceName+';Persist Security Info=True;';
       ConnectionString:=ADOConnPool.ConnectionString;
     finally
       iniFile.Free;
     end;
   end;
end;

procedure TLDM_MTS.DataModuleCreate(Sender: TObject);
begin
  ADOConnPool.ConnectionString:=ConnectionString;
  InitSQLVar();
end;

end.
