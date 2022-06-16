object frmAllLists: TfrmAllLists
  Left = 259
  Top = 217
  Caption = #1041#1072#1079#1072' XXX'
  ClientHeight = 473
  ClientWidth = 812
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 820
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object DataList: TListView
    Left = 0
    Top = 42
    Width = 812
    Height = 319
    Align = alClient
    Color = clWhite
    Columns = <
      item
        Caption = #8470' '#1087'/'#1087
        Width = 60
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = DataListChange
    OnCompare = DataListCompare
    OnCustomDrawItem = DataListCustomDrawItem
    OnCustomDrawSubItem = DataListCustomDrawSubItem
    OnDblClick = DataListDblClick
    OnKeyDown = DataListKeyDown
    OnKeyPress = DataListKeyPress
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 453
    Width = 812
    Height = 20
    Panels = <
      item
        Text = 'Select records'
        Width = 200
      end
      item
        Text = 'Count records'
        Width = 200
      end
      item
        Alignment = taCenter
        Text = 'Filter'
        Width = 150
      end
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 812
    Height = 42
    AutoSize = True
    Bands = <
      item
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 38
        Width = 808
      end>
    FixedSize = True
    FixedOrder = True
    Images = Main.ImageList32
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 808
      Height = 38
      AutoSize = True
      ButtonHeight = 38
      ButtonWidth = 100
      Images = Main.ImageList32
      List = True
      ShowCaptions = True
      TabOrder = 0
      object tbtnEdit: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        ImageIndex = 1
        OnClick = tbtnEditClick
      end
      object tbtnDelete: TToolButton
        Left = 104
        Top = 0
        AutoSize = True
        Caption = #1059#1076#1072#1083#1080#1090#1100
        ImageIndex = 3
        Visible = False
        OnClick = tbtnDeleteClick
      end
      object tbtnSeparator01: TToolButton
        Left = 199
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object tbtnFilter: TToolButton
        Left = 207
        Top = 0
        AutoSize = True
        Caption = #1060#1080#1083#1100#1090#1088
        ImageIndex = 0
        OnClick = tbtnFilterClick
      end
      object tbtnSeparatorEnd: TToolButton
        Left = 297
        Top = 0
        Width = 8
        Caption = '-'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbtnClose: TToolButton
        Left = 305
        Top = 0
        AutoSize = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ImageIndex = 2
        OnClick = tbtnCloseClick
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 361
    Width = 812
    Height = 92
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      812
      92)
    object gbFilter: TGroupBox
      Left = 4
      Top = 4
      Width = 353
      Height = 77
      Caption = #1060#1080#1083#1100#1090#1088
      TabOrder = 0
      object eFilterDate: TLabeledEdit
        Left = 12
        Top = 40
        Width = 200
        Height = 24
        Color = clBtnFace
        EditLabel.Width = 28
        EditLabel.Height = 16
        EditLabel.Caption = #1044#1072#1090#1072
        ReadOnly = True
        TabOrder = 0
      end
      object eFilterAutoNum: TLabeledEdit
        Left = 220
        Top = 40
        Width = 120
        Height = 24
        Color = clBtnFace
        EditLabel.Width = 113
        EditLabel.Height = 16
        EditLabel.Caption = #1053#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        ReadOnly = True
        TabOrder = 1
      end
    end
    object gbAll: TGroupBox
      Left = 528
      Top = 4
      Width = 278
      Height = 77
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1097#1080#1081' '#1074#1077#1089' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1079#1072#1087#1080#1089#1077#1081
      TabOrder = 1
      object eAllGross: TLabeledEdit
        Left = 12
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 40
        EditLabel.Height = 16
        EditLabel.Caption = #1041#1088#1091#1090#1090#1086
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
      object eAllTare: TLabeledEdit
        Left = 100
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 27
        EditLabel.Height = 16
        EditLabel.Caption = #1058#1072#1088#1072
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
      object eAllNetto: TLabeledEdit
        Left = 188
        Top = 40
        Width = 78
        Height = 24
        Color = clBtnFace
        Ctl3D = True
        EditLabel.Width = 37
        EditLabel.Height = 16
        EditLabel.Caption = #1053#1077#1090#1090#1086
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -13
        EditLabel.Font.Name = 'Arial'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object SelTimer: TTimer
    Interval = 100
    OnTimer = SelTimerTimer
    Left = 20
    Top = 164
  end
end
