unit UnitDllPublic;

interface

uses Forms;

type
  TDllCloseRecall = procedure(aForm: TForm);stdcall; //DLL关闭并释放窗体

var
  FDllCloseRecall: TDllCloseRecall;

implementation

end.

