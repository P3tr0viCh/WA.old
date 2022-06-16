object frmFilter: TfrmFilter
  Left = 419
  Top = 331
  AlphaBlendValue = 180
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1060#1080#1083#1100#1090#1088
  ClientHeight = 244
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 18
  object bvlBottom: TBevel
    Left = 8
    Top = 184
    Width = 346
    Height = 10
    Shape = bsBottomLine
  end
  object btnOK: TButton
    Left = 8
    Top = 204
    Width = 96
    Height = 32
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnHide: TButton
    Left = 256
    Top = 204
    Width = 96
    Height = 32
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 4
    OnClick = btnHideClick
  end
  object btnClear: TButton
    Left = 112
    Top = 204
    Width = 96
    Height = 32
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    ModalResult = 1
    TabOrder = 3
    OnClick = btnClearClick
  end
  object gbDate: TGroupBox
    Left = 8
    Top = 4
    Width = 168
    Height = 178
    Caption = #1044#1072#1090#1072
    TabOrder = 0
    object lblDateFrom: TLabel
      Left = 8
      Top = 72
      Width = 62
      Height = 18
      Caption = #1053#1072#1095#1080#1085#1072#1103
      FocusControl = pckDateFrom
    end
    object lblDateTo: TLabel
      Left = 8
      Top = 124
      Width = 86
      Height = 18
      Caption = #1047#1072#1082#1072#1085#1095#1080#1074#1072#1103
      FocusControl = pckDateTo
    end
    object pckDateFrom: TDateTimePicker
      Left = 8
      Top = 92
      Width = 150
      Height = 26
      Date = 29674.471759247690000000
      Time = 29674.471759247690000000
      Enabled = False
      PopupMenu = pmDate
      TabOrder = 2
    end
    object rbtnDateAll: TRadioButton
      Left = 8
      Top = 24
      Width = 150
      Height = 18
      Caption = #1042#1089#1077' '#1079#1072#1087#1080#1089#1080
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbtnDateAllClick
    end
    object rbtnDateFromTo: TRadioButton
      Left = 8
      Top = 48
      Width = 150
      Height = 18
      Caption = #1054#1090#1088#1077#1079#1086#1082' '#1074#1088#1077#1084#1077#1085#1080
      TabOrder = 1
      OnClick = rbtnDateAllClick
    end
    object pckDateTo: TDateTimePicker
      Left = 8
      Top = 144
      Width = 150
      Height = 26
      Date = 29674.471759247690000000
      Time = 29674.471759247690000000
      Enabled = False
      PopupMenu = pmDate
      TabOrder = 3
    end
  end
  object gbAutoNum: TGroupBox
    Left = 184
    Top = 4
    Width = 168
    Height = 128
    Caption = #1053#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 64
      Width = 149
      Height = 56
      Caption = 
        #1080#1089#1087#1086#1083#1100#1079#1091#1081#1090#1077' '#1089#1080#1084#1074#1086#1083' "%" '#1076#1083#1103' '#1079#1072#1084#1077#1085#1099' '#1075#1088#1091#1087#1087#1099' '#1089#1080#1084#1074#1086#1083#1086#1074', "_" '#1076#1083#1103' '#1079#1072#1084#1077#1085 +
        #1099' '#1086#1076#1085#1086#1075#1086' '#1089#1080#1084#1074#1086#1083#1072
      FocusControl = eAutoNum
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object eAutoNum: TEdit
      Left = 8
      Top = 28
      Width = 150
      Height = 26
      TabOrder = 0
    end
  end
  object pmDate: TPopupMenu
    Left = 192
    Top = 144
    object miDateFirstDay: TMenuItem
      Tag = 1
      Caption = #1053#1072#1095#1072#1083#1086' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      OnClick = miDateYesterdayClick
    end
    object miDateLastDay: TMenuItem
      Tag = 2
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      OnClick = miDateYesterdayClick
    end
    object miSeparator01: TMenuItem
      Caption = '-'
    end
    object miDateYesterday: TMenuItem
      Tag = 3
      Caption = #1042#1095#1077#1088#1072#1096#1085#1103#1103' '#1076#1072#1090#1072
      OnClick = miDateYesterdayClick
    end
    object miDateCurrent: TMenuItem
      Tag = 4
      Caption = #1058#1077#1082#1091#1097#1072#1103' '#1076#1072#1090#1072
      OnClick = miDateYesterdayClick
    end
  end
end
