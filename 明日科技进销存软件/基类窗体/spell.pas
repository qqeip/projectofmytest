unit Spell;
interface
uses
  IMCode;
(*szText-获取拼音简码的字符串
  iMode-值为0获取各个汉字首字母
  iCount-获取拼音简码的字符串个数*)
function GetSpellCode(szText: PChar; iMode, iCount: Integer): PChar; stdcall;// external 'spell';
implementation
function GetSpellCode(szText: PChar; iMode, iCount: Integer): PChar; stdcall;
begin
  Result := IMCode.GetSpellCode(szText,iMode,iCount);
end;
end.
