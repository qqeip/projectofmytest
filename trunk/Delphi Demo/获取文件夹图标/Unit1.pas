unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,activeX,   shellapi,   shlobj, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
       procedure   AppMessage(var   Msg:   TMsg;   var   Handled:   Boolean);   

  end;
   function   GetIconHandle(filename:string;small:Boolean =false):HIcon;
var
  Form1: TForm1;

implementation

{$R *.dfm}

function   GetIconHandle(filename:string;small:Boolean=false):HIcon;
  var   
  f:SHFILEINFO;
  flag:uint;   
  begin   
  if   small   then   
      flag:=SHGFI_SMALLICON   
  else   
      flag:=SHGFI_LARGEICON ;   
    shgetfileinfo(pchar(filename),faanyfile,f,sizeof(F),flag+SHGFI_ICON);   
    result:=f.hIcon;   
  end;

  function   GetIcon(filename:string;small:boolean=false):TIcon;
  begin   
     result:=ticon.create;   
      result.handle:=geticonhandle(filename,small);   
  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text:= OpenDialog1.FileName;
  image1.Picture.Icon:=GetIcon(edit1.text,false);
end;
     
  type   
      LINK_FILE_INFO   =   record   ///��ݷ�ʽ�ļ���Ϣ���ݽṹ   
          FileName:   array[0..MAX_PATH]   of   char;   ///Ŀ���ļ���   
          WorkDirectory:   array[0..MAX_PATH]   of   char;   ///����Ŀ¼
          IconLocation:   array[0..MAX_PATH]   of   char;   ///ͼ���ļ�   
          IconIndex:   integer;   ///ͼ������
          Arguments:   array[0..MAX_PATH]   of   char;   ///���в���
          Description:   array[0..255]   of   char;   ///�ļ�����   
          ItemIDList:   PItemIDList;   ///ϵͳIDList��δʹ��   
          RelativePath:   array[0..255]   of   char;   ///���·��   
          ShowState:   integer;   ///����ʱ����ʵ״̬   
          HotKey:   word;   ///�ȼ�   
      end;   
    
  function   linkfileinfo(const   lnkfilename:   string;   var   info:   link_file_info;   const   bset:   boolean):   boolean;   
  var   
      hr:   hresult;   
      psl:   ishelllink;   
      wfd:   win32_find_data;   
      ppf:   ipersistfile;   
      lpw:   pwidechar;   
      buf:   pwidechar;   
  begin   
      result   :=   false;   
      getmem(buf,   max_path);   
      try   
          if   succeeded(coinitialize(nil))   then   
              if   (succeeded(cocreateinstance(clsid_shelllink,   nil,   clsctx_inproc_server,   iid_ishelllinka,   psl)))   then   
              begin   
                  hr   :=   psl.queryinterface(ipersistfile,   ppf);   
                  if   succeeded(hr)   then   
                  begin   
                      lpw   :=   stringtowidechar(lnkfilename,   buf,   max_path);   
                      hr   :=   ppf.load(lpw,   stgm_read);   
                      if   succeeded(hr)   then   
                      begin   
                          hr   :=   psl.resolve(0,   slr_no_ui);   
                          if   succeeded(hr)   then   
                          begin   
                              if   bset   then   
                              begin   
                                  psl.setarguments(info.arguments);   
                                  psl.setdescription(info.description);   
                                  psl.sethotkey(info.hotkey);   
                                  psl.seticonlocation(info.iconlocation,   info.iconindex);
                                  psl.setidlist(info.itemidlist);   
                                  psl.setpath(info.filename);   
                                  psl.setshowcmd(info.showstate);   
                                  psl.setrelativepath(info.relativepath,   0);
                                  psl.setworkingdirectory(info.workdirectory);
                                  result   :=   succeeded(psl.resolve(0,   slr_update));   
                              end   
                              else   
                              begin   
                                  psl.getpath(info.filename,   max_path,   wfd,   slgp_shortpath);   
                                  psl.geticonlocation(info.iconlocation,   max_path,   info.iconindex);   
                                  psl.getworkingdirectory(info.workdirectory,   max_path);   
                                  psl.getdescription(info.description,   255);   
                                  psl.getarguments(info.arguments,   max_path);   
                                  psl.gethotkey(info.hotkey);   
                                  psl.getidlist(info.itemidlist);   
                                  psl.getshowcmd(info.showstate);   
                                  result   :=   true;   
                              end;   
                          end;   
                      end;   
                  end;   
              end;   
      finally   
          freemem(buf);   
      end;   
  end;   
    
  function   GetLinkFile_ExeName(LinkFile:   string):   string;
  var
      info:   link_file_info;
  begin
      Result   :=   '';
      if   linkfileinfo(LinkFile,   info,   False)   then
      begin
          Result   :=   info.FileName;
      end;
  end;


procedure   TForm1.AppMessage(var   Msg:   TMsg;   var   Handled:   Boolean);
var
    nFiles,   I:   Integer;
    Filename:   string;
begin
//
//   ע�⣡������Ϣ����ͨ�����
//   ��Ҫ�ڴ˹����б�д����Ļ�����Ҫ��ʱ������Ĵ��룬����Ӱ����������
//
//   �ж��Ƿ��Ƿ��͵�ListView1��WM_DROPFILES��Ϣ
    if   (Msg.message   =   WM_DROPFILES)   and   (msg.hwnd   =   form1.Handle)   then
    begin
//   ȡdropped   files������
        nFiles   :=   DragQueryFile(Msg.wParam,   $FFFFFFFF,   nil,   0);
//   ѭ��ȡÿ�������ļ���ȫ�ļ���
        try
            for   I   :=   0   to   nFiles   -   1   do
            begin   
//   Ϊ�ļ������仺��   allocate   memory   
                SetLength(Filename,   80);   
//   ȡ�ļ���   read   the   file   name   
                DragQueryFile(Msg.wParam,   I,   PChar(Filename),   80);
                Filename   :=   PChar(Filename);
//file://��ȫ�ļ����ֽ���ļ�����·��   
                if   UpperCase(ExtractFileExt(FileName))   =   '.LNK'   then
                begin
                    Edit1.Text   :=   GetLinkFile_ExeName(FileName);
                    image1.Picture.Icon:=GetIcon(edit1.text,false);
                    end
                else
                begin
                    Edit1.Text   :=   FileName;
                    image1.Picture.Icon:=GetIcon(edit1.text,false);
                   end;
            end;
        finally
//file://��������ϷŲ���   
            DragFinish(Msg.wParam);
        end;
//file://��ʶ�Ѵ�����������Ϣ   
        Handled   :=   True;   
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 //file://������Ҫ�����ļ�WM_DROPFILES�Ϸ���Ϣ
      DragAcceptFiles(form1.Handle,   TRUE);
  //file://����AppMessage����������������Ϣ
end;

end.

