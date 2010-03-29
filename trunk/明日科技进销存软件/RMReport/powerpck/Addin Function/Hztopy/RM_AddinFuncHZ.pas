unit RM_AddinFuncHZ;

interface

{$I rm.inc}

uses
  SysUtils, Classes, RM_class, RM_Common, RM_Parser
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMAddinFunctionHZ = class(TRMFunctionLibrary)
  public
    constructor Create; override;
    procedure DoFunction(aParser: TRMParser; FNo: Integer; p: array of Variant; var val: Variant); override;
  end;

implementation

uses
  hztools;

const
  SRMhztopy = 'Hztopy(<String>)|����ת����ƴ���룬����:�����û���ת��Ϊ��yh��';

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMAddinFunctionLibrary }

constructor TRMAddinFunctionHZ.Create;
begin
  inherited Create;
  with List do
  begin
    Add('HZTOPY');
  end;

  AddFunctionDesc('Hztopy', rmftString, SRMhztopy, 'S');
end;

procedure TRMAddinFunctionHZ.DoFunction(aParser: TRMParser; FNo: Integer; p: array of Variant;
  var val: Variant);
begin
  val := '0';
  case FNo of
    0:  // hztopy
      val := hztopy(aParser.Calc(p[0]));
  end;
end;

initialization
  RMRegisterFunctionLibrary(TRMAddinFunctionHZ);

finalization
end.

