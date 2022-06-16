object frmValueEdit: TfrmValueEdit
  Left = 588
  Top = 324
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 99
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    330
    99)
  PixelsPerInch = 96
  TextHeight = 16
  object BevelTop: TBevel
    Left = 4
    Top = 57
    Width = 320
    Height = 5
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 158
    Top = 66
    Width = 80
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 242
    Top = 66
    Width = 80
    Height = 28
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object eCaption: TLabeledEdit
    Left = 8
    Top = 24
    Width = 100
    Height = 24
    EditLabel.Width = 38
    EditLabel.Height = 16
    EditLabel.Caption = 'Edit 1:'
    TabOrder = 0
    OnKeyPress = eCaptionKeyPress
  end
  object eString1: TLabeledEdit
    Left = 116
    Top = 24
    Width = 100
    Height = 24
    EditLabel.Width = 38
    EditLabel.Height = 16
    EditLabel.Caption = 'Edit 2:'
    TabOrder = 1
    OnKeyPress = eCaptionKeyPress
  end
  object eString2: TLabeledEdit
    Left = 220
    Top = 24
    Width = 100
    Height = 24
    EditLabel.Width = 38
    EditLabel.Height = 16
    EditLabel.Caption = 'Edit 3:'
    TabOrder = 2
    OnKeyPress = eCaptionKeyPress
  end
end
