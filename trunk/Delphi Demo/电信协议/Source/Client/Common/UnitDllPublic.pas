unit UnitDllPublic;

interface

uses Forms;

type
  TDllCloseRecall = procedure(aForm: TForm);stdcall; //DLL�رղ��ͷŴ���

var
  FDllCloseRecall: TDllCloseRecall;

implementation

end.

