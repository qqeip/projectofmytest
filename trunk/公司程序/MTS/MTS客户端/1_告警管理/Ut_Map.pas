unit Ut_Map;

interface

uses
  Windows,Controls,MapXLib_TLB,Dialogs,SysUtils,Variants,AXCtrls,Graphics,Classes,
  Messages,CheckLst,IniFiles,Forms,ComCtrls,ExtCtrls,StdCtrls,DateUtils,StrUtils,
  DBClient,Contnrs;
const
//�Զ�����Ϣ
  WM_USER_MARQUEE=Wm_User+1001;
 //GIS ����
  ChangePOS = 495; //��ȡ��γ��
  PosInfo =   496; //��ȡ��γ��
  CSConnect = 497; //������վ
  CSINFO = 498;    //��վ��Ϣ 
  DistInfo =  499;
  MTUINFO =   500; //��ȡ����Ϣ
  MTUALARM= 501;   //MTU�澯
  AreaInfo= 502;
  //Theme param
  CellX = 0.0001;
  CellY = 0.00009;
var
  LongStr,LatStr : String;
  TColors : array[0..21]  of TColor
           =(clRed,clYellow,clBlue,clMaroon,clGreen,clNavy,clOlive,clPurple,clTeal,
             clGray,clSilver,clLime,clFuchsia,clAqua,clLtGray,clDkGray,clMoneyGreen,
             clSkyBlue,clCream,clScrollBar,clBackground,
             clHighlight); //);

type
  TLyrListInfo=class  //ͼ���б���Ϣ
  public
    LayerPath : string; //·�� ��������/
    LayerName : string; //����
    LayerProp : integer;//0 :�û�ͼ�� 1��ϵͳ��ʱͼ�� 2 ��ϵͳͼ��
    Visible : boolean ;//�Ƿ�ɼ�
 end;
 TThemeParam = Class(TObject)
  Public
    Pix : integer;
    Rows : integer;
    Cols : integer;
    RealHeight : integer;
    RealWidth : integer;
    RealX1 : Double;
    RealX2 : Double;
    RealY1 : Double;
    RealY2 : Double;
    BufX1 : Double;
    BufX2 : Double;
    BufY1 : Double;
    BufY2 : Double;
  end;
