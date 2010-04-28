unit UnitVFMSGlobal;

interface
uses Forms;

type
  TDllMessage = procedure(aForm: TForm; aMsg: integer; alParamMsg, arParamMsg: string);stdcall;
  TPublicParameter = record
    userid :integer;      //用户编号
    userno :string;       //用户帐号
    cityid :integer;      //用户所属地市编号
    areaid :integer;      //用户归属郊县
    ServerIP :String;     //服务器IP地址
    MsgPort :integer;     //控制信道端口
    DBPort :integer;      //数据信道端口
    AlarmShowDay :integer;//告警监控界面默认历史告警天数
    PriveAreaidStrs: string;  // 设备区域权限
    Companyid: integer;       //当前用户的维护单位编号
    RuleCompanyidStr: string; //管理的子维护单位集合   1,2,3 （叶子节点）
    CauseLevel: integer;      //故障原因有效级别
    ManagerPrive: integer;    //管理权限   0管理员 1维护人员
    MainHandle: THandle;      //主程序句柄
    CauseCodeFlag: integer;   //提交时候是否强制录入故障原因
    ResolveCodeFlag: integer; //提交时候是否强制录入排障方法

    CanConnSrv: boolean;      //是否能连接客户端
    IsFormOnTop: boolean;     //是否当前页面，故障监视自动刷新用到
  end;
  {用户信息类型}
  RUserData = record
    userid :integer;
    userno :String[20];
    CompanyID :integer;
    cityid :integer;
    parentid :integer;
    Filter :String[20];
    ParentList :String[200];
    ChildList :String[200];
  end;
  RCmd = record
    command: integer;
    NodeCode: integer;
  end;

var
  gPublicParam :TPublicParameter;
  gDllMessage: TDllMessage;  //给主窗体用的

implementation

end.
