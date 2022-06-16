unit WAEdits;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_Date, WAAdd;

type
  TfrmValueEdit = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    BevelTop: TBevel;
    eCaption: TLabeledEdit;
    eString1: TLabeledEdit;
    eString2: TLabeledEdit;
    procedure btnOKClick(Sender: TObject);
    procedure eCaptionKeyPress(Sender: TObject; var Key: Char);
  private
    EditForm: TEditForm;
  public
  end;

function ShowEdit(Owner: TForm; AEditForm: TEditForm; var ACaption, AString1, AString2: String): Boolean;

implementation

uses WAStrings;

{$R *.dfm}

function ShowEdit(Owner: TForm; AEditForm: TEditForm; var ACaption, AString1, AString2: String): Boolean;
const
  EditCaptions:     array[TEditForm, 1..3] of String = (('Имя:',              'Пароль:',  'Подтвеждение:'),
                                                       ('Грузополучатель:',  '',         ''),
                                                       ('Грузоотправитель:', '',         ''),
                                                       ('Род груза:',        '',         ''));
  EditMaxLengths:   array[TEditForm] of Integer = (32,  32,  32,  42);
  FormWidth:        array[TEditForm] of Integer = (380, 226, 226, 226);
begin
  with TfrmValueEdit.Create(Owner) do
    try
      EditForm := AEditForm;
      eCaption.EditLabel.Caption := EditCaptions[EditForm, 1];
      eCaption.MaxLength := EditMaxLengths[EditForm];
      case EditForm of
      efRecipients, efSuppliers, efCargoType: eCaption.Width := 210;
      end;
      if EditForm = efUsers then
        begin
          eString1.PasswordChar := '#';
          eString2.PasswordChar := '#';
          eCaption.Width := eCaption.Width + 50;
          eString1.Left := eString1.Left   + 50;
          eString2.Left := eString2.Left   + 50;
        end;
      eString1.EditLabel.Caption := EditCaptions[EditForm, 2];
      eString2.EditLabel.Caption := EditCaptions[EditForm, 3];
      eString1.Visible := eString1.EditLabel.Caption <> '';
      eString2.Visible := eString2.EditLabel.Caption <> '';
      ClientWidth := FormWidth[EditForm];
      if ACaption <> '' then
        begin
          ActiveControl := eCaption;
          eCaption.Text := ACaption;
          eString1.Text := AString1;
          eString2.Text := AString2;
        end;
      Result := ShowModal = mrOk;
      if Result then
        begin
          ACaption := eCaption.Text;
          AString1 := eString1.Text;
          AString2 := eString2.Text;
        end;
    finally
      Free;
    end;
end;

procedure TfrmValueEdit.btnOKClick(Sender: TObject);
begin
  if eCaption.Text = '' then
    begin
      MsgBoxErr(rsErrorString, Handle);
      eCaption.SetFocus;
      Exit;
    end
  else
    if EditForm in [efRecipients, efSuppliers, efCargoType] then ModalResult := mrOk;
  if EditForm = efUsers then
    begin
      if eString1.Text <> eString2.Text then
        begin
          MsgBoxErr(rsErrorCheckPass, Handle);
          eString2.SetFocus;
        end
      else
        ModalResult := mrOk;
      Exit;
    end;
end;

procedure TfrmValueEdit.eCaptionKeyPress(Sender: TObject; var Key: Char);
begin
//
end;

end.
