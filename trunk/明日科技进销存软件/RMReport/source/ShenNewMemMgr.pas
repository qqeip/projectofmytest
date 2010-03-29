{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                       �й����Լ�����ѵ�����������                           }
{                   (C)Copyright 2001-2004 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ��һ�������������������������������������������GNU ��        }
{        ����ͨ�ù������֤�������޸ĺ����·�����һ���򣬻��������֤��        }
{        �ڶ��棬���ߣ���������ѡ�����κθ��µİ汾��                        }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� GNU �Ͽ���ͨ�ù�         }
{        �����֤��                                                            }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� GNU �Ͽ���ͨ�ù������֤��         }
{        �����������û�У�д�Ÿ���                                            }
{            Free Software Foundation, Inc., 59 Temple Place - Suite           }
{        330, Boston, MA 02111-1307, USA.                                      }
{                                                                              }
{          ԭʼ�ļ�����CnMemProf.pas                                           }
{            ��Ԫ���ߣ�Chinbo(Chinbo)                                          }
{            ���ص�ַ��http://www.cnvcl.org                                    }
{            �����ʼ���master@cnvcl.org                                        }
{                ��ע����Delphi�����ֲ���ǿ�������ڴ������                    }
{                                                                              }
{******************************************************************************}

unit ShenNewMemMgr;
{* |<PRE>
================================================================================
* ������ƣ�������������
* ��Ԫ���ƣ��ڴ������Ԫ
* ��Ԫ���ߣ�Chinbo(Shenloqi@hotmail.com)
* ��    ע��ʹ������ʱ��Ҫ�����ŵ�Project�ļ���Uses�ĵ�һ������Ȼ������󱨡�
*           Ȼ���ڹ����м���
*             - mmPopupMsgDlg := True;
*               ������ڴ�й©���͵����Ի���
*             - mmShowObjectInfo := True;
*               ���ڴ�й©������RTTI���ͻᱨ����������
*             - ������ó���������ٶ����������趨
*               mmUseObjectList := False;
*               ���ܹ�������ϸ���ڴ�й©�ĵ�ַ�Լ�������Ϣ����ʹ�趨��
*               mmShowObjectInfo�������������ٶȸ�Delphi�Դ����ٶ����
*             - �������Ҫ�ڴ��鱨�棬�����趨
*               mmSaveToLogFile := False;
*             - ���Ҫ�Զ����¼�ļ��������趨
*               mmErrLogFile := '��ļ�¼�ļ���';
*               Ĭ���ļ���Ϊexe�ļ���Ŀ¼�µ�memory.log
*             - ����ʹ��SnapToFile����ץȡ�ڴ�����״̬��ָ���ļ���
*               �ڳ�����ֹʱ��OutputDebugString���ڴ�ʹ��״����
* ����ƽ̨��PWin98SE + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ����ݲ����ϱ��ػ�����ʽ
* ���¼�¼��2004.03.29 V1.2
*               Ϊ�ܿ�D6D7��TypInfo���µ��󱨣�ʹ�ñ���ָ����� RTTI ��Ϣ��¼��
*               �򿪱��뿪�� LOGRTTI ��������󱨣����� uses �� DB ��Ԫ��ʱ��
*           2003.09.21 V1.1
*               ����ʾ������Ϣ�����ڴ�й©ʱ�����һ�����з���鿴
*               �������趨mmErrLogFile����һ���ڴ�й©�ļ���
*               ԭ�������ڴ��������Ч֮ǰ��mmErrLogFileָ��������ü���Ϊ0��
*             ���������ڴ��������Ч֮���趨��������������ڴ�����������˿ռ䣬
*             ����Ϊ��ȫ�ֵ�mmErrLogFile���ø������������ü���ʼ�մ���0���ַ�
*             �����������ڴ�������ƽ�֮ǰ��ʱ�ͷţ����������ڴ�й©�ļ���
*           2002.08.06 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{
  ��Ԫ���ػ���������
    �뽫�õ�Ԫ���õ����ַ��������¶��嵽CnConsts.pas��Ԫ�У���Դ�ַ�����
    ���λ����CnConsts.pas��Ԫ��β��
    
  ������
    �����ַ���������'�ڴ���������ָ���б�������������б�������'�������ŵ�
    CnConsts.pas��Ԫ�У�����
      SCnMemMgrOutflow = '�ڴ���������ָ���б�������������б�������';
    ����SCnMemMgrOutflow���滻ԭ�ַ���
    
  ע�⣺
    CnConsts��ʹ����Ԥ����ָ���Ӧ����һ��Ӣ�ĵ��ַ���
    ���������resourcestrings�е��ַ�������ͨ�����������ŵ�consts��
    �ظ����ֵ��ַ�����ͬһ����������
    �����ŵ��ַ������ñ��ػ�������') '
    Format�����е��ַ���ҲӦ���д���
    ����������޸���صĵ�Ԫ�汾�š����ػ�˵��   
}

interface

{ $DEFINE LOGRTTI}  // Ĭ�ϲ���¼ RTTI ��Ϣ������D67�µ� TypInfo ��Ԫ�������

var
  GetMemCount: Integer = 0;
  FreeMemCount: Integer = 0;
  ReallocMemCount: Integer = 0;

  mmPopupMsgDlg: Boolean = True;
  mmShowObjectInfo: Boolean = False;
  mmUseObjectList: Boolean = True;
  mmSaveToLogFile: Boolean = False;
  mmErrLogFile: string[255] = '';

procedure SnapToFile(Filename: string);

implementation

uses
  Windows, SysUtils{$IFDEF LOGRTTI}, TypInfo{$ENDIF};

const
  MaxCount = High(Word);

var
  OldMemMgr: TMemoryManager;
  ObjList: array[0..MaxCount] of Pointer;
  FreeInList: Integer = 0;
  StartTime: DWORD;

{-----------------------------------------------------------------------------
  Procedure: AddToList
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: P: Pointer
  Result:    None
  ���ָ��
-----------------------------------------------------------------------------}

procedure AddToList(P: Pointer);
begin
  if FreeInList > High(ObjList) then
  begin
    MessageBox(0, '�ڴ���������ָ���б�������������б�������',
      '�ڴ���������', mb_ok + mb_iconError);
    Exit;
  end;
  ObjList[FreeInList] := P;
  Inc(FreeInList);
end;

{-----------------------------------------------------------------------------
  Procedure: RemoveFromList
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: P: Pointer
  Result:    None
  �Ƴ�ָ��
-----------------------------------------------------------------------------}

procedure RemoveFromList(P: Pointer);
var
  I: Integer;
begin
  for I := Pred(FreeInList) downto 0 do
    if ObjList[I] = P then
    begin
      Dec(FreeInList);
      Move(ObjList[I + 1], ObjList[I], (FreeInList - I) * SizeOf(Pointer));
      Exit;
    end;
end;

{-----------------------------------------------------------------------------
  Procedure: SnapToFile
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: Filename: string
  Result:    None
  Modify:    ���¹���(yygw@yygw.net) 2002.08.06
             Ϊ���㱾�ػ�����������һЩ���� 
             ����ɶ��Ա�ԭ���½� :-( 
  ץȡ����
-----------------------------------------------------------------------------}

procedure SnapToFile(Filename: string);
var
  OutFile: TextFile;
  I, CurrFree, BlockSize: Integer;
  HeapStatus: THeapStatus;
  NowTime: DWORD;

  {$IFDEF LOGRTTI}
  Item: TObject;
  ptd: PTypeData;
  ppi: PPropInfo;
  {$ENDIF}

{-----------------------------------------------------------------------------
  Procedure: MSELToTime
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: const MSEL: DWORD
  Result:    string
  ת��ʱ��
-----------------------------------------------------------------------------}

  function MSELToTime(const MSEL: DWORD): string;
  begin
    Result := Format('%d Сʱ %d �� %d �롣', [MSEL div 3600000, MSEL div 60000,
      MSEL div 1000]);
  end;

begin
  AssignFile(OutFile, Filename);
  try
    if FileExists(Filename) then
      Append(OutFile)
    else
      Rewrite(OutFile);
    NowTime := GetTickCount - StartTime;
    HeapStatus := GetHeapStatus;
    with HeapStatus do
    begin
      Writeln(OutFile, ':::::::::::::::::::::::::::::::::::::::::::::::::::::');
      Writeln(OutFile, DateTimeToStr(Now));
      Writeln(OutFile);
      Writeln(OutFile, '��������ʱ��: ' + MSELToTime(NowTime));
      Writeln(OutFile, Format('���õ�ַ�ռ�: %d ǧ�ֽ�', [TotalAddrSpace div 1024]));
      Writeln(OutFile, Format('δ�ύ����: %d ǧ�ֽ�', [TotalUncommitted div 1024]));
      Writeln(OutFile, Format('���ύ����: %d ǧ�ֽ�', [TotalCommitted div 1024]));
      Writeln(OutFile, Format('���в���: %d ǧ�ֽ�', [TotalFree div 1024]));
      Writeln(OutFile, Format('�ѷ��䲿��: %d ǧ�ֽ�', [TotalAllocated div 1024]));
      Writeln(OutFile, Format('��ַ�ռ�����: %d%%', [TotalAllocated div (TotalAddrSpace div 100)]));
      Writeln(OutFile, Format('ȫ��С�����ڴ��: %d ǧ�ֽ�', [FreeSmall div 1024]));
      Writeln(OutFile, Format('ȫ��������ڴ��: %d ǧ�ֽ�', [FreeBig div 1024]));
      Writeln(OutFile, Format('����δ���ڴ��: %d ǧ�ֽ�', [Unused div 1024]));
      Writeln(OutFile, Format('�ڴ����������: %d ǧ�ֽ�', [Overhead div 1024]));
    end; //end with HeapStatus
    CurrFree := FreeInList;
    Writeln(OutFile);
    Write(OutFile, '�ڴ������Ŀ: ');
    if mmUseObjectList then
    begin
      Write(OutFile, CurrFree);
      if not mmShowObjectInfo then
        Writeln(OutFile);
    end
    else
    begin
      Write(OutFile, GetMemCount - FreeMemCount);
      if GetMemCount = FreeMemCount then
        Write(OutFile, '��û���ڴ�й©��')
      else
        Write(OutFile, '��');
      Writeln(OutFile);
    end; //end if mmUseObjectList
    if mmUseObjectList and mmShowObjectInfo then
    begin
      if CurrFree = 0 then
      begin
        Write(OutFile, '��û���ڴ�й©��');
        Writeln(OutFile);
      end
      else
      begin
        Writeln(OutFile);
        for I := 0 to CurrFree - 1 do
        begin
          BlockSize := PDWORD(DWORD(ObjList[I]) - 4)^;
          Write(OutFile, Format('%4d) %s - %4d', [I + 1,
            IntToHex(Cardinal(ObjList[I]), 16), BlockSize]));
          Write(OutFile, Format('($%s)�ֽ� - ', [IntToHex(BlockSize, 4)]));

          {$IFDEF LOGRTTI}
          try
            Item := TObject(ObjList[I]);
            //Use RTTI, in IDE may raise exception, But not problems
            if PTypeInfo(Item.ClassInfo).Kind <> tkClass then
              Write(OutFile, '���Ƕ���')
            else
            begin
              ptd := GetTypeData(PTypeInfo(Item.ClassInfo));
              //�Ƿ��������
              ppi := GetPropInfo(PTypeInfo(Item.ClassInfo), 'Name');
              if ppi <> nil then
              begin
                Write(OutFile, GetStrProp(Item, ppi));
                Write(OutFile, ' : ');
              end
              else
                Write(OutFile, '(δ����): ');
              Write(OutFile, PTypeInfo(Item.ClassInfo).Name);
              Write(OutFile, Format(' (%d �ֽ�) - In %s.pas',
                [ptd.ClassType.InstanceSize, ptd.UnitName]));
            end; //end if GET RTTI
          except
            on Exception do
              Write(OutFile, '���Ƕ���');
          end; //end try
          {$ENDIF}

          Writeln(OutFile);
        end;
      end; //end if CurrFree
    end; //end if mmUseObjectList and mmShowObjectInfo
  finally
    CloseFile(OutFile);
  end; //end try
end;

{-----------------------------------------------------------------------------
  Procedure: NewGetMem
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: Size: Integer
  Result:    Pointer
  �����ڴ�
-----------------------------------------------------------------------------}

function NewGetMem(Size: Integer): Pointer;
begin
  Inc(GetMemCount);
  Result := OldMemMgr.GetMem(Size);
  if mmUseObjectList then
    AddToList(Result);
end;

{-----------------------------------------------------------------------------
  Procedure: NewFreeMem
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: P: Pointer
  Result:    Integer
  �ͷ��ڴ�
-----------------------------------------------------------------------------}

function NewFreeMem(P: Pointer): Integer;
begin
  Inc(FreeMemCount);
  Result := OldMemMgr.FreeMem(P);
  if mmUseObjectList then
    RemoveFromList(P);
end;

{-----------------------------------------------------------------------------
  Procedure: NewReallocMem
  Author:    Chinbo(Chinbo)
  Date:      06-����-2002
  Arguments: P: Pointer; Size: Integer
  Result:    Pointer
  ���·���
-----------------------------------------------------------------------------}

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Inc(ReallocMemCount);
  Result := OldMemMgr.ReallocMem(P, Size);
  if mmUseObjectList then
  begin
    RemoveFromList(P);
    AddToList(Result);
  end;
end;

const
  NewMemMgr: TMemoryManager = (
    GetMem: NewGetMem;
    FreeMem: NewFreeMem;
    ReallocMem: NewReallocMem);

initialization
  StartTime := GetTickCount;
  GetMemoryManager(OldMemMgr);
  SetMemoryManager(NewMemMgr);

finalization
  SetMemoryManager(OldMemMgr);
  if (GetMemCount - FreeMemCount) <> 0 then
  begin
    if mmPopupMsgDlg then
      MessageBox(0, PChar(Format('���� %d ���ڴ�©����',
        [GetMemCount - FreeMemCount])), '�ڴ���������', MB_OK)
    else
      OutputDebugString(PChar(Format('���� %d ���ڴ�©����', [GetMemCount -
        FreeMemCount])));
  end;
  OutputDebugString(PChar(Format('Get = %d  Free = %d  Realloc = %d',
    [GetMemCount,
    FreeMemCount, ReallocMemCount])));
  if mmErrLogFile = '' then
    mmErrLogFile := ExtractFileDir(ParamStr(0)) + '\Memory.Log';
  if mmSaveToLogFile then
    SnapToFile(mmErrLogFile);

end.
