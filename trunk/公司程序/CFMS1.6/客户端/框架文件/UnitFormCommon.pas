unit UnitFormCommon;

interface

uses Forms, SysUtils, StringUtils, Classes, Variants, Windows, ComCtrls;

  procedure IniFormStyle(aForm: TForm);
  //树图定位
  function JudgeNode(aText1,aText2: string):boolean;
  function GetLocateFirstNode(aTreeView: TTreeView; aPathList: TStringList): TTreeNode;overload;
  function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string): TTreeNode;overload;
  function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer): TTreeNode;overload;
  //根据路径定位节点   //浙江省，杭州市，西湖区，MTU001
  function GetLocateNode(aTreeView: TTreeView; aPathList: TStringList): TTreeNode;overload;



  //获取指定区域下所有的叶子节点
  function GetAreaChildLeaf(aAreaid: integer): string;
  //获取指定维护单位下所有的叶子节点
  function GetCompanyChildLeaf(aCompanyid: integer): string;
  //根据用户编号获取当前权限的所有维护单位
  function GetCompanysByUser(aCityid, aUserid: integer): string;
  //根据用户自定义加载字段
  //procedure LoadFields(aCityid, aUserid: integer; aCxGridHelper: TCxGridSet; aFieldGroup: integer);
  function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;

  var
    FPathListIndex: integer;
    FIsLocateEffect: boolean;

implementation

uses UnitDataModuleLocal;


function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
var
  LocalFileTime : TFileTime;
  fhandle:integer;
  DosFileTime : DWORD;
  FindData : TWin32FindData;
begin
  fhandle := FindFirstFile(Pchar(FileName), FindData);
  if (FHandle <> INVALID_HANDLE_VALUE) then
     begin
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          case TimeFlag of
          1:
            begin
               FileTimeToLocalFileTime(FindData.ftCreationTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            3:
            begin
               FileTimeToLocalFileTime(FindData.ftLastAccessTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            2:
            begin
               FileTimeToLocalFileTime(FindData.ftLastWriteTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
           end;  //case;
        end;
     end;
end;

function GetCompanysByUser(aCityid, aUserid: integer): string;
var
  lSqlstr:string;
begin
  lSqlstr:='select t.companyid from companyinfo t'+
           ' start with t.companyid in (select t.companyid from userinfo t where t.userid='+inttostr(aUserid)+
           ' and t.cityid='+inttostr(aCityid)+') and t.cityid='+inttostr(aCityid)+
           ' connect by prior t.companyid=t.parentid';
  with DataModuleLocal.ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([2,4,12]),0);
    first;
    while not eof do
    begin
      result:=result+ FieldByName('id').AsString+',';
      next;
    end;
  end;
end;

function GetCompanyChildLeaf(aCompanyid: integer): string;
var
  lSqlstr : string;
begin
  lSqlstr:='select a.*'+
         ' from'+
         ' (select ROW_NUMBER () OVER (PARTITION BY part ORDER BY lev DESC) rn,a.*'+
         '   from'+
         '   (SELECT  level AS Lev,level-rownum as part,a.*'+
         '    FROM companyinfo a start with  a.companyid='+inttostr(aCompanyid)+' CONNECT BY PRIOR a.companyid=a.parentid'+
         '    order siblings  by a.companyid'+
         '    ) a'+
         ' ) a'+
         ' where a.rn=1';
  with DataModuleLocal.ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([2,4,12]),0);
    first;
    while not eof do
    begin
      result:=result+ FieldByName('id').AsString+',';
      next;
    end;
  end;
end;

function GetAreaChildLeaf(aAreaid: integer): string;
var
  lSqlstr : string;
begin
  lSqlstr:='select a.*'+
         ' from'+
         ' (select ROW_NUMBER () OVER (PARTITION BY part ORDER BY lev DESC) rn,a.*'+
         '   from'+
         '   (SELECT  level AS Lev,level-rownum as part,a.*'+
         '    FROM areas a start with  a.id='+inttostr(aAreaid)+' CONNECT BY PRIOR a.id=a.parent_id'+
         '    order siblings  by a.id'+
         '    ) a'+
         ' ) a'+
         ' where a.rn=1';
  with DataModuleLocal.ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([2,4,12]),0);
    first;
    while not eof do
    begin
      result:=result+ FieldByName('id').AsString+',';
      next;
    end;
  end;
end;

function GetLocateNode(aTreeView: TTreeView;
  aPathList: TStringList): TTreeNode;overload;
var
  lCurrNode: TTreeNode;
begin
  lCurrNode:= GetLocateFirstNode(aTreeView,aPathList);
  while lCurrNode<>nil do
  begin
    if fPathListIndex+1>=aPathList.Count then break;
    inc(fPathListIndex);
    lCurrNode:= GetLocateNode(lCurrNode,aPathList,fPathListIndex);
  end;
  result := lCurrNode;
end;

function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList;
  aPathIndex: integer): TTreeNode;overload;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aPathList.Strings[aPathIndex]) then
    begin
      result:= lNode;
      break;
    end;
    lNode:= lNode.getNextSibling;
  end;
end;

function GetLocateFirstNode(aTopNode: TTreeNode;
  aKeyValue: string): TTreeNode;overload;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aKeyValue) then
    begin
      result:= lNode;
    end
    else
    begin
      result:= GetLocateFirstNode(lNode,aKeyValue);
    end;
    if result<>nil then break;
    lNode:= lNode.getNextSibling;
  end;
end;

function GetLocateFirstNode(aTreeView: TTreeView;
  aPathList: TStringList): TTreeNode;overload;
var
  lFirstNode: TTreeNode;
  lKeyValue: string;
begin
  result:= nil;
  FPathListIndex:= 0;
  lFirstNode:= aTreeView.Items.GetFirstNode;
  if (lFirstNode=nil) or (aPathList.Count=0) then
  begin
    FIsLocateEffect:= false;
    exit;
  end;
  lKeyValue:= aPathList.Strings[fPathListIndex];
  if JudgeNode(lFirstNode.Text,lKeyValue) then
  begin
    result:= lFirstNode;
  end
  else
  begin
    result:= GetLocateFirstNode(lFirstNode,lKeyValue);
  end;
end;

function JudgeNode(aText1,aText2: string):boolean;
begin
  if uppercase(trim(aText1))=uppercase(trim(aText2)) then
    result:= true
  else result:= false;
end;

procedure IniFormStyle(aForm: TForm);
begin
  aForm.WindowState:=wsMaximized;
  
//  aForm.BorderIcons:= [biMinimize,biMaximize];

  aForm.Font.Charset:= GB2312_CHARSET;
  aForm.Font.Height:= -12;
  aForm.Font.Name:= '宋体';
  aForm.Font.Size:= 9;
end;

end.
