unit UnitVFMSGlobal;

interface
uses Forms;

type
  TDllMessage = procedure(aForm: TForm; aMsg: integer; alParamMsg, arParamMsg: string);stdcall;
  TPublicParameter = record
    userid :integer;      //�û����
    userno :string;       //�û��ʺ�
    cityid :integer;      //�û��������б��
    areaid :integer;      //�û���������
    ServerIP :String;     //������IP��ַ
    MsgPort :integer;     //�����ŵ��˿�
    DBPort :integer;      //�����ŵ��˿�
    AlarmShowDay :integer;//�澯��ؽ���Ĭ����ʷ�澯����
    PriveAreaidStrs: string;  // �豸����Ȩ��
    Companyid: integer;       //��ǰ�û���ά����λ���
    RuleCompanyidStr: string; //�������ά����λ����   1,2,3 ��Ҷ�ӽڵ㣩
    CauseLevel: integer;      //����ԭ����Ч����
    ManagerPrive: integer;    //����Ȩ��   0����Ա 1ά����Ա
    MainHandle: THandle;      //��������
    CauseCodeFlag: integer;   //�ύʱ���Ƿ�ǿ��¼�����ԭ��
    ResolveCodeFlag: integer; //�ύʱ���Ƿ�ǿ��¼�����Ϸ���

    CanConnSrv: boolean;      //�Ƿ������ӿͻ���
    IsFormOnTop: boolean;     //�Ƿ�ǰҳ�棬���ϼ����Զ�ˢ���õ�
  end;
  {�û���Ϣ����}
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
  gDllMessage: TDllMessage;  //���������õ�

implementation

end.
