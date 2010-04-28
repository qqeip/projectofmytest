object FrameDBVerticalGridEditor: TFrameDBVerticalGridEditor
  Left = 0
  Top = 0
  Width = 245
  Height = 421
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 245
    Height = 421
    Align = alClient
    Caption = #32534#36753#38754#26495
    TabOrder = 0
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 2
      Top = 15
      Width = 241
      Height = 404
      Align = alClient
      OptionsView.RowHeaderWidth = 126
      TabOrder = 0
      DataController.DataSource = DataSource
    end
  end
  object DataSource: TDataSource
    Left = 136
    Top = 136
  end
end
