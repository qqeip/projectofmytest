{
    �����Ԫ������д��ڵ���Դ�ͳ�����
}
unit UnitResource;

interface

uses
  Windows;

resourcestring
  sSystemTitle  = 'StockpileSystem';
  sDatabaseStr  = 'Provider=MSDASQL.1;Password=%s;Persist Security Info=True;User ID=%s;Data Source=%s';
  sDataBaseName = 'Stockpile System';
  sDatabaseUserName  = 'admin';
  sDatabaseUserPWD   = '888666';
  sRepeatLogInSystem = '���������У��벻Ҫ�ظ��򿪣�';
  sExitSystemQuery = 'ȷ��Ҫ�˳�ϵͳô?';
  sExitSystemBackupDB = '�˳�ϵͳǰ�Ƿ�Ҫ�������ݿ�?';
  sStatusVersionStr = '��ǰ�汾�ţ�';
  sStatusUserStr = '����Ա��';
  sVersion = '1.0';
  sDeveloper = '������';
  sDeveloperEmail = 'pangmingjie888666@163.com';
  sDeveloperTelephone = '15068719265';
  sHelpFileName = 'Help.chm';

  sIniSectionName = 'BackUpDirSec';
  sIniFilePath = 'BackUpDirPath';
  sIniFileName = 'ConfigInfo.ini';

const
  sDispFontSize =8;
  sDispCharset  =DEFAULT_CHARSET;// ANSI_CHARSET;
  sDateTimeToStrFmt ='DD-MM-YYYY hh:nn:ss';
  sDispFontName ='Arial';  
implementation

end.
