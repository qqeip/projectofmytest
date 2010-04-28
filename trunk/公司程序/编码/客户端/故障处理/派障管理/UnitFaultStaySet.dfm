object FormFaultStaySet: TFormFaultStaySet
  Left = 340
  Top = 281
  Width = 465
  Height = 159
  Caption = #30097#38590#30830#35748#35774#32622
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 75
    Height = 12
    AutoSize = False
    Caption = #30456#20851#35828#26126
  end
  object Label2: TLabel
    Left = 24
    Top = 49
    Width = 90
    Height = 12
    AutoSize = False
    Caption = #30003#35831#22825#25968'('#23567#26102')'
  end
  object Label3: TLabel
    Left = 218
    Top = 49
    Width = 114
    Height = 12
    AutoSize = False
    Caption = #21040#26399#25552#37266#22825#25968'('#23567#26102')'
  end
  object Bevel1: TBevel
    Left = 3
    Top = 2
    Width = 451
    Height = 87
    Shape = bsFrame
  end
  object EditRemark: TEdit
    Left = 116
    Top = 15
    Width = 297
    Height = 20
    TabOrder = 0
  end
  object SpinEditStay: TSpinEdit
    Left = 116
    Top = 44
    Width = 45
    Height = 21
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object SpinEditRemin: TSpinEdit
    Left = 336
    Top = 44
    Width = 45
    Height = 21
    MaxValue = 100
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
  object OKBtn: TButton
    Left = 141
    Top = 98
    Width = 75
    Height = 25
    Caption = #30830' '#23450
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 237
    Top = 98
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462' '#28040
    TabOrder = 4
    OnClick = CancelBtnClick
  end
end
