{
           �򵥹���ģʽ
  ���Ҿ����任���۽��ͷ������ʱ��
  ��Ҫ���ϸ��Ĺ����࣬Ӧ�ô���ģʽ
}
unit UnitSimpleFactoryPattern;

interface

uses
  Windows, UnitCommon;

type
  TCash=class
  private
  public
    function AcceptCash(aMoney: Double): Double; virtual; abstract;
  published
  end;

  TCashNomal = class(TCash)
  private
  public
    function AcceptCash(aMoney: Double): Double; override;
  end;

  TCashRebate = class(TCash) //��������
  private
    FMoneyRebate: Double;
  public
    function AcceptCash(aMoney: Double): Double; override;
    constructor Create(aRebate: Double); overload;
  end;

  TCashReturn = class(TCash) //�����շ�����
  private
    FMoneyCondition, FMoneyReturn: Double;
  public
    function AcceptCash(aMoney: Double): Double; override;
    constructor Create(aCondition, aReturn: Double); overload;
  end;

  TCashFactory = class
  private
  public
    function CashAccept(aType: TAcceptCashType): TCash;
  end;
implementation

{ TCashNomal }

function TCashNomal.AcceptCash(aMoney: Double): Double;
begin
  Result:= aMoney;
end;

{ TCashRebate }

constructor TCashRebate.Create(aRebate: Double);
begin
  FMoneyRebate:= aRebate;
end;

function TCashRebate.AcceptCash(aMoney: Double): Double;
begin
  Result:= aMoney * FMoneyRebate;
end;

{ TCashReturn }

constructor TCashReturn.Create(aCondition, aReturn: Double);
begin
  FMoneyCondition:= aCondition;
  FMoneyReturn:= aReturn;
end;

function TCashReturn.AcceptCash(aMoney: Double): Double;
begin
  Result:= aMoney;
  if aMoney>FMoneyCondition then
    Result:= aMoney - Trunc(aMoney/FMoneyCondition) * FMoneyreturn;
end;

{ TCashFactory }

function TCashFactory.CashAccept(aType: TAcceptCashType): TCash;
var FCash: TCash;
begin
  Result:= nil;
  case aType of
    aNormal: begin
      FCash:= TCashNomal.Create;
    end;
    aRebate: begin
      FCash:= TCashRebate.Create(0.8);
    end;
    aReturn: begin
      FCash:= TCashReturn.Create(300, 100);
    end;
  end;
  Result:= FCash;
end;

end.