Type
  TMapObj = Class(TControl)

  Private
    AMap : TMap;
    MesCon : TControl;
    AClientDataSet : TClientDataSet; //�ͻ���Ӧ�� clientdataset
    LocalList,TemListDevice,DeviceIDList,partlist : TStringList;
    OriStyle : CMapXStyle;
    MouseFlag,DataFlag : integer;
    Xold,Yold : double;   //�ı�ǰ �Ļ�վ��γ��
    OldSybolName : string;//�ı�� ����ʽ����
    //DeviceIdList : TStringList; //�����豸���к�
    Procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
   Public
    MtuStyle,CSStyle :String;
    MTUSIZE,CSSIZE :Integer;
    Constructor Create(AOwner : TMap);Reintroduce;
    Destructor Destroy ; override;
    procedure SetMouseListening(Flag: integer);
     {����POPMapCS,POPMapCSC,POPMapPA,POPMapGW  ����ͼ��}
    procedure  ImportCmmMap(FileDir: String;Flag : integer);
    //��������ͼ�㼰һ��CStempAnimate ��ʱͼ��
    procedure ImportDefaultMap;   //�����û��Զ����ͼ
  end;



  TLyrControl = Class(TControl)
  Private
    AMap : TMap;
    AList : TCheckListBox;
    MesCon : TControl;
    Style,DTStyle : CMapXStyle;
    OpenDialog1 : TOpenDialog;
    SaveDialog1 : TSaveDialog;
    MapFlag : integer;
    LyrPath,Systempath,ItemName : String;
    Procedure ClickCheckEvent(Sender : TObject);
    //Procedure MouseDownEvent(Sender: TObject;
      //Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InitMaplist(IFlag : integer);
    Procedure initialMapList(IFlag : integer);
    Procedure IndexofMap(var FName : String );
    procedure DealOk;//---�׻Խ� �޸� ����ȷ����ť
    procedure AddMapvarlist;//---����checklistbox������
    function  IsUserMap(fileext,MapName : string):boolean;//---�ж��Ƿ����û�ͼ��
    function  GetLayerIndex(LayerName : string):integer;//ȡ��ͼ��index
  Public
    Constructor Create(AOWner : TMap);Reintroduce;
    Destructor Destroy ; Override;
    Procedure InitLyrCtrWin(Syspath : String ; MapListBox : TCheckListBox);
    Procedure LoadMaplist;
    Procedure AddMap;
    Procedure DeleteMap;
    Procedure InputTempLate;
    Procedure ExportTempLate;
    Procedure DeleteAll;
    Procedure UpItem;
    Procedure DownItem;
    Procedure OK(TheFlag:integer);
    Procedure Cancel;
    Procedure RegMes(Sender : TControl);
    {
    ��Ϣ�ţ�WM_User+995
    LParam : 0 ������
    LParam : 1 ����
    WParam ��1 ����ģ�尴ť
    WParam : 2 �����ƶ���ť
    WParam : 3 �����ƶ���ť
    WParam : 1111 �ر�ͼ����ƴ���
    WParam : 2222 �����ص�ͼ����ƴ�����ģ̬�ķ�ʽ��ʾ����
    }
  end;

  TMapTools = Class(TControl)
  Private
    AMap : TMap;
    Procedure ToolUsedEvent(Sender: TObject; ToolNum: Smallint;
      X1, Y1, X2, Y2, Distance: Double; Shift, Ctrl: WordBool;
      var EnableDefault: WordBool);
  Public
    Constructor Create(AOWner : TMap);Reintroduce;
    Destructor Destroy ; Override;
    Procedure DeleteFeatureSelf(LyrName : String);

    Procedure SetPanTool;
    Procedure SetZoomInTool;
    Procedure SetZoomOutTool;
    procedure SetArrowTool;
    procedure SetPointMtuInfoTool;
    procedure SetSelectTool(Lyr : string); overload;
    procedure SetSelectTool;overload;

  end;
  TMapEye = Class(TControl)
  Private
    EyeFlag : integer;
    EyeRect : CMapXRectangle;
    EyeStyle : CMapXStyle;
    AMap,EyeMap : TMap;
    MouseDown : Boolean;
    Procedure DrawBoundary;
  Public
    Constructor Create(EMap,MainMap : TMap);Reintroduce;
    Destructor Destroy ; Override;
    Procedure InitMapEye(SysPath : String);
    Procedure MouseDownEvent(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure MouseUpEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    Procedure SetBackStyle;
    Procedure SetBoundStyle;
    Procedure MapViewChangedEvent(Sender : TObject);
  end;

    TThemeObj = Class(TControl)
  Private
    AMap : TMap;

  Public
    ThemesThm : CMapXTheme;
    Constructor Create(AOWner : TMap);Reintroduce;
    Destructor Destroy ; Override;
    //ɸѡ�����о�γ�ȵĻ�վ��ͼ��ΪFieldName   =1 ��ʾ������ֵר��ͼ   ����ֵ�ֶ�ΪFieldName
    procedure DrawIndividualTheme(ValueArray: Variant;FieldName : String);overload;
    procedure DrawIndividualTheme(LyrName:string;ValueArray: Variant;
        FieldName:String;ThemeName:string);overload;
     procedure RemoveTheme(ThemeName:string);
  end;

implementation

constructor TMapObj.Create(AOwner: TMap);
begin
  AMap := AOWner;
  AMap.AreaUnit := 15;
  AMap.MapUnit := 7;
  AMap.PaperUnit := 7;
  AMap.MousewheelSupport := 3;
  MouseFlag := 0;
  DataFlag := 0;
  AClientDataSet := TClientDataSet.Create(nil);
  Xold := 0;
  Yold := 0;
  OldSybolName :='';
  TemListDevice := TStringList.Create;
  DeviceIDList := TStringList.Create;
  partlist := TStringList.Create;
  LocalList:=TStringList.Create;
end;

procedure TMapObj.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  MapxStr,MapyStr:string;
  MapX,MapY:double;
  ScreenX,ScreenY:Single;
  i:integer;
begin
  if MouseFlag = 1 then
    begin
      ScreenX := X;
      ScreenY := Y;
      AMap.ConvertCoord(ScreenX,ScreenY,MapX,MapY,miScreenToMap);
      MapXstr := Floattostr(MapX);
      MapXStr := Format('%.10s',[mapxstr]);
      LongStr := MapXStr;
      MapYstr := Floattostr(MapY);
      MapYStr := Format('%.9s',[mapystr]);
      LatStr  := MapYStr;
      Try
        //���� �ݲ���   qiusy 06-12-27
       { LocalList.Clear;
        LocalList.Add(MapXStr);
        LocalList.Add(MapYStr);  }
        MesCon.Perform(WM_User+997,0,0);
      except
        MessageDLG('û�м������λ�ã�',mtWarning,[mbOK],0);
      end;
    end;
end;

destructor TMapObj.Destroy;
begin
  TemListDevice.Free;
  DeviceIDList.Free;
  partlist.Free;
  if DataFlag = 1 then
    AClientDataSet.Free;
  inherited;
end;

procedure TMapObj.SetMouseListening(Flag: integer);
begin
  AMap.OnMouseMove := MouseMoveEvent;
  MouseFlag := Flag ;
end;

procedure TMapObj.ImportCmmMap(FileDir: String;Flag : integer);
{----------------------------------------------}
{FileDir : ϵͳ·��                            }
{Flag :��1 ��ʾ��Ӫͼ����2 ��ʾ�滮ͼ   ???       }
{��Ӫͼ ֻ��POPMapCSͼ�����ʱͼ��             }
var
  CSStyle : CMapXStyle;
  i :integer;
  Font : TFont;
  RegionStyle : CMapXStyle;
  Lyr : CMapXLayer;
begin
  CSStyle := coStyle.Create;
  CSStyle.SymbolType := 1;
  CSStyle.SymbolBitmapTransparent := True;
  CSStyle.SymbolBitmapName := '500mw.bmp';
  CSStyle.SymbolBitmapSize := 14;

  RegionStyle :=CoStyle.Create;
  RegionStyle.TextFontColor := miColorBlue;
  RegionStyle.RegionPattern  :=0;
  RegionStyle.RegionBorderColor :=miColorBlue;
  RegionStyle.RegionTransparent := true;

  ImportDefaultMap;
end;

procedure TMapObj.ImportDefaultMap;
var
  MapIni : TIniFile;
  path : string;
  SectionList :TStringList;
  i : integer;
  _CenterX,_CenterY,_XMin,_XMax,_YMin,_YMax : Double;
  Filename : string;
  Layer : CMapXLayer;
  _visible : boolean;
  MapRect :CMapXRectangle;
begin
  SectionList := TStringList.Create;
  try
    Path :=ExtractFilePath(Application.ExeName)+'GIS\Map.ini';
    if FileExists(path) then //----���û��Զ���ĵ�ͼ
    begin
      MapIni := TIniFile.Create(path);
      try
        Mapini.ReadSections(SectionList);
        for i :=0 to SectionList.Count-1 do
        begin
          if uppercase(SectionList.Strings[i])=uppercase('Center') then
            begin
              _CenterX :=MapIni.ReadFloat(SectionList.Strings[i],'CenterX',0);
              _CenterY :=MapIni.ReadFloat(SectionList.Strings[i],'CenterY',0);
            end
          else if uppercase(SectionList.Strings[i])=uppercase('Bounds') then
          begin
            _XMin :=MapIni.ReadFloat(SectionList.Strings[i],'XMin',0);
            _XMax :=MapIni.ReadFloat(SectionList.Strings[i],'XMax',0);
            _YMin :=MapIni.ReadFloat(SectionList.Strings[i],'YMin',0);
            _YMax :=MapIni.ReadFloat(SectionList.Strings[i],'YMax',0);
          end;
        end;
        AMap.CenterX := _CenterX;
        Amap.CenterY :=_CenterY;
        MapRect :=CoRectangle.Create;
        MapRect.Set_(_XMin,_YMin,_XMax,_YMax);
        Amap.Bounds :=MapRect;
      finally
        MapIni.Free;
      end;
    end;
  finally
    SectionList.Free;
  end;
end;


{TLyrControl}
procedure TLyrControl.AddMap;
var
  i,id,nums : integer;
  LyrName,LyrPathName,Str : String;
  Tof : TextFile;
  Flag : integer;
  MapNameStr : Array [0..100] of String;
  ButtonFlag : Boolean;
  LyrListInfo : TLyrListInfo;
begin
  i := 0;
  OpenDialog1.Title := '�򿪵�ͼ';
  OpenDiaLog1.Filter := 'MapInfo Tables (*.tab)|*.tab';
  if OpenDialog1.Execute then
    begin
        Lyrpath:=extractfilepath(OpenDialog1.Files.Strings[i]);
        for i:=0 to OpenDialog1.Files.count-1 do
          begin
            lyrName := OpenDialog1.Files.Strings[i];
           // LyrPathName := Format('%-300s',[LyrName]) ;
            if pos('.TAB',UpperCase(LyrName)) > 0 then
              begin
                LyrName := Copy(lyrName,1,pos('.TAB',UpperCase(LyrName))-1);
                LyrName := extractfilename(LyrName);
                if Alist.Items.IndexOf(LyrName) >=0 then //��ʾ�ĵ�ͼ�Ѿ����� ������һ��ͬ���ĵ�ͼ ��֧�ֵ���
                  continue;
                LyrName := Format('%-30s',[LyrName]);
               // str :=Lyrname + lyrpathName;
               // Writeln(tof,Str) ;
                Lyrpath:=ExtractFileDir(OpenDialog1.Files.Strings[i]);
                LyrListInfo := TLyrListInfo.Create;
                LyrListInfo.LayerPath :=trim(LyrPath)+'\'+trim(LyrName)+'.tab';
                LyrListInfo.LayerName :=trim(LyrName);
                LyrListInfo.LayerProp :=0;
                LyrListInfo.Visible := true;
                id:=Alist.Items.AddObject(LyrName,LyrListInfo) ;
               // AList.Items.Add(LyrName);
                //id := AList.Items.IndexOf(LyrName);
                AList.Checked[id] := True;
              end;
          end;  
        //if OpenDiaLog1.Files.Count > 0 then
       //   CloseFile(Tof);
    //    ButtonFlag := True;
    //  if FileExists(systemPath+'\Layers\Temp.ini') then
    //     ButtonFlag := False;
      if ButtonFlag then
        MesCon.Perform(WM_User+995,1,1)
      else
        MesCon.Perform(WM_User+995,1,0);
    end;

end;

procedure TLyrControl.AddMapvarlist;
var
  i : integer;
  Filename,LayerName : string;
  From ,_to: integer;
  Layer : CMapXLayer;
begin
  //-------------------------
  for i :=0 to AList.Count-1 do
  begin
    LayerName :=Trim((TLyrListInfo(alist.Items.Objects[i]).LayerName));
    Filename := TLyrListInfo(alist.Items.Objects[i]).LayerPath;
    if TLyrListInfo(alist.Items.Objects[i]).LayerProp=0 then  //---�û�ͼ��
    begin
      Layer :=Amap.Layers.Add(Filename,Amap.Layers.Count+1);
      Layer.Visible :=TLyrListInfo(alist.Items.Objects[i]).Visible;
    end
    else //----------����ϵͳͼ��
    begin
     // AMap.Layers.Move(Amap.)
     From :=GetLayerIndex(LayerName);
     _to:= Amap.Layers.Count+1;
     AMap.Layers.Move(from,_to);
     Amap.Layers.Item[LayerName].Visible :=TLyrListInfo(alist.Items.Objects[i]).Visible;
    end;  
  end;
end;

procedure TLyrControl.Cancel;
begin
  if Fileexists(systempath+'\Layers\Temp') then
    DeleteFile(systempath+'\Layers\Temp');
  MesCon.Perform(WM_User+995,1111,0);
end;

procedure TLyrControl.ClickCheckEvent(Sender: TObject);
var
  Myini : TiniFile;
  visibleStr : String;
begin
  if Not FileExists(systemPath+'\Layers\Temp') then
    begin
      Myini := TiniFile.Create(systemPath+'\Layers\Temp.ini');
      visibleStr := Myini.ReadString(itemName,'visible','');
      if trim(visibleStr) = '1' then
        Myini.WriteString(itemName,'visible','0')      
      else
        Myini.WriteString(itemName,'visible','1');
    end
  else
    begin
      if Fileexists(systemPath+'\Layers\Temp.ini') then
        begin
          MesCon.Perform(WM_User+995,1,0);
        end;
    end;
end;

constructor TLyrControl.Create(AOWner: TMap);
begin
  AMap := AOWner;
  AMap.AreaUnit := 15;
  AMap.MapUnit := 7;
  AMap.PaperUnit := 7;
  AMap.MousewheelSupport := 3;
  OpenDialog1 := TOpenDialog.Create(nil);
  OpenDialog1.Options := [ofAllowMultiSelect];
  SaveDialog1 := TSaveDialog.Create(nil);
  SaveDialog1.Title := '����ģ��';
  SaveDialog1.Filter := 'TempLate (*.MOD)|*.MOD';
  SaveDialog1.Options :=[ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofEnableSizing];
  MapFLag := 0;
end;

procedure TLyrControl.DealOk;
var
  i,listcount : integer;
begin
  //----����ͼ����ӻ�״̬
  for i :=0 to Alist.Count-1 do
    TLyrListInfo(Alist.Items.Objects[i]).Visible :=Alist.Checked[i];
  //-----------------------remove user map tab file
  //1 ���ȴ�Alist ���ҵ����е� ϵͳͼ�� ,��Щͼ���ǲ���remove��
  listcount :=Amap.Layers.Count;
  for i:=listcount downto 1 do
  begin
    if IsUserMap(UpperCase(ExtractFileExt(AMap.Layers.Item[i].Filespec)),UpperCase(AMap.Layers.Item[i].Name)) then
      Amap.Layers.Remove(i);
  end;
  //----���¼��� ����checklistbox������
  AddMapvarlist;
end;

procedure TLyrControl.DeleteAll;
var
  i : integer;
  LyrProp : integer;
begin
  For i := AList.Items.Count -1 downto 0 do
    begin
      //-----ϵͳͼ�㲻��ɾ��
      try
      LyrProp :=TLyrListInfo(AList.Items.Objects[i]).LayerProp;
      except   //--�쳣��Ĭ��Ϊ���û�ͼ��
      LyrProp :=-1;
      end;
      if LyrProp=0 then
      begin
      Alist.Items.Objects[i].Free;
      AList.Items.Delete(i);
      end;
    end;
  DeleteFile(systemPath+'\Layers\Temp.ini');
  MesCon.Perform(WM_User+995,1,0)
end;

procedure TLyrControl.DeleteMap;
var
  MapNameStr,MapPathStr,SS : String;
  i,id: integer;
  FromF,toF : TextFile;
  Myini : TiniFile;
begin
  //---����free����  2006-11-20 �׻Խ�  �����
  Id :=Alist.ItemIndex;
  if id<0 then //<=   qiusy
  exit;
  try
  if TLyrListInfo(Alist.Items.Objects[id]).LayerProp<>0 then
  exit;
  TLyrListInfo(Alist.Items.Objects[id]).Free;
  except ;
  end;
  AList.Items.Delete(id);

  if id >=Alist.Count-1 then   //---ɾ�������ͽ����һ��ѡ��
    id :=Alist.Count-1;
  If Alist.Count<>0 Then  //qiusy
     Alist.Selected[id]:=true;
  if AList.Count = 0 then
    MesCon.Perform(WM_User+995,1,0)
  else
    MesCon.Perform(WM_User+995,1,1);
end;

destructor TLyrControl.Destroy;
begin
  OpenDialog1.Free;
  SaveDialog1.Free;
  inherited;
end;

procedure TLyrControl.DownItem;
var
  i,SelectedIndex : integer;
  Flag1,Flag2,TmpStr : String;
begin
  SelectedIndex :=Alist.ItemIndex;
  if SelectedIndex+1 = Alist.Count then
    begin
      MesCon.Perform(WM_User+995,2,1); //up enable=false;
      MesCon.Perform(WM_User+995,3,0); //down =false;
    end
  else
    begin
      MesCon.Perform(WM_User+995,2,1); //up =true;
      MesCon.Perform(WM_User+995,3,1); //down=true;
    end;
  If SelectedIndex+1 <> Alist.Count Then
     Alist.Items.Exchange(SelectedIndex,SelectedIndex+1);

end;

procedure TLyrControl.ExportTempLate;
var
  i : integer;
  SaveName,mapNameStr,MappathStr,Str,pathName : String;
  Myini : TiniFile;
  tof : TextFile;
  fhandle : THandle;
  MapIni : TIniFile;
  MapKind : integer;
  SectionName, LayerPath : string;
  changeflag : boolean;
  Ext : string;
  deleted  :boolean;
begin
  //-----�׻Խ� �޸�   ��ģ������Ϊini�ļ�����
  If SaveDialog1.Execute then
    begin

      if pos('.MOD',upperCase(SaveDialog1.FileName))>0 then
      begin
        SaveName :=ChangeFileExt(SaveDialog1.FileName,'.ini')
      end
      else SaveName := SaveDialog1.FileName+'.ini';
          
      if  FileExists(SaveDialog1.FileName) then //������ɾ��
        begin
          deleted:=DeleteFile(SaveDialog1.FileName);
         // if deleted then
           // ShowMessage('deleted');
        end;
      if not DirectoryExists(ExtractFileDir(SaveName)) then
        MkDir(ExtractFileDir(SaveName));

      MapIni :=TIniFile.Create(SaveName); //---���´��� Map.ini �ļ�
      try
      for i :=0  to AList.Items.Count-1 do
      begin
        MapKind :=TLyrListInfo(AList.Items.Objects[i]).LayerProp; //0 :�û�ͼ�� 1��ϵͳ��ʱͼ�� 2 ��ϵͳͼ��
        if MapKind <>0 then  //---ֻ�����û�ͼ��
          continue;
        SectionName :=TLyrListInfo(AList.Items.Objects[i]).LayerName;
        LayerPath :=TLyrListInfo(AList.Items.Objects[i]).LayerPath;
        MapIni.WriteString(SectionName,'path',LayerPath);
        MapIni.WriteBool(SectionName,'visible',AList.Checked[i]);
      end;
      finally
        mapini.Free;
      end;
      //-----���ini�ļ�������Ϊ.mod�ļ�
     //SaveName :=ExtractFileName()
     //pathName:=ChangeFileExt(SaveName,'MOD');
     if pos('.MOD',UpperCase(SaveDialog1.FileName))>0 then
       RenameFile(SaveName,SaveDialog1.FileName)
     else
     RenameFile(SaveName,SaveDialog1.FileName+'.MOD');
    end;
end;

function TLyrControl.GetLayerIndex(LayerName: string): integer;
var
  i : integer;
begin
  i :=1;
  for i :=1 to Amap.Layers.Count do
  begin
    if uppercase(Amap.Layers.Item[i].Name) =UpperCase(LayerName) then
      begin
      Result :=i;
      break;
      end;
  end;
end;

procedure TLyrControl.IndexofMap(var FName: String);
var
  i,id : integer;
  IDStr,NameStr,Str : String;
  FromF,toF : TextFile;
  fhandle : THandle;
begin
  if not FileExists(FName) then
  begin
    fhandle := FileCreate(FName);
    FileClose(fhandle);
  end;
  Assignfile(FromF,FName);
  AssignFile(tof,FName+'~');
  ReWrite(toF);

  reSet(FromF);
  for i := 0 to AList.Items.Count -1 do
    begin
      if TLyrListInfo(alist.Items.Objects[i]).LayerProp <>0 then
        continue;
      //id := i+9;
      IDStr := Format('%-5s',[inttostr(id)]);
      NameStr := AList.Items.Strings[i];
      NameStr := Format('%-30s',[NameStr]);
      Str := IDStr + NameStr;
      Writeln(tof,Str);
    end;
  Writeln(tof,'END');
  While not SeekEof(FromF) do
    begin
      Readln(FromF,Str);
      Writeln(Tof,Str);
    end;
  CloseFile(TOF);
  CloseFile(FromF);
  DeleteFile(FName);
  CopyFile(pchar(FName+'~'),pchar(Fname),False);
  DeleteFile(Fname+'~');
end;

procedure TLyrControl.initialMapList(IFlag : integer);
var
  i,Flag : integer;
  MapName,MyPathName,Str : String;
  MyIni : TiniFile;
  tof : TextFile;
  Rect : TRect;
begin
{
  IFlag = 1   ���Ƿ���ɫ��ͼ��ͼ�����
  IFlag = 2   CCH�������ߵ�ͼ�����
  IFlag = 3   ��ʧ������ɫ��ͼ������ͼ�����
  IFlag = 4   ·�����ʱ��ͼ�����
  IFlag = 5   �滮����ʱ��ͼ�����
}

  Flag := 0;
  Rect := AMap.BoundsRect;
//  AMap.Layers.RemoveAll;
  if IFlag = 2 then
    begin
      For i := 3 to AMap.Layers.Count do
        AMap.Layers.Remove(3);
    end
  else if IFlag = 4 then
    begin
      For i := 4 to AMap.Layers.Count do
        AMap.Layers.Remove(4);
    end
  else if IFlag = 5 then
    begin
      For i := 2 to AMap.Layers.Count do
        AMap.Layers.Remove(2);
    end
  else
    For i := 2 to AMap.Layers.Count do
      AMap.Layers.Remove(2);
  MyIni := TiniFile.Create(systempath+'\Layers\Temp.ini');
  AssignFile(Tof,systempath+'\Layers\Temp');
  reSet(tof);
  While not SeekEof(tof) do
    begin
      Readln(tof,Str);
      MapName := Trim(copy(str,1,30));
      MyPathName := Trim(Copy(Str,30,300));
      Myini.WriteString(MapName,'visible','1');
      Myini.WriteString(MapName,'path',MyPathName);
    end;
  closeFile(tof);
  DeleteFile(SystemPath+'\Layers\Temp');
  For i := 0 to AList.Count -1 do
    begin
      MapName :=Trim( AList.Items.Strings[i]);
      mypathName := Trim(Myini.ReadString(MapName,'path',''));
      Try
        if MyPathName <> '' then
          AMap.Layers.Add(mypathName,i+9);    //��֤��վͼ�㡢ר��ͼ�㡢·��ͼ���ϵͳͼ��������

        if AList.Checked[i] then
          begin
            Myini.WriteString(MapName,'visible','1');
            AMap.Layers.Item[MapName].Visible := True;
            Try
              AMap.Layers.Item[MapName].Selectable := False;
            except
            end;
          end
        else
          begin
            Myini.WriteString(MapName,'visible','0');
            AMap.Layers.Item[MapName].Visible := False;
            Try
              AMap.Layers.Item[MapName].Selectable := False;
            except
            end;
          end;
      except
        MessageDLG('�޷����ص�ͼ��'+MapName+'����·�����ʽ����ȷ��',mtWarning,[mbOK],0);
      end;
    end;
//  AMap.Layers.Add(Systempath+'\Layers\POPMapCS.tab',1);
  if IFlag = 1 then
  if Fileexists(Systempath+'\Layers\POPMapDT.tab') then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapDT.tab',2);
      AMap.Layers.Item['POPMapDT'].Selectable := False;
      Flag := 1;
    end;
  if IFlag = 4 then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapRegion.tab',4);
      AMap.Layers.Item['POPMapRegion'].Selectable := false;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGroup.tab',5);
      AMap.Layers.Item['POPMapGroup'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGuide.tab',6);
      AMap.Layers.Item['POPMapGuide'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGrid.tab',7);
      AMap.Layers.Item['POPMapGrid'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',8);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end
  else if IFlag = 5 then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapCSC.tab',3);
      AMap.Layers.Item['POPMapCSC'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapPA.tab',4);
      Amap.Layers.Item['POPMapPA'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGW.tab',5);
      Amap.Layers.Item['POPMapGW'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',6);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end
  else
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapRegion.tab',3);
      AMap.Layers.Item['POPMapRegion'].Selectable := false;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGroup.tab',4);
      AMap.Layers.Item['POPMapGroup'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGuide.tab',5);
      AMap.Layers.Item['POPMapGuide'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGrid.tab',6);
      AMap.Layers.Item['POPMapGrid'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',7);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end;
  if IFLag = 1 then
  if Fileexists(Systempath+'\Layers\POPMapGridTheme.tab') then
    begin
      Try
        AMap.Layers.Add(Systempath+'\Layers\POPMapGridTheme.tab',8);
      except
      end;
    end;
  if IFLag = 3 then
  if Fileexists(Systempath+'\Layers\POPMapLossTheme.tab') then
    begin
      Try
        AMap.Layers.Add(Systempath+'\Layers\POPMapLossTheme.tab',8);
      except
      end;
    end;
  if Flag = 1 then
    begin
      AMap.Layers.Item['POPMapDT'].Style := DTStyle;
      AMap.Layers.Item['POPMapDT'].OverrideStyle := True;
    end;
  AMap.BoundsRect := Rect;
  Myini.Free;
end;

procedure TLyrControl.InitLyrCtrWin(Syspath: String;
  MapListBox: TCheckListBox);
begin
  Systempath := SysPath;
  Alist := MapListBox;
  AList.OnClickCheck := ClickCheckEvent;
  //AList.OnMouseDown := MouseDownEvent;
end;

procedure TLyrControl.InitMaplist(IFlag : integer);
var
  i,Flag : integer;
  MapName,MyPathName,Str : String;
  MyIni : TiniFile;
  Rect : TRect;
begin
{
  IFlag = 1   ���Ƿ���ɫ��ͼ��ͼ�����
  IFlag = 2   CCH�������ߵ�ͼ�����
  IFlag = 3   ��ʧ������ɫ��ͼ������ͼ�����
  IFlag = 4   ·�����ʱ��ͼ�����
  IFlag = 5   �滮����ʱ��ͼ�����
}

  Flag := 0;
  Rect := AMap.BoundsRect;
//  AMap.Layers.RemoveAll;
  if IFLag = 2 then
    begin
      For i := 3 to AMap.Layers.Count do
        AMap.Layers.Remove(3);
    end
  else if IFlag = 4 then
    begin
      For i := 4 to AMap.Layers.Count do
        AMap.Layers.Remove(4);
    end
  else if IFlag = 5 then
    begin
      For i := 2 to AMap.Layers.Count do
        AMap.Layers.Remove(2);
    end
  else
    For i := 2 to AMap.Layers.Count do
      AMap.Layers.Remove(2);
  MyIni := TiniFile.Create(systempath+'\Layers\Temp.ini');
  For i := 0 to AList.Count -1 do
    begin
      MapName :=Trim( AList.Items.Strings[i]);
      mypathName := Trim(Myini.ReadString(MapName,'path',''));
      Try
        if MypathName <> '' then
          AMap.Layers.Add(mypathName,i+9);

        if AList.Checked[i] then
          begin
            Myini.WriteString(MapName,'visible','1');
            AMap.Layers.Item[MapName].Visible := True;
            Try
              AMap.Layers.Item[MapName].Selectable := False;
            except
            end;
          end
        else
          begin
            Myini.WriteString(MapName,'visible','0');
            AMap.Layers.Item[MapName].Visible := False;
            Try
              AMap.Layers.Item[MapName].Selectable := False;
            except
            end;
          end;
      except
        MessageDLG('�޷����ص�ͼ��'+MapName+'����·�����ʽ����ȷ��',mtWarning,[mbOK],0);
      end;
    end;
//  AMap.Layers.Add(Systempath+'\Layers\POPMapCS.tab',1);
  if IFlag = 1 then
  if Fileexists(Systempath+'\Layers\POPMapDT.tab') then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapDT.tab',2);
      AMap.Layers.Item['POPMapDT'].Selectable := False;
      Flag := 1;
    end;
  if IFlag = 4 then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapRegion.tab',4);
      AMap.Layers.Item['POPMapRegion'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGroup.tab',5);
      Amap.Layers.Item['POPMapGroup'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGuide.tab',6);
      AMap.Layers.Item['POPMapGuide'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGrid.tab',7);
      AMap.Layers.Item['POPMapGrid'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',8);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end
  else if IFlag = 5 then
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapCSC.tab',3);
      AMap.Layers.Item['POPMapCSC'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapPA.tab',4);
      Amap.Layers.Item['POPMapPA'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGW.tab',5);
      Amap.Layers.Item['POPMapGW'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',6);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end
  else
    begin
      AMap.Layers.Add(Systempath+'\Layers\POPMapRegion.tab',3);
      AMap.Layers.Item['POPMapRegion'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGroup.tab',4);
      Amap.Layers.Item['POPMapGroup'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGuide.tab',5);
      AMap.Layers.Item['POPMapGuide'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMapGrid.tab',6);
      AMap.Layers.Item['POPMapGrid'].Selectable := False;
      AMap.Layers.Add(Systempath+'\Layers\POPMaptempAnimate.tab',7);
      AMap.Layers.Item['POPMaptempAnimate'].Selectable := False;
    end;
  if IFlag = 1 then
  if Fileexists(Systempath+'\Layers\POPMapGridTheme.tab') then
    begin
      Try
        AMap.Layers.Add(Systempath+'\Layers\POPMapGridTheme.tab',8);
      except
      end;
    end;
  if IFlag = 3 then
  if Fileexists(Systempath+'\Layers\POPMapLossTheme.tab') then
    begin
      Try
        AMap.Layers.Add(Systempath+'\Layers\POPMapLossTheme.tab',8);
      except
      end;
    end;
  if Flag = 1 then
    begin
      AMap.Layers.Item['POPMapDT'].Style := DTStyle;
      AMap.Layers.Item['POPMapDT'].Selectable := False;
      AMap.Layers.Item['POPMapDT'].OverrideStyle := True;
    end;
  AMap.BoundsRect := Rect;
  Myini.Free;
end;

procedure TLyrControl.InputTempLate;
var
  Myini : TiniFile;
  FromF,tof : TextFile;
  i,id,nums : integer;
  MaplistName : array [0..100,0..1] of String;
  fileName,Str,pathstr,visiblestr : String;
  Flag : integer;
  LyrListInfo : TLyrListInfo;   //��ͼ�򿪴���
  SectionList : TStringList;
  _visible,buttonflag ,copyed : boolean;
begin
  //----�����ļ�
  try
    OpenDialog1.Title := '����ģ��';
    OpenDialog1.Filter := 'TempLate (*.MOD)|*.MOD';
    if OpenDialog1.Execute then
      begin
        //-------------��ɾ��
        for i :=Alist.Items.Count-1 downto 0 do
        begin
          if TLyrListInfo(alist.Items.Objects[i]).LayerProp =0 then  //ֻɾ���û�ͼ��
          begin
          Alist.Items.Objects[i].Free;
          Alist.Items.Delete(i);
          end;
        end;
        FileName := OpenDialog1.FileName;
        //---����һ���ļ�

        copyed :=CopyFile(pchar(FileName),pchar(ExtractFileDir(FileName)+'\tempmap.ini'),false);
        try
          SectionList := TStringList.Create;

          myini := TIniFile.Create(ExtractFileDir(FileName)+'\tempmap.ini');
          Myini.ReadSections(SectionList);
          for i :=0 to SectionList.Count-1 do
          begin
            Filename:= MyIni.ReadString(SectionList.Strings[i],'path','');
            _visible :=MyIni.ReadBool(SectionList.Strings[i],'visible',false);
            LyrListInfo := TLyrListInfo.Create;
            LyrListInfo.LayerPath :=fileName;
            LyrListInfo.LayerName :=SectionList.Strings[i];
            LyrListInfo.LayerProp :=0;
            id := AList.Items.AddObject(LyrListInfo.LayerName,LyrListInfo);
            AList.Checked[id] :=_visible;
          end;
        finally
          myini.Free;
          SectionList.Free;
          DeleteFile(ExtractFileDir(FileName)+'\tempmap.ini');
        end;
      if ButtonFlag then
        MesCon.Perform(WM_User+995,1,1)
      else
        MesCon.Perform(WM_User+995,1,0);
      end;
  except
   MessageDLG('ģ���ʽ����ȷ��',mtWarning,[mbOK],0);
  end;
  if AList.Count > 0 then
    MesCon.Perform(WM_User+995,1,1)
  else
    MesCon.Perform(WM_User+995,1,0);
end;

function TLyrControl.IsUserMap(fileext, MapName: string): boolean;
begin
  result := not (
      ( Fileext='.TMP') or
      ( UpperCase(MapName) = UpperCase('POPMapCS')) or
      ( UpperCase(MapName) = UpperCase('POPMapDT'))  or
      ( UpperCase(MapName)= UpperCase('POPMapRegion'))  or
      ( UpperCase(MapName) = UpperCase('POPMapGroup'))  or
      ( UpperCase(MapName) = UpperCase('POPMapGuide'))   or
      ( UpperCase(MapName) = UpperCase('POPMapGrid'))  or
      ( UpperCase(MapName) = UpperCase('POPMaptempAnimate'))  or
      ( UpperCase(MapName) = UpperCase('POPMapGridTheme')) or
      ( UpperCase(MapName) = UpperCase('POPMapLossTheme'))  or
      ( UpperCase(MapName) = UpperCase('CStempAnimate'))  or
      ( UpperCase(MapName) = UpperCase('TempLine')) or
      ( UpperCase(MapName) = UpperCase('POPMapLine')) or
      ( UpperCase(MapName) = UpperCase('POPMapCSC')) or
      ( UpperCase(MapName) = UpperCase('POPMapPA'))  or
      ( UpperCase(MapName) = UpperCase('POPMapGW'))  or
      ( UpperCase(MapName) = UpperCase('CIRCLE'))
      );
end;

procedure TLyrControl.LoadMaplist;
var
  i,id,Flag : integer;
  MapName : String;
  MapPath : String;
  Lyrobj : TLyrListInfo;
begin
  id := 0;
  For i := 1 to AMap.Layers.Count do  //---����Ҫ���⴦�� ��POPMapCS ��ͼ����ʾ����
    begin
      MapName := AMap.Layers.Item[i].Name;
      if
       (
         (UpperCase(MapName) = UpperCase('POPMapCS'))
         or (UpperCase(MapName) = UpperCase('POPMapDT'))
        //or (UpperCase(MapName) <> UpperCase('POPMapPA')
        ) then
      begin
          Lyrobj:= TLyrListInfo.Create;
          Lyrobj.LayerPath :=AMap.Layers.Item[i].Filespec;
          Lyrobj.LayerName :=MapName;
          Lyrobj.LayerProp :=1;

          Lyrobj.Visible := AMap.Layers.Item[i].Visible ;
          id :=Alist.Items.AddObject(MapName,Lyrobj);
          Alist.Checked[id] := Lyrobj.Visible ;
      end;
      if IsUserMap(UpperCase(ExtractFileExt(AMap.Layers.Item[i].Filespec)),UpperCase(MapName)) then
        begin
          Lyrobj:= TLyrListInfo.Create;
          Lyrobj.LayerPath :=AMap.Layers.Item[i].Filespec;
          Lyrobj.LayerName :=MapName;
          Lyrobj.LayerProp :=0;

          //AList.Items.Add(MapName);
          Lyrobj.Visible := AMap.Layers.Item[i].Visible;
          id :=Alist.Items.AddObject(MapName,Lyrobj);
          Alist.Checked[id] := Lyrobj.Visible ;
         // id := id+1;
        end;
    end;
  if AList.Count = 0 then
    MesCon.Perform(WM_User+995,1,0);
  // û�������ʱͼ��POPMapCS  qiusy 07-01-04
 { Style := AMap.Layers.item('POPMapTempAnimate').Style.Clone;   //POPMapCS
  Flag := 0;
  For i := 1 to AMap.Layers.Count do
    if AMap.Layers.Item(i).Name = 'POPMapDT' then
      begin
        Flag := 1;
        Break;
      end;
  if Flag = 1 then
    DTStyle := AMap.Layers.item('POPMapDT').Style.Clone;
 } MesCon.Perform(WM_User+995,2222,0);
end;
{
procedure TLyrControl.MouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Apoint : Tpoint;
  Str : String;
begin
  Apoint.X := X;
  Apoint.Y := Y;
  if (AList.ItemAtPos(Apoint,True) >= 0) and (AList.ItemAtPos(Apoint,True)<AList.Items.Count) then
    begin
      if Alist.Count > 1 then
        begin
          if AList.ItemAtPos(Apoint,True) = 0 then
            begin
              MesCon.Perform(WM_User+995,2,0);
              MesCon.Perform(WM_User+995,3,1);
            end
          else if AList.ItemAtPos(Apoint,True) = AList.Items.Count-1 then
            begin
              MesCon.Perform(WM_User+995,2,1);
              MesCon.Perform(WM_User+995,3,0);
            end
          else if AList.Items.Count = 1 then
            begin
              MesCon.Perform(WM_User+995,2,0);
              MesCon.Perform(WM_User+995,3,0);
            end
          else
            begin
              MesCon.Perform(WM_User+995,2,1);
              MesCon.Perform(WM_User+995,3,1);
            end;
        end
      else
        begin
          MesCon.Perform(WM_User+995,2,0);
          MesCon.Perform(WM_User+995,3,0);
        end;
      Str := Trim(AList.Items.Strings[AList.ItemAtPos(Apoint,True)]);
      ItemName := Str;
    end;
end;
}
procedure TLyrControl.OK(TheFlag:integer);
begin
  //2006-11-21 �׻Խ��޸ķ����޸� ������ʲô��ʽ���� ֻ���޸��û�ͼ�����ʾ
  DealOk;
  MesCon.Perform(WM_User+995,1111,0);
end;

procedure TLyrControl.RegMes(Sender: TControl);
begin
  MesCon := Sender;
end;

procedure TLyrControl.UpItem;
var
  i,SelectedIndex: integer;
  Flag1,Flag2,TmpStr : String;
begin
  //---ȡ��ѡ�м�¼��index

  SelectedIndex :=Alist.ItemIndex;
  if SelectedIndex-1 = 0 then
    begin
      MesCon.Perform(WM_User+995,2,0); //up enable=false;
      MesCon.Perform(WM_User+995,3,1); //down =true;
    end
  else
    begin
      MesCon.Perform(WM_User+995,2,1); //up =true;
      MesCon.Perform(WM_User+995,3,1); //down=false;
    end;
  If  SelectedIndex <> -1 Then
     Alist.Items.Exchange(SelectedIndex,SelectedIndex-1);
end;

{TLyrControl}



{ TMapTools }

constructor TMapTools.Create(AOWner: TMap);
begin
  AMap := AOWner;
  AMap.AreaUnit := 15;
  AMap.MapUnit := 7;
  AMap.PaperUnit := 7;
  AMap.MousewheelSupport := 3;
  AMap.OnToolUsed := ToolUsedEvent;
  AMap.CreateCustomTool(ChangePos,miToolTypePoint,miCrossCursor,EmptyParam,EmptyParam,EmptyParam);
  AMap.CreateCustomTool(PosInfo,miToolTypePoint,miCrossCursor,EmptyParam,EmptyParam,EmptyParam);
  AMap.CreateCustomTool(MTUINFO, miToolTypePoint,miArrowQuestionCursor,EmptyParam, EmptyParam, EmptyParam);
end;

procedure TMapTools.DeleteFeatureSelf(LyrName: String);
var
  i : integer;
  Lyr : CMapXLayer;
  fts : CMapXFeatures;
begin
  Lyr := AMap.Layers.Item[LyrName];
  fts := lyr.AllFeatures;
  For i := 1 to fts.Count do
    lyr.DeleteFeature(fts.Item[i]);
  AMap.Refresh;
end;

destructor TMapTools.Destroy;
begin

  inherited;
end;

procedure TMapTools.SetSelectTool(Lyr :String);
begin

end;

procedure TMapTools.SetSelectTool;
begin
  Amap.CurrentTool := miSelectTool;
end;

procedure TMapTools.SetZoomInTool;
begin
  AMap.CurrentTool := miZoomInTool;
end;

procedure TMapTools.SetZoomOutTool;
begin
  AMap.CurrentTool := miZoomOutTool;
end;

procedure TMapTools.ToolUsedEvent(Sender: TObject; ToolNum: Smallint; X1,
  Y1, X2, Y2, Distance: Double; Shift, Ctrl: WordBool;
  var EnableDefault: WordBool);
begin

end;

procedure TMapTools.SetPanTool;
begin
  AMap.CurrentTool := miPanTool;
end;

procedure TMapTools.SetPointMtuInfoTool;
begin
  AMap.CurrentTool := MTUINFO;
end;

procedure TMapTools.SetArrowTool;
begin
  AMap.CurrentTool:=miArrowTool;
end;

{ TMapEye }

constructor TMapEye.Create(EMap,MainMap: TMap);
begin
  Eyemap := EMap;
  AMap := MainMap;
  EyeMap.OnMouseDown := MouseDownEvent;
  EyeMap.OnMouseMove := MouseMoveEvent;
  EyeMap.OnMouseUp := MouseUpEvent;
  EyeFlag := 0;
  EyeStyle := coStyle.Create;
  EyeStyle.RegionBorderColor := clBlue;
  EyeStyle.RegionPattern := 0;
  EyeStyle.RegionBorderWidth := 2;
  AMap.OnMapViewChanged := MapViewChangedEvent;
end;

destructor TMapEye.Destroy;
begin
  ;
  inherited;
end;

procedure TMapEye.DrawBoundary;
var
  i : integer;
  ft : CMapXFeature;
  fts  : CMapXFeatures;
begin
  if EyeFlag = 1 then
    begin
      fts := EyeMap.Layers.item['Boundary'].AllFeatures;
      if Fts.Count > 0 then
        For i := 1 to fts.Count do
          EyeMap.Layers.Item['Boundary'].DeleteFeature(fts.Item[i]);
      EyeRect := CoRectangle.Create;
      EyeRect := AMap.Layers.Bounds;
      Ft := EyeMap.FeatureFactory.CreateRegion(AMap.Bounds,EyeStyle);
      EyeMap.Layers.Item['Boundary'].AddFeature(Ft,Emptyparam);
    end;
end;

procedure TMapEye.InitMapEye(SysPath :String);
var
  Lyr : CMapXLayer;
  EyeStyle : CMapXStyle;
  Font : TFont;
begin
  if Fileexists(SysPath+'\Layers\csinfo.tab') then
  begin
    lyr := EyeMap.Layers.CreateLayer('Boundary',EmptyParam,2,EmptyParam, EmptyParam);
    EyeMap.Layers.Add(Syspath+'\Layers\csinfo.tab',2);
    Lyr := EyeMap.Layers.Item['csinfo'];
    Lyr.OverrideStyle := True;
    EyeStyle := coStyle.Create;
    Font := TFont.Create;
    SetOleFont(Font,EyeStyle.SymbolFont);
    Font.Size := 12;
    EyeStyle.SymbolFontColor := clRed;
    EyeStyle.SymbolCharacter := 46;
    Lyr.Style := EyeStyle;
    EyeMap.Bounds := EyeMap.Layers.item['csinfo'].Bounds;
    EyeMap.Layers.item['csinfo'].Selectable := False;
    EyeMap.Layers.item['Boundary'].Selectable := False;
    EyeFlag := 1;
  end
  else
    MessageDLG('��վͼ�㲻���ڣ����Ƚ��л�վͼ���ʼ����',mtWarning,[mbOK],0);
end;

procedure TMapEye.MapViewChangedEvent(Sender: TObject);
begin
  DrawBoundary;
end;

procedure TMapEye.MouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  RealX ,RealY : Double;
  ScreenX,ScreenY : Single;
begin
  if Button = mbLeft then
    begin
      ScreenX := X;
      ScreenY := Y;
      EyeMap.ConvertCoord(ScreenX,ScreenY,RealX,RealY,miScreenToMap);
      AMap.CenterX := RealX;
      AMap.CenterY := RealY;
      MouseDown := True;
    end;
end;

procedure TMapEye.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  RealX ,RealY : Double;
  ScreenX,ScreenY : Single;
begin
  if MouseDown then
    begin
      ScreenX := X;
      ScreenY := Y;
      EyeMap.ConvertCoord(ScreenX,ScreenY,RealX,RealY,miScreenToMap);
      AMap.CenterX := RealX;
      AMap.CenterY := RealY;
    end;
end;

procedure TMapEye.MouseUpEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := False;
end;

procedure TMapEye.SetBackStyle;
var
  Lyr : CMapXLayer;
  MyStyle : CMapXStyle;
begin
  MyStyle := coStyle.Create;
  MyStyle := EyeMap.Layers.Item['POPMapCS'].Style.Clone;
  if MyStyle.PickSymbol then
    begin
      if EyeMap.Layers.Count > 0 then
        begin
          Lyr := EyeMap.Layers.Item['POPMapCS'];
          Lyr.OverrideStyle := True;
          Lyr.Style := MyStyle;
        end;
    end;
end;

procedure TMapEye.SetBoundStyle;
var
  MyStyle : CMapXStyle;
  Fts : CMapXFeatures;
begin
  MyStyle := CoStyle.Create;
  Fts := EyeMap.Layers.Item['Boundary'].AllFeatures;
  if Fts.Count > 0 then
    MyStyle := Fts.Item[1].Style.Clone
  else
    begin
      MyStyle.RegionBorderColor := clBlue;
      MyStyle.RegionPattern := 0;
      MyStyle.RegionBorderWidth := 2;
    end;
  if MyStyle.PickRegion then
    begin
      EyeMap.Layers.Item['Boundary'].OverrideStyle := True;
      EyeMap.Layers.Item['Boundary'].Style := MyStyle;
    end;
end;

{ TThemeObj }

constructor TThemeObj.Create(AOWner: TMap);
begin
  AMap := AOWner;
  AMap.AreaUnit := 15;
  AMap.MapUnit := 7;
  AMap.PaperUnit := 7;
  AMap.MousewheelSupport := 3;
end;

destructor TThemeObj.Destroy;
begin

  inherited;
end;

procedure TThemeObj.DrawIndividualTheme(ValueArray: Variant;
  FieldName: String);
var
    Lyr : CMapXLayer;
  fts : CMapXFeatures;
  ThemesDS : CMapXDataSet;
  ThemesFlds : CMapXFields;
  lStyle : CMapXStyle;
  i:integer;
begin
  Lyr := AMap.Layers.Item['mtuinfo'];
  fts := Lyr.AllFeatures;
  if fts.Count > 0 then
  begin
    if AMap.Datasets.Count > 0 then
        AMap.Datasets.RemoveAll;
    ThemesFlds := CoFields.Create;
    ThemesFlds.Add(1,'mtuno',miAggregationIndividual,miTypeString);
    ThemesFlds.Add(2,'Theme',miAggregationIndividual,miTypeString);
    ThemesDS := AMap.Datasets.Add(miDataSetSafeArray,ValueArray,'ThemeDataSet',1,EmptyParam,Lyr,ThemesFlds,EmptyParam);

    ThemesThm:=ThemesDS.Themes.Add(5,'Theme','Theme',true);
        lStyle := coStyle.Create;
    lStyle.SymbolType := 1;
    lStyle.SymbolBitmapTransparent := true;
    lStyle.SymbolBitmapSize :=14;
    lStyle.SymbolBitmapName := '500mw.bmp';
    For i := 1 to ThemesThm.ThemeProperties.IndividualValueCategories.Count do
    begin
      lStyle.SymbolBitmapColor := Tcolors[(i-1) mod high(Tcolors)];
      lStyle.SymbolBitmapOverrideColor := true;
      ThemesThm.ThemeProperties.IndividualValueCategories.Item[i].Style :=lStyle;
    end;

    with ThemesThm.Legend do
    begin
      CurrencyFormat:=false;
      ShowEmptyRanges:=true;
      Title := 'ͼ��';
      SubTitle := FieldName;
      showcount := True;
    end;
    ThemesThm.Visible := True;
  end
  else
    MessageDLG('û��MTU��ʾ�����ܴ���ר��ͼ��',mtWarning,[mbOK],0);
end;

procedure TThemeObj.DrawIndividualTheme(LyrName: string;
  ValueArray: Variant; FieldName, ThemeName: string);
var
  Lyr : CMapXLayer;
  fts : CMapXFeatures;
  ThemesDS : CMapXDataSet;
  ThemesFlds : CMapXFields;
  lStyle : CMapXStyle;
  i:integer;
begin
  Lyr := AMap.Layers.Item[LyrName];
  fts := Lyr.AllFeatures;
  if fts.Count > 0 then
  begin
    if AMap.Datasets.Count > 0 then
      self.RemoveTheme(ThemeName);
    ThemesFlds := CoFields.Create;
    ThemesFlds.Add(1,'mtuno',miAggregationIndividual,miTypeString);
    ThemesFlds.Add(2,'Theme',miAggregationIndividual,miTypeString);
      //��ValueAray����Դ����ͼ��Lyr��,����ThemeDS(ȡ��Ϊ'ThemeDataSet')
    ThemesDS := AMap.Datasets.Add(miDataSetSafeArray,ValueArray,ThemeName+'DataSet',1,
                                   EmptyParam,Lyr,ThemesFlds,EmptyParam);
    ThemesThm:=ThemesDS.Themes.Add(miThemeIndividualValue,'Theme',ThemeName ,true);

    //if ThemeName= Theme_CS then    //��վר��ͼҪ���û�վ��ʽ
    begin
      for i :=0  to ThemesThm.ThemeProperties.IndividualValueCategories.Count-1 do
      begin
        lStyle:=ThemesThm.ThemeProperties.IndividualValueCategories.Item[i+1].Style.Clone;
        lStyle.SymbolType := miSymbolTypeBitmap;  // ����Ϊλͼ
        lStyle.SymbolBitmapTransparent := True;   // λͼΪ͸��
        lStyle.SymbolBitmapOverrideColor := true;
        lStyle.SymbolBitmapName := 'TRAF1-32.BMP';
        lStyle.SymbolBitmapSize := 14;
        ThemesThm.ThemeProperties.IndividualValueCategories.Item[i+1].Style:=lStyle.Clone;
      end;
    end;
    with ThemesThm.Legend do
    begin
      CurrencyFormat:=false;
      ShowEmptyRanges:=true;
      Title := 'ͼ��';
      SubTitle := FieldName;
      showcount := True;
    end;
    ThemesThm.Visible := True;
  end
  else
    MessageDLG('û��MTU��ʾ�����ܴ���ר��ͼ��',mtWarning,[mbOK],0);
end;

procedure TThemeObj.RemoveTheme(ThemeName: string);
var
  i,j:integer;
  lThemesDS : CMapXDataSet;
  lName :String;
begin
  if AMap  =nil then exit;
  for i :=1  to AMap.Datasets.Count do
  begin
    lThemesDS:=AMap.Datasets.Item[i];
    for j := lThemesDS.Themes.Count downto 1 do
    begin
      lName := lThemesDS.Themes.Item[j].Name;
      if Uppercase(Trim(lName)) = Uppercase(Trim(ThemeName)) then
      begin
        lThemesDS.Themes.Remove(j);
      end;
    end;
  end;
  for i := AMap.Datasets.Count downto 1 do
  begin
    if AMap.Datasets.Item[i].Themes.Count<1 then
      AMap.Datasets.Remove(i);
  end;
end;

end.

