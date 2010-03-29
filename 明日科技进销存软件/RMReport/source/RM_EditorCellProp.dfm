object RMCellPropForm: TRMCellPropForm
  Left = 248
  Top = 142
  BorderStyle = bsDialog
  Caption = 'Cell Prop'
  ClientHeight = 341
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageCtlCellProp: TPageControl
    Left = 8
    Top = 8
    Width = 425
    Height = 297
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheetCellType: TTabSheet
      Caption = 'Format'
      object LabelIntro1: TLabel
        Left = 16
        Top = 240
        Width = 3
        Height = 13
      end
      object Label1: TLabel
        Left = 16
        Top = 220
        Width = 65
        Height = 13
        Caption = 'Decimal digits'
        FocusControl = edtFormatDec
      end
      object Label2: TLabel
        Left = 309
        Top = 220
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Frac delimiter'
        FocusControl = edtFormatSpl
      end
      object Label3: TLabel
        Left = 242
        Top = 243
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Format'
        FocusControl = edtForamtStr
      end
      object lstFormatFolder: TListBox
        Left = 16
        Top = 9
        Width = 177
        Height = 203
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstFormatFolderClick
      end
      object edtFormatDec: TEdit
        Left = 93
        Top = 216
        Width = 25
        Height = 21
        HelpContext = 51
        TabOrder = 1
        Text = '0'
      end
      object edtForamtStr: TEdit
        Left = 278
        Top = 239
        Width = 121
        Height = 21
        HelpContext = 61
        TabOrder = 2
      end
      object edtFormatSpl: TEdit
        Left = 374
        Top = 216
        Width = 25
        Height = 21
        HelpContext = 41
        MaxLength = 1
        TabOrder = 3
        OnEnter = edtFormatSplEnter
      end
      object lstFormatType: TListBox
        Left = 200
        Top = 9
        Width = 199
        Height = 203
        ItemHeight = 13
        TabOrder = 4
        OnClick = lstFormatTypeClick
      end
    end
    object TabSheetAlign: TTabSheet
      Caption = 'Layout'
      ImageIndex = 1
      object LabelAlign: TLabel
        Left = 8
        Top = 8
        Width = 47
        Height = 13
        Caption = 'Text Align'
      end
      object BevelAlign: TBevel
        Left = 64
        Top = 16
        Width = 345
        Height = 2
        Shape = bsBottomLine
      end
      object LabelHAlign: TLabel
        Left = 32
        Top = 32
        Width = 73
        Height = 13
        Caption = 'Horizontal Align'
      end
      object LabelVAlign: TLabel
        Left = 32
        Top = 88
        Width = 61
        Height = 13
        Caption = 'Vertical Align'
      end
      object LabelControl: TLabel
        Left = 8
        Top = 144
        Width = 26
        Height = 13
        Caption = 'Other'
      end
      object BevelControl: TBevel
        Left = 64
        Top = 152
        Width = 345
        Height = 2
        Shape = bsBottomLine
      end
      object cmbHAlign: TComboBox
        Left = 32
        Top = 46
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnClick = cmbHAlignClick
      end
      object cmbVAlign: TComboBox
        Left = 32
        Top = 102
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
        OnClick = cmbVAlignClick
      end
      object ChkBoxAutoWordBreak: TCheckBox
        Left = 64
        Top = 168
        Width = 73
        Height = 17
        Caption = 'WordWrap'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object TabSheetFont: TTabSheet
      Caption = 'Font'
      ImageIndex = 2
      object LabelFontName: TLabel
        Left = 16
        Top = 8
        Width = 52
        Height = 13
        Caption = 'FontName:'
      end
      object LabelFontStyle: TLabel
        Left = 216
        Top = 8
        Width = 26
        Height = 13
        Caption = 'Style:'
      end
      object LabelFontSize: TLabel
        Left = 328
        Top = 8
        Width = 44
        Height = 13
        Caption = 'FontSize:'
      end
      object LabelFontColor: TLabel
        Left = 16
        Top = 128
        Width = 51
        Height = 13
        Caption = 'Font Color:'
      end
      object lstFontName: TListBox
        Left = 16
        Top = 24
        Width = 193
        Height = 97
        Style = lbOwnerDrawFixed
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstFontNameClick
        OnDrawItem = lstFontNameDrawItem
      end
      object lstFontStyle: TListBox
        Left = 216
        Top = 24
        Width = 105
        Height = 97
        ItemHeight = 13
        Items.Strings = (
          '')
        TabOrder = 1
        OnClick = lstFontStyleClick
      end
      object lstFontSize: TListBox
        Left = 328
        Top = 48
        Width = 73
        Height = 73
        ItemHeight = 13
        TabOrder = 3
        OnClick = lstFontSizeClick
      end
      object GbxFontPreview: TGroupBox
        Left = 16
        Top = 176
        Width = 385
        Height = 89
        Caption = 'Preview'
        TabOrder = 5
        object PanelFontPreview2: TPanel
          Left = 20
          Top = 20
          Width = 353
          Height = 61
          BevelOuter = bvNone
          Color = clBlack
          TabOrder = 0
        end
        object PanelFontPreview1: TPanel
          Left = 16
          Top = 16
          Width = 354
          Height = 62
          BevelOuter = bvNone
          Caption = 'Font Sample'
          Color = clWhite
          TabOrder = 1
        end
      end
      object PanelFontColor: TPanel
        Left = 16
        Top = 144
        Width = 73
        Height = 21
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 6
      end
      object BtnSetFontColor: TButton
        Left = 96
        Top = 144
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 4
        OnClick = BtnSetFontColorClick
      end
      object EditFontSize: TEdit
        Left = 328
        Top = 24
        Width = 73
        Height = 21
        TabOrder = 2
        OnKeyPress = EditFontSizeKeyPress
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Border'
      ImageIndex = 3
      object btnBorderTop: TSpeedButton
        Tag = 1
        Left = 5
        Top = 38
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 100
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F0000000000000F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderHInternal: TSpeedButton
        Tag = 2
        Left = 5
        Top = 72
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 101
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F0000000000000F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderBottom: TSpeedButton
        Tag = 3
        Left = 5
        Top = 107
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 102
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F0000000000000F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderLeft: TSpeedButton
        Tag = 4
        Left = 32
        Top = 133
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 104
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F0F7F7F7F7F7F7F0F0FFFFFFFFFFFFF0F0FFFFF7FFFFF7F0F0FFFFFFFFFF
          FFF0F0FFFFF7FFFFF7F0F0FFFFFFFFFFFFF0F0F7F7F7F7F7F7F0F0FFFFFFFFFF
          FFF0F0FFFFF7FFFFF7F0F0FFFFFFFFFFFFF0F0FFFFF7FFFFF7F0F0FFFFFFFFFF
          FFF0F0F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderVInternal: TSpeedButton
        Tag = 5
        Left = 87
        Top = 133
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 105
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F0F7F7F7F0FFFFFFF0FFFFFFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFF
          FFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFFFFF0F7F7F7F0F7F7F7F0FFFFFFF0FFFF
          FFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFFFFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFF
          FFF0F7F7F7F0F7F7F7F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderRight: TSpeedButton
        Tag = 6
        Left = 141
        Top = 133
        Width = 23
        Height = 22
        AllowAllUp = True
        GroupIndex = 106
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F0F0FFFFFFFFFFFFF0F0F7FFFFF7FFFFF0F0FFFFFFFFFFFF
          F0F0F7FFFFF7FFFFF0F0FFFFFFFFFFFFF0F0F7F7F7F7F7F7F0F0FFFFFFFFFFFF
          F0F0F7FFFFF7FFFFF0F0FFFFFFFFFFFFF0F0F7FFFFF7FFFFF0F0FFFFFFFFFFFF
          F0F0F7F7F7F7F7F7F0F0FFFFFFFFFFFFFFF0}
        OnClick = btnBorderTopClick
      end
      object btnBorderAll: TSpeedButton
        Left = 108
        Top = 13
        Width = 25
        Height = 24
        Hint = 'Internal'
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F0000000000000F0F0FFFFF0FFFFF0F0F0FFFFF0FFFFF0F0F0FFFFF0FFFF
          F0F0F0FFFFF0FFFFF0F0F0FFFFF0FFFFF0F0F0000000000000F0F0FFFFF0FFFF
          F0F0F0FFFFF0FFFFF0F0F0FFFFF0FFFFF0F0F0FFFFF0FFFFF0F0F0FFFFF0FFFF
          F0F0F0000000000000F0FFFFFFFFFFFFFFF0}
        Layout = blGlyphTop
        Margin = 3
        OnClick = btnBorderAllClick
      end
      object btnBorderInside: TSpeedButton
        Left = 83
        Top = 13
        Width = 25
        Height = 24
        Hint = 'Internal'
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F0F7F7F7F0FFFFFFF0FFFFFFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFF
          FFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFFFFF0F0000000000000F0FFFFFFF0FFFF
          FFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFFFFF0F7FFFFF0FFFFF7F0FFFFFFF0FFFF
          FFF0F7F7F7F0F7F7F7F0FFFFFFFFFFFFFFF0}
        Layout = blGlyphTop
        Margin = 3
        OnClick = btnBorderInsideClick
      end
      object btnBorderFrame: TSpeedButton
        Left = 58
        Top = 13
        Width = 25
        Height = 24
        Hint = 'External'
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F0000000000000F0F0FFFFFFFFFFF0F0F0FFFFF7FFFFF0F0F0FFFFFFFFFF
          F0F0F0FFFFF7FFFFF0F0F0FFFFFFFFFFF0F0F0F7F7F7F7F7F0F0F0FFFFFFFFFF
          F0F0F0FFFFF7FFFFF0F0F0FFFFFFFFFFF0F0F0FFFFF7FFFFF0F0F0FFFFFFFFFF
          F0F0F0000000000000F0FFFFFFFFFFFFFFF0}
        Layout = blGlyphTop
        Margin = 3
        OnClick = btnBorderFrameClick
      end
      object btnBorderNoFrame: TSpeedButton
        Left = 33
        Top = 13
        Width = 24
        Height = 24
        Hint = 'No Border'
        Flat = True
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFF
          FFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFFFFF0F7FFFFF7FFFFF7F0FFFFFFFFFFFF
          FFF0F7F7F7F7F7F7F7F0FFFFFFFFFFFFFFF0}
        Layout = blGlyphTop
        Margin = 3
        OnClick = btnBorderNoFrameClick
      end
      object Label4: TLabel
        Left = 200
        Top = 19
        Width = 54
        Height = 13
        Caption = 'Boder Style'
      end
      object BorderPanel: TPanel
        Left = 32
        Top = 40
        Width = 132
        Height = 92
        BevelOuter = bvLowered
        Color = clWhite
        TabOrder = 0
        object BordersBox: TPaintBox
          Left = 1
          Top = 1
          Width = 130
          Height = 90
          Align = alClient
          OnPaint = BordersBoxPaint
        end
      end
      object EDLeftStyle: TComboBox
        Left = 200
        Top = 43
        Width = 119
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 1
        OnDrawItem = EDLeftStyleDrawItem
      end
      object chkDoubleLeft: TCheckBox
        Left = 200
        Top = 125
        Width = 119
        Height = 17
        Caption = 'Double'
        TabOrder = 2
      end
    end
  end
  object BtnOk: TButton
    Left = 256
    Top = 312
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object BtnCancel: TButton
    Left = 352
    Top = 312
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object ColorDialogCellProp: TColorDialog
    Left = 408
  end
end
