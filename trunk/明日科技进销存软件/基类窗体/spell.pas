unit Spell;
interface
uses
  IMCode;
(*szText-��ȡƴ��������ַ���
  iMode-ֵΪ0��ȡ������������ĸ
  iCount-��ȡƴ��������ַ�������*)
function GetSpellCode(szText: PChar; iMode, iCount: Integer): PChar; stdcall;// external 'spell';
implementation
function GetSpellCode(szText: PChar; iMode, iCount: Integer): PChar; stdcall;
begin
  Result := IMCode.GetSpellCode(szText,iMode,iCount);
end;
end.
