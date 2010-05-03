//*******************************************************//
//                                                       //
//                                                       //
//                                                       //
//*******************************************************//

unit UnitRepertoryManager;

interface

uses
  Classes, Controls, SysUtils, Windows, Forms;

type
  TRepertory = class(TObject)
  private
    FGoodsID: Integer;
    FTotalNum: Integer;
    FSalePrice: Double;
    FLastNum: Integer;
    FLastMoney: Double;
    procedure SetGoodsID(const Value: Integer);
    procedure SetLastMoney(const Value: Double);
    procedure SetLastNum(const Value: Integer);
    procedure SetSalePrice(const Value: Double);
    procedure SetTotalNum(const Value: Integer);
  public
    //destructor Destroy; override;
  property GoodsID: Integer read FGoodsID write SetGoodsID;
  property TotalNum: Integer read FTotalNum write SetTotalNum;
  property SalePrice: Double read FSalePrice write SetSalePrice;
  property LastNum: Integer  read FLastNum write SetLastNum;
  property LastMoney: Double  read FLastMoney write SetLastMoney;
  end;

  TRepertoryMgr = class(TObject)
  private
    FRepertoryList: TStrings;

    function FindRepertory(ARepertory: string): TRepertory;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadRepertory(aGoodsID, aTotalNum, aLastNum: Integer; aSalePrice, LastMoney: Double);
    function GetCount: Integer;
    function ISRepertoryNull(aGoodsID, aTotalNum, aLastNum: Integer): Integer; //һ�γ���ʱ��ͬһ��Ʒ�����ʱ �жϿ���Ƿ񹻳�������
    function OverOutRepertory_LastNum(aGoodsID: Integer): Integer; //һ�γ���ʱ��ͬһ��Ʒ�����ʱ �������ʣ����
  property RepertoryList: TStrings read FRepertoryList write FRepertoryList;
  end;

implementation

{ TRepertoryMgr }

constructor TRepertoryMgr.Create;
begin
  inherited Create;
  FRepertoryList := TStringList.Create();
end;

destructor TRepertoryMgr.Destroy;
  var
  i: Integer;
begin
  for i := FRepertoryList.Count-1 downto 0 do
  begin
      (FRepertoryList.Objects[i]).Free;
  end;
  FreeAndNil(FRepertoryList);
  inherited Destroy;
end;

function TRepertoryMgr.FindRepertory(ARepertory: string): TRepertory;
begin
  if FRepertoryList.IndexOf(ARepertory) = -1 then Result := nil
  else Result := TRepertory(FRepertoryList.Objects[FRepertoryList.IndexOf(ARepertory)]);
end;

function TRepertoryMgr.GetCount: Integer;
begin
  Result:= FRepertoryList.Count;
end;

function TRepertoryMgr.ISRepertoryNull(aGoodsID, aTotalNum, aLastNum: Integer): Integer;
var
  lLastNum: Integer;
  plg: TRepertory;
begin
  plg := FindRepertory(IntToStr(aGoodsID));
  if not (plg = nil) then
  begin
    with plg do
    begin
      lLastNum:= FLastNum-(aTotalNum - aLastNum);
      if lLastNum<0 then
        Result:= -1;
      if lLastNum=0 then
        Result:= 0;
      if lLastNum>0 then
        Result:= 1;
    end
  end
end;

function TRepertoryMgr.OverOutRepertory_LastNum(aGoodsID: Integer): Integer;
var
  lLastNum: Integer;
  plg: TRepertory;
begin
  plg := FindRepertory(IntToStr(aGoodsID));
  if not (plg = nil) then
      Result:= plg.FLastNum;
end;

procedure TRepertoryMgr.LoadRepertory(aGoodsID, aTotalNum, aLastNum: Integer; aSalePrice, LastMoney: Double);
var
  plg: TRepertory;
begin
  //ȡ�ó�����Ʒ������Ϣ������װ�뵽���С�
  plg := FindRepertory(IntToStr(aGoodsID));
  //���˳�����Ʒ��Ϣ�����Ƿ���ڣ�������ڣ��޸������ͽ�
  if not (plg = nil) then
  begin
    with plg do
    begin
      FTotalNum:= FLastNum;
      FSalePrice:= aSalePrice;
      FLastNum:= FTotalNum-(aTotalNum - aLastNum);
      FLastMoney:= LastMoney;
    end
  end
  else//���˳�����Ʒ��Ϣ�Ƿ���ڣ��������½�;
  begin
    plg:= TRepertory.Create;
    with plg do
    begin
      FGoodsID:= aGoodsID;
      FTotalNum:= aTotalNum;
      FSalePrice:= aSalePrice;
      FLastNum:= aLastNum;
      FLastMoney:= LastMoney;
      FRepertoryList.AddObject(IntToStr(aGoodsID), plg);
    end;
  end;

end;

{ TRepertory }

procedure TRepertory.SetGoodsID(const Value: Integer);
begin
  FGoodsID := Value;
end;

procedure TRepertory.SetLastMoney(const Value: Double);
begin
  FLastMoney := Value;
end;

procedure TRepertory.SetLastNum(const Value: Integer);
begin
  FLastNum := Value;
end;

procedure TRepertory.SetSalePrice(const Value: Double);
begin
  FSalePrice := Value;
end;

procedure TRepertory.SetTotalNum(const Value: Integer);
begin
  FTotalNum := Value;
end;

end.
 