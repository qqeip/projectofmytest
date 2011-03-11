{
           ����ģʽ
  ���Ҿ����任���۽��ͷ������ʱ��
  �ֶ��ڿͻ����ж����Ǹ��㷨�ˣ�
  ת�Ƶ��ӿͻ���ת�����ã� ����ģʽ�Ͳ���ģʽ�����
}

unit UnitStrategyPattern;

interface

uses
  Windows, Dialogs;

type
  TStrategy=class
  private
  public
    function AlgorithmInterface(aMoney: Double): Double; virtual; abstract; //Algorithm-���㷨��
  published
  end;

  TStrategyNomal = class(TStrategy)
  private
  public
    function AlgorithmInterface(aMoney: Double): Double; override;
  end;

  TStrategyRebate = class(TStrategy) //��������
  private
    FMoneyRebate: Double;
  public
    function AlgorithmInterface(aMoney: Double): Double; override;
    constructor Create(aRebate: Double); overload;
  end;

  TStrategyReturn = class(TStrategy) //�����շ�����
  private
    FMoneyCondition, FMoneyReturn: Double;
  public
    function AlgorithmInterface(aMoney: Double): Double; override;
    constructor Create(aCondition, aReturn: Double); overload;
  end;

  TContext = class
  private
    FStrategy: TStrategy;
  public
    constructor Create(aStrategy: TStrategy); overload;
    function ContextInterface(aMoney: Double): Double;
  end;
  
implementation

{ TCashNomal }

function TStrategyNomal.AlgorithmInterface(aMoney: Double): Double;
begin
  Result:= aMoney;
end;

{ TCashRebate }

constructor TStrategyRebate.Create(aRebate: Double);
begin
  FMoneyRebate:= aRebate;
end;

function TStrategyRebate.AlgorithmInterface(aMoney: Double): Double;
begin
  Result:= aMoney * FMoneyRebate;
end;

{ TCashReturn }

constructor TStrategyReturn.Create(aCondition, aReturn: Double);
begin
  FMoneyCondition:= aCondition;
  FMoneyReturn:= aReturn;
end;

function TStrategyReturn.AlgorithmInterface(aMoney: Double): Double;
begin
  Result:= aMoney;
  if aMoney>FMoneyCondition then
    Result:= aMoney - Trunc(aMoney/FMoneyCondition) * FMoneyreturn;
end;

{ TContext }

constructor TContext.Create(aStrategy: TStrategy);
begin
  FStrategy:= aStrategy;
end;

function TContext.ContextInterface(aMoney: Double): Double;
begin
  Result:= FStrategy.AlgorithmInterface(aMoney);
end;

end.
