{
           简单工厂模式
  厂家经常变换打折金额和返利额度时，
  就要不断更改工厂类，应用促销模式
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

  TCashRebate = class(TCash) //打折子类
  private
    FMoneyRebate: Double;
  public
    function AcceptCash(aMoney: Double): Double; override;
    constructor Create(aRebate: Double); overload;
  end;

  TCashReturn = class(TCash) //返利收费子类
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
