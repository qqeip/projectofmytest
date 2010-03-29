{
    这个单元存放所有存在的资源和常量。
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
  sRepeatLogInSystem = '程序已运行，请不要重复打开！';
  sExitSystemQuery = '确定要退出系统么?';
  sVersion = '1.0';
  sDeveloper = '逄明杰';
  sDeveloperEmail = 'pangmingjie888666@163.com';
  sDeveloperTelephone = '15068719265';
  sHelpFileName = 'Help.chm';

const
  sDispFontSize =8;
  sDispCharset  =DEFAULT_CHARSET;// ANSI_CHARSET;
  sDateTimeToStrFmt ='DD-MM-YYYY hh:nn:ss';
  sDispFontName ='Arial';  
implementation

end.
