{
     工厂模式和策略模式的组合
}

unit UnitFactoryUnionStrategyPattern;

interface

uses
  Windows, UnitCommon;

type
  TFactoryAndStrategy=class
  public
    function Algorithm(aMoney: Double): Double; virtual; abstract; //Algorithm-运算法则
  published
  end;

  TFactoryAndStrategyNormal = class(TFactoryAndStrategy)
  public
    function Algorithm(aMoney: Double): Double; override;
  end;

  TFactoryAndStrategyRebate = class(TFactoryAndStrategy) //打折子类
  private
    FMoneyRebate: Double;
  public
    function Algorithm(aMoney: Double): Double; override;
    constructor Create(aRebate: Double); overload;
  end;

  TFactoryAndStrategyReturn = class(TFactoryAndStrategy) //返利收费子类
  private
    FMoneyCondition, FMoneyReturn: Double;
  public
    function Algorithm(aMoney: Double): Double; override;
    constructor Create(aCondition, aReturn: Double); overload;
  end;

  TCashContext = class
  private
    FFactoryAndStrategy: TFactoryAndStrategy;
  public
    constructor Create(aType: TAcceptCashType); overload; //简单对象工厂
    function GetMoney(aMoney: Double): Double;
  end;

implementation

{ TFactoryAndStrategyNormal }

function TFactoryAndStrategyNormal.Algorithm(aMoney: Double): Double;
begin
  Result:= aMoney;
end;

{ TFactoryAndStrategyNormalRebate }

constructor TFactoryAndStrategyRebate.Create(aRebate: Double);
begin
  FMoneyRebate:= aRebate;
end;

function TFactoryAndStrategyRebate.Algorithm(aMoney: Double): Double;
begin
  Result:= aMoney * FMoneyRebate;
end;

{ TFactoryAndStrategyReturn }

constructor TFactoryAndStrategyReturn.Create(aCondition, aReturn: Double);
begin
  FMoneyCondition:= aCondition;
  FMoneyReturn:= aReturn;
end;

function TFactoryAndStrategyReturn.Algorithm(aMoney: Double): Double;
begin
  Result:= aMoney;
  if aMoney>FMoneyCondition then
    Result:= aMoney - Trunc(aMoney/FMoneyCondition) * FMoneyreturn;
end;

{ TCashContext }

constructor TCashContext.Create(aType: TAcceptCashType);
begin
  case aType of
    aNormal: begin
      FFactoryAndStrategy:= TFactoryAndStrategyNormal.Create;
    end;
    aRebate: begin
      FFactoryAndStrategy:= TFactoryAndStrategyRebate.Create(0.8);
    end;
    aReturn: begin
      FFactoryAndStrategy:= TFactoryAndStrategyReturn.Create(300,100);
    end;
  end;
end;

function TCashContext.GetMoney(aMoney: Double): Double;
begin
  Result:= FFactoryAndStrategy.Algorithm(aMoney);
end;

end.
