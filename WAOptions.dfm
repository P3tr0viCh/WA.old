object frmOptions: TfrmOptions
  Left = 401
  Top = 211
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 378
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    490
    378)
  PixelsPerInch = 96
  TextHeight = 18
  object BevelBottom: TBevel
    Left = 8
    Top = 326
    Width = 474
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 289
    Top = 336
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 387
    Top = 336
    Width = 90
    Height = 32
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object PanelMain: TPanel
    Left = 8
    Top = 8
    Width = 476
    Height = 310
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 472
      Height = 306
      ActivePage = tsProgram
      Align = alClient
      MultiLine = True
      TabOrder = 0
      object tsProgram: TTabSheet
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object gbComPort: TGroupBox
          Left = 4
          Top = 106
          Width = 146
          Height = 60
          Caption = #1055#1086#1088#1090' '#1080#1085#1076#1080#1082#1072#1090#1086#1088#1072
          TabOrder = 1
          object cboxComPort: TComboBox
            Left = 8
            Top = 24
            Width = 130
            Height = 26
            Style = csDropDownList
            DropDownCount = 2
            ItemIndex = 0
            TabOrder = 0
            Text = 'COM 1'
            Items.Strings = (
              'COM 1'
              'COM 2')
          end
        end
        object gbWorkMode: TGroupBox
          Left = 4
          Top = 4
          Width = 456
          Height = 97
          Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
          TabOrder = 0
          object cboxCanAdd: TCheckBox
            Left = 8
            Top = 48
            Width = 440
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1074#1086#1076
            TabOrder = 1
          end
          object cboxCanEdit: TCheckBox
            Left = 8
            Top = 24
            Width = 440
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
            TabOrder = 0
            OnClick = cboxCanEditClick
          end
          object cboxCanDelete: TCheckBox
            Left = 8
            Top = 72
            Width = 440
            Height = 18
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1087#1080#1089#1077#1081
            TabOrder = 2
          end
        end
      end
      object tsScales: TTabSheet
        Caption = #1042#1077#1089#1099
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object gbPlace: TGroupBox
          Left = 4
          Top = 64
          Width = 224
          Height = 60
          Caption = #1052#1077#1089#1090#1086' '#1091#1089#1090#1072#1085#1086#1074#1082#1080
          TabOrder = 1
          object ePlace: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 127
            TabOrder = 0
          end
        end
        object gbScales: TGroupBox
          Left = 4
          Top = 4
          Width = 120
          Height = 60
          Caption = #1053#1086#1084#1077#1088' '#1074#1077#1089#1086#1074
          TabOrder = 0
          object eScales: TExtSpinEdit
            Left = 8
            Top = 24
            Width = 104
            Height = 27
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object gbType: TGroupBox
          Left = 234
          Top = 64
          Width = 224
          Height = 60
          Caption = #1058#1080#1087
          TabOrder = 2
          object eType: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 15
            TabOrder = 0
          end
        end
        object gbSClass: TGroupBox
          Left = 4
          Top = 124
          Width = 224
          Height = 60
          Caption = #1050#1083#1072#1089#1089' '#1090#1086#1095#1085#1086#1089#1090#1080' '#1074' '#1089#1090#1072#1090#1080#1082#1077
          TabOrder = 3
          object cboxSClass: TComboBox
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            DropDownCount = 4
            MaxLength = 7
            TabOrder = 0
            Items.Strings = (
              #1057#1087#1077#1094#1080#1072#1083#1100#1085#1099#1081
              #1042#1099#1089#1086#1082#1080#1081
              #1057#1088#1077#1076#1085#1080#1081
              #1054#1073#1099#1095#1085#1099#1081)
          end
        end
      end
      object tsMySQLOptions: TTabSheet
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' MySQL'
        ImageIndex = 4
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object gbMySQLIP: TGroupBox
          Left = 4
          Top = 4
          Width = 224
          Height = 60
          Caption = 'IP-'#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
          TabOrder = 0
          object eMySQLIP: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 15
            TabOrder = 0
          end
        end
        object gbMySQLPort: TGroupBox
          Left = 234
          Top = 4
          Width = 224
          Height = 60
          Caption = #1055#1086#1088#1090
          TabOrder = 1
          object eMySQLPort: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 5
            TabOrder = 0
            Text = '3306'
            OnKeyPress = eMySQLPortKeyPress
          end
        end
        object gbMySQLUser: TGroupBox
          Left = 4
          Top = 64
          Width = 224
          Height = 60
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          TabOrder = 2
          object eMySQLUser: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 50
            TabOrder = 0
          end
        end
        object gbMySQLPass: TGroupBox
          Left = 234
          Top = 64
          Width = 224
          Height = 60
          Caption = #1055#1072#1088#1086#1083#1100
          TabOrder = 3
          object eMySQLPass: TEdit
            Left = 8
            Top = 24
            Width = 206
            Height = 26
            MaxLength = 50
            PasswordChar = '#'
            TabOrder = 0
          end
        end
      end
      object tsMySQL: TTabSheet
        Caption = 'MySQL'
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object cboxMySQLUse: TCheckBox
          Left = 4
          Top = 16
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1073#1088#1091#1090#1090#1086' '#1080' '#1090#1072#1088#1091' '#1085#1072' '#1089#1077#1088#1074#1077#1088
          TabOrder = 0
        end
      end
      object tsAvitek: TTabSheet
        Caption = #1040#1074#1080#1090#1077#1082
        ImageIndex = 8
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object cboxAvitekUse: TCheckBox
          Left = 4
          Top = 16
          Width = 453
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1085#1072' '#1089#1077#1088#1074#1077#1088', '#1080#1089#1087#1086#1083#1100#1079#1091#1103' '#1084#1086#1076#1091#1083#1100' "'#1040#1074#1080#1090#1077#1082'"'
          TabOrder = 0
        end
        object gbAvitekPath: TGroupBox
          Left = 4
          Top = 40
          Width = 454
          Height = 60
          Caption = #1055#1091#1090#1100' '#1082' '#1084#1086#1076#1091#1083#1102' "'#1040#1074#1080#1090#1077#1082'"'
          TabOrder = 1
          object peAvitekPath: TPathEdit
            Left = 8
            Top = 24
            Width = 412
            Height = 26
            TabOrder = 0
            Button.Left = 420
            Button.Top = 25
            Button.Width = 24
            Button.Height = 24
            Button.Caption = '...'
            Button.TabOrder = 1
            OpenFileDialog.Filter = 'EXE '#1092#1072#1081#1083#1099'|*.exe|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
            OpenFileDialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
            OpenFolderDialog.RootFolder = foMyComputer
            OpenFolderDialog.SyncCustomButton = False
            OpenFolderDialog.Position = bpCenter
            OpenFolderDialog.PositionLeft = 0
            OpenFolderDialog.PositionTop = 0
            RelativePath = False
          end
        end
      end
      object tsUsers: TTabSheet
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvUsers: TListView
          Tag = 1
          Left = 4
          Top = 4
          Width = 456
          Height = 180
          Columns = <
            item
              Caption = #1048#1084#1103
              Width = 200
            end
            item
              Caption = #1055#1072#1088#1086#1083#1100
              Width = 200
            end>
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUsersChange
          OnCompare = lvUsersCompare
          OnDblClick = btnUserChangeClick
        end
        object btnUserAdd: TButton
          Tag = 1
          Left = 4
          Top = 192
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnUserDelete: TButton
          Tag = 1
          Left = 200
          Top = 192
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnUserChange: TButton
          Tag = 1
          Left = 102
          Top = 192
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
      object tsCargoTypes: TTabSheet
        Caption = #1056#1086#1076' '#1075#1088#1091#1079#1072
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvCargoTypes: TListView
          Tag = 4
          Left = 4
          Top = 4
          Width = 456
          Height = 180
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvCargoTypesChange
          OnCompare = lvRecipientsCompare
          OnDblClick = btnUserChangeClick
        end
        object btnCargoTypesAdd: TButton
          Tag = 4
          Left = 4
          Top = 192
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnCargoTypesChange: TButton
          Tag = 4
          Left = 102
          Top = 192
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
        object btnCargoTypesDelete: TButton
          Tag = 4
          Left = 200
          Top = 192
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
      end
      object tsSuppliers: TTabSheet
        Caption = #1043#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1080
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvSuppliers: TListView
          Tag = 3
          Left = 4
          Top = 4
          Width = 456
          Height = 180
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvSuppliersChange
          OnCompare = lvRecipientsCompare
          OnDblClick = btnUserChangeClick
        end
        object btnSupplierAdd: TButton
          Tag = 3
          Left = 3
          Top = 192
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnSupplierDelete: TButton
          Tag = 3
          Left = 200
          Top = 192
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnSupplierChange: TButton
          Tag = 3
          Left = 102
          Top = 192
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
      object tsRecipients: TTabSheet
        Caption = #1043#1088#1091#1079#1086#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvRecipients: TListView
          Tag = 2
          Left = 4
          Top = 4
          Width = 456
          Height = 180
          Columns = <
            item
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 400
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvRecipientsChange
          OnCompare = lvRecipientsCompare
          OnDblClick = btnUserChangeClick
        end
        object btnRecipientAdd: TButton
          Tag = 2
          Left = 4
          Top = 192
          Width = 90
          Height = 32
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnUserAddClick
        end
        object btnRecipientDelete: TButton
          Tag = 2
          Left = 200
          Top = 192
          Width = 90
          Height = 32
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = btnUserDeleteClick
        end
        object btnRecipientChange: TButton
          Tag = 2
          Left = 102
          Top = 192
          Width = 90
          Height = 32
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = btnUserChangeClick
        end
      end
    end
  end
  object btnSave: TButton
    Left = 8
    Top = 336
    Width = 94
    Height = 32
    Caption = #1042' '#1092#1072#1081#1083'...'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnLoad: TButton
    Left = 110
    Top = 336
    Width = 94
    Height = 32
    Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'INI-'#1092#1072#1081#1083#1099' (*.ini)|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 240
    Top = 338
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'INI-'#1092#1072#1081#1083#1099' (*.ini)|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofCreatePrompt, ofEnableSizing, ofDontAddToRecent]
    Left = 212
    Top = 338
  end
end
