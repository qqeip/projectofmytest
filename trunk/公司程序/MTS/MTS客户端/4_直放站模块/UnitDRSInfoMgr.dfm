object FormDRSInfoMgr: TFormDRSInfoMgr
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #30452#25918#31449#36164#26009#31649#29702
  ClientHeight = 394
  ClientWidth = 907
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelInfo: TPanel
    Left = 0
    Top = 34
    Width = 907
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblDRS_ID: TLabel
      Left = 37
      Top = 18
      Width = 64
      Height = 13
      Caption = #30452#25918#31449#32534#21495':'
    end
    object lblDRS_Phone: TLabel
      Left = 523
      Top = 51
      Width = 52
      Height = 13
      Caption = #30005#35805#21495#30721':'
    end
    object lblDRS_Name: TLabel
      Left = 276
      Top = 51
      Width = 64
      Height = 13
      Caption = #30452#25918#31449#21517#31216':'
    end
    object lblDRS_Addr: TLabel
      Left = 276
      Top = 223
      Width = 36
      Height = 13
      Caption = #22320#22336#65306
    end
    object lblDRS_SubURB: TLabel
      Left = 37
      Top = 188
      Width = 64
      Height = 13
      Caption = #25152#23646#23460#20998#28857':'
    end
    object Label1: TLabel
      Left = 523
      Top = 188
      Width = 25
      Height = 13
      Caption = 'PN'#30721
    end
    object Label2: TLabel
      Left = 37
      Top = 51
      Width = 64
      Height = 13
      Caption = #30452#25918#31449#31867#22411':'
    end
    object Label3: TLabel
      Left = 37
      Top = 154
      Width = 52
      Height = 13
      Caption = #25152#23646#20998#23616':'
    end
    object Label4: TLabel
      Left = 276
      Top = 18
      Width = 52
      Height = 13
      Caption = #35774#22791#32534#21495':'
    end
    object Label5: TLabel
      Left = 523
      Top = 154
      Width = 28
      Height = 13
      Caption = #32428#24230':'
    end
    object Label6: TLabel
      Left = 523
      Top = 119
      Width = 28
      Height = 13
      Caption = #32463#24230':'
    end
    object Label7: TLabel
      Left = 494
      Top = 262
      Width = 96
      Height = 13
      Caption = #26368#21518#29366#24577#33719#21462#26102#38388
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 252
      Top = 262
      Width = 100
      Height = 13
      Caption = #26368#21518#29366#24577#21464#26356#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 523
      Top = 18
      Width = 52
      Height = 13
      Caption = #24403#21069#29366#24577':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 523
      Top = 85
      Width = 52
      Height = 13
      Caption = #20195#32500#20844#21496':'
    end
    object Label11: TLabel
      Left = 276
      Top = 188
      Width = 76
      Height = 13
      Caption = #24402#23646#25159#21306#32534#21495':'
    end
    object Label14: TLabel
      Left = 276
      Top = 154
      Width = 76
      Height = 13
      Caption = #24402#23646#22522#31449#32534#21495':'
    end
    object Label16: TLabel
      Left = 276
      Top = 119
      Width = 71
      Height = 13
      Caption = #24402#23646'BSC'#32534#21495':'
    end
    object Label17: TLabel
      Left = 276
      Top = 85
      Width = 73
      Height = 13
      Caption = #24402#23646'MSC'#32534#21495':'
    end
    object Label18: TLabel
      Left = 37
      Top = 119
      Width = 52
      Height = 13
      Caption = #26159#21542#23460#20869':'
    end
    object Label19: TLabel
      Left = 37
      Top = 85
      Width = 64
      Height = 13
      Caption = #30452#25918#31449#21378#23478':'
    end
    object Label12: TLabel
      Left = 37
      Top = 223
      Width = 64
      Height = 13
      Caption = #24403#21069#21578#35686#25968':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 37
      Top = 262
      Width = 76
      Height = 13
      Caption = #26368#21518#37197#32622#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label21: TLabel
      Left = 13
      Top = 299
      Width = 100
      Height = 13
      Caption = #26368#21518#37197#32622#26356#26032#26102#38388':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EdtCS: TEdit
      Left = 357
      Top = 154
      Width = 130
      Height = 21
      TabOrder = 0
    end
    object EdtALARMCOUNTS: TEdit
      Left = 106
      Top = 223
      Width = 130
      Height = 21
      TabOrder = 1
      OnKeyPress = EdtALARMCOUNTSKeyPress
    end
    object EdtUPDATETIME1: TEdit
      Left = 358
      Top = 259
      Width = 130
      Height = 21
      TabOrder = 2
      OnKeyPress = EdtUPDATETIME1KeyPress
    end
    object EdtUPDATETIME3: TEdit
      Left = 119
      Top = 262
      Width = 117
      Height = 21
      TabOrder = 3
      OnKeyPress = EdtUPDATETIME3KeyPress
    end
    object EdtMSC: TEdit
      Left = 357
      Top = 85
      Width = 130
      Height = 21
      TabOrder = 4
    end
    object EdtPN: TEdit
      Left = 584
      Top = 188
      Width = 130
      Height = 21
      TabOrder = 5
    end
    object EdtUPDATETIME2: TEdit
      Left = 598
      Top = 262
      Width = 116
      Height = 21
      TabOrder = 6
      OnKeyPress = EdtUPDATETIME2KeyPress
    end
    object EdtLONGITUDE: TEdit
      Left = 584
      Top = 119
      Width = 130
      Height = 21
      TabOrder = 7
    end
    object EdtR_DEVICEID: TEdit
      Left = 358
      Top = 18
      Width = 130
      Height = 21
      TabOrder = 8
      OnKeyPress = EdtR_DEVICEIDKeyPress
    end
    object EdtLATITUDE: TEdit
      Left = 584
      Top = 154
      Width = 130
      Height = 21
      TabOrder = 9
    end
    object EdtBSC: TEdit
      Left = 357
      Top = 119
      Width = 130
      Height = 21
      TabOrder = 10
    end
    object EdtCELL: TEdit
      Left = 357
      Top = 188
      Width = 130
      Height = 21
      TabOrder = 11
    end
    object CbBDRSTYPE: TComboBox
      Left = 106
      Top = 51
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 12
      OnKeyPress = CbBDRSTYPEKeyPress
    end
    object CbBDRSMANU: TComboBox
      Left = 106
      Top = 85
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 13
      OnKeyPress = CbBDRSMANUKeyPress
    end
    object CbBISPROGRAM: TComboBox
      Left = 106
      Top = 119
      Width = 130
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 14
      Text = #23460#20998
      OnChange = CbBISPROGRAMChange
      OnKeyPress = CbBISPROGRAMKeyPress
      Items.Strings = (
        #23460#20998
        #23460#22806)
    end
    object CbBSUBURB: TComboBox
      Left = 106
      Top = 154
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 15
      OnChange = CbBSUBURBChange
      OnKeyPress = CbBSUBURBKeyPress
    end
    object CbBAGENTMANU: TComboBox
      Left = 584
      Top = 85
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 16
      OnKeyPress = CbBAGENTMANUKeyPress
    end
    object EdtDRSSTATUS: TEdit
      Left = 584
      Top = 18
      Width = 130
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 17
      OnKeyPress = EdtDRSSTATUSKeyPress
    end
    object EdtDRSAddr: TEdit
      Left = 357
      Top = 223
      Width = 357
      Height = 21
      TabOrder = 18
    end
    object CbBBUILDINGID: TComboBox
      Left = 106
      Top = 188
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 19
      OnChange = CbBBUILDINGIDChange
      OnKeyPress = CbBBUILDINGIDKeyPress
    end
    object EdtDRSName: TEdit
      Left = 357
      Top = 51
      Width = 130
      Height = 21
      TabOrder = 20
    end
    object EdtDRSPhone: TEdit
      Left = 584
      Top = 51
      Width = 130
      Height = 21
      TabOrder = 21
      OnKeyPress = EdtDRSPhoneKeyPress
    end
    object EdtDRSID: TEdit
      Left = 106
      Top = 18
      Width = 130
      Height = 21
      TabOrder = 22
      OnKeyPress = EdtDRSIDKeyPress
    end
    object EdtUPDATETIME4: TEdit
      Left = 119
      Top = 299
      Width = 117
      Height = 21
      TabOrder = 23
      OnKeyPress = EdtUPDATETIME4KeyPress
    end
    object ButtonClear: TButton
      Left = 563
      Top = 312
      Width = 65
      Height = 25
      Caption = #28165' '#31354
      TabOrder = 24
      OnClick = ButtonClearClick
    end
    object ButtonAdd: TButton
      Left = 247
      Top = 312
      Width = 65
      Height = 25
      Caption = #26032'  '#22686
      TabOrder = 25
      OnClick = ButtonAddClick
    end
    object ButtonChange: TButton
      Left = 326
      Top = 312
      Width = 65
      Height = 25
      Caption = #20462'  '#25913
      TabOrder = 26
      OnClick = ButtonChangeClick
    end
    object ButtonDelete: TButton
      Left = 484
      Top = 312
      Width = 65
      Height = 25
      Caption = #21024'  '#38500
      TabOrder = 27
      OnClick = ButtonDeleteClick
    end
    object ButtonSave: TButton
      Left = 405
      Top = 312
      Width = 65
      Height = 25
      Caption = #20445'  '#23384
      Enabled = False
      TabOrder = 28
      OnClick = ButtonSaveClick
    end
    object ButtonCanel: TButton
      Left = 484
      Top = 312
      Width = 65
      Height = 25
      Caption = #21462'  '#28040
      TabOrder = 29
      Visible = False
      OnClick = ButtonCanelClick
    end
    object cxLabel2: TcxLabel
      Left = 242
      Top = 54
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 17
      Width = 14
    end
    object cxLabel3: TcxLabel
      Left = 242
      Top = 122
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 17
      Width = 14
    end
    object cxLabel4: TcxLabel
      Left = 242
      Top = 157
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 15
      Width = 14
    end
    object cxLabel5: TcxLabel
      Left = 494
      Top = 22
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      StyleFocused.TextColor = clWindowText
      Height = 17
      Width = 14
    end
    object cxLabel6: TcxLabel
      Left = 493
      Top = 54
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      StyleFocused.Color = clBtnFace
      StyleFocused.TextColor = clWindowText
      StyleFocused.TextStyle = [fsBold]
      Height = 17
      Width = 14
    end
    object cxLabel1: TcxLabel
      Left = 242
      Top = 22
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 17
      Width = 14
    end
    object cxLabel7: TcxLabel
      Left = 720
      Top = 54
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 17
      Width = 14
    end
    object cxLabel8: TcxLabel
      Left = 242
      Top = 191
      AutoSize = False
      Caption = ' * '
      Style.TextColor = clRed
      Height = 17
      Width = 14
    end
  end
  object Panel20: TPanel
    Left = 0
    Top = 0
    Width = 907
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Caption = #30452' '#25918' '#31449' '#20449' '#24687' '#31649' '#29702
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
