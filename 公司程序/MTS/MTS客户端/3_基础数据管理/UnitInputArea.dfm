object FormInputArea: TFormInputArea
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #22320#24066#20449#24687#36755#20837
  ClientHeight = 128
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 224
    Height = 86
    Align = alClient
    TabOrder = 0
    ExplicitTop = 8
    ExplicitHeight = 78
    object Label1: TLabel
      Left = 22
      Top = 18
      Width = 60
      Height = 13
      Caption = #22320#24066#32534#21495#65306
    end
    object Label2: TLabel
      Left = 22
      Top = 50
      Width = 60
      Height = 13
      Caption = #22320#24066#21517#31216#65306
    end
    object Label3: TLabel
      Left = 12
      Top = 20
      Width = 6
      Height = 13
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 12
      Top = 52
      Width = 10
      Height = 18
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EditAreaId: TEdit
      Left = 87
      Top = 15
      Width = 121
      Height = 21
      TabOrder = 0
      OnKeyPress = EditAreaIdKeyPress
    end
    object EditAreaName: TEdit
      Left = 87
      Top = 42
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 86
    Width = 224
    Height = 42
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 78
    object BitBtnCancel: TBitBtn
      Left = 130
      Top = 7
      Width = 65
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
    object BitBtnOK: TBitBtn
      Left = 59
      Top = 7
      Width = 65
      Height = 25
      Caption = #30830#23450
      TabOrder = 0
      OnClick = BitBtnOKClick
    end
  end
end
