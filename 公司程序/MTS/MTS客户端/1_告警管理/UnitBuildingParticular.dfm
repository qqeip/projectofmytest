object FormBuildingParticular: TFormBuildingParticular
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #23460#20998#28857#20449#24687
  ClientHeight = 477
  ClientWidth = 420
  Color = 15451300
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 0
    Width = 420
    Height = 477
    ActivePage = cxTabSheet7
    Align = alClient
    Style = 9
    TabOrder = 0
    OnChange = cxPageControl1Change
    ClientRectBottom = 477
    ClientRectRight = 420
    ClientRectTop = 19
    object cxTabSheet1: TcxTabSheet
      Caption = #23460#20998#28857
      ImageIndex = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object VL: TValueListEditor
        Left = 0
        Top = 0
        Width = 420
        Height = 458
        Align = alClient
        Ctl3D = False
        DefaultColWidth = 100
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
        ParentCtl3D = False
        TabOrder = 0
        TitleCaptions.Strings = (
          #39033#30446
          #20540)
        ColWidths = (
          137
          279)
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'MTU'
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 420
        Height = 458
        Align = alClient
        TabOrder = 0
        object cxGrid1DBTableView1: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = DataSource1
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = cxGrid1DBTableView1
        end
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = 'AP'
      ImageIndex = 2
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object cxTabSheet4: TcxTabSheet
      Caption = 'PHS'#22522#31449
      ImageIndex = 3
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object cxTabSheet5: TcxTabSheet
      Caption = 'CDMA'#22522#31449
      ImageIndex = 4
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object cxTabSheet6: TcxTabSheet
      Caption = #20132#25442#26426
      ImageIndex = 5
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object cxTabSheet7: TcxTabSheet
      Caption = #36830#25509#22120
      ImageIndex = 6
    end
    object cxTabSheet8: TcxTabSheet
      Caption = #30452#25918#31449
      ImageIndex = 7
      TabVisible = False
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 272
    Top = 344
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 344
  end
end
