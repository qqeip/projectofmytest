inherited FormCompanyInfo: TFormCompanyInfo
  Height = 305
  Caption = #32500#25252#21333#20301#20449#24687
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited GroupBox1: TGroupBox
    Height = 234
    object cxTextEditName: TcxTextEdit
      Left = 147
      Top = 26
      Style.Shadow = True
      TabOrder = 0
      Width = 155
    end
    object cxTextEditAddr: TcxTextEdit
      Left = 147
      Top = 139
      Style.Shadow = True
      TabOrder = 1
      Width = 155
    end
    object cxTextEditPhone: TcxTextEdit
      Left = 147
      Top = 63
      Style.Shadow = True
      TabOrder = 2
      Width = 155
    end
    object cxTextEditFax: TcxTextEdit
      Left = 147
      Top = 177
      Style.Shadow = True
      TabOrder = 3
      Width = 155
    end
    object cxTextEditLinkMan: TcxTextEdit
      Left = 147
      Top = 101
      Style.Shadow = True
      TabOrder = 4
      Width = 155
    end
    object cxLabel1: TcxLabel
      Left = 25
      Top = 26
      AutoSize = False
      Caption = #32500#25252#21333#20301#21517#31216
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clRed
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      Height = 16
      Width = 80
    end
    object cxLabel2: TcxLabel
      Left = 25
      Top = 139
      AutoSize = False
      Caption = #32500#25252#21333#20301#22320#22336
      Height = 16
      Width = 80
    end
    object cxLabel3: TcxLabel
      Left = 25
      Top = 63
      AutoSize = False
      Caption = #37096#38376#30005#35805
      Height = 16
      Width = 80
    end
    object cxLabel4: TcxLabel
      Left = 25
      Top = 177
      AutoSize = False
      Caption = #20256#30495
      Height = 16
      Width = 80
    end
    object cxLabel5: TcxLabel
      Left = 25
      Top = 101
      AutoSize = False
      Caption = #32852#31995#20154
      Height = 16
      Width = 80
    end
  end
  inherited Panel1: TPanel
    Top = 234
    object Label1: TLabel [0]
      Left = 24
      Top = 16
      Width = 153
      Height = 12
      AutoSize = False
      Caption = '*'#27880#65306#32418#33394#36873#25321#20026#24517#22635#39033
      Font.Charset = GB2312_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
  end
  inherited Panel2: TPanel
    Height = 234
  end
  inherited Panel3: TPanel
    Height = 234
  end
end
