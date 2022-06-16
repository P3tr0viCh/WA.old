unit WALogin;

interface


{$IFDEF DEBUG}
  {$DEFINE FORCELOGON}
  {$DEFINE FORCECLOSE}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Utils_Graf,
  Dialogs, ExtCtrls, StdCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_FileIni, Utils_KAndM;

type
  TfrmLogin = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    bvlBottom: TBevel;
    cboxNames: TComboBox;
    lblName: TLabel;
    ePassword: TLabeledEdit;
    ImageUsers: TImage;
    ImagePassword: TImage;
    ImageLogon: TImage;
    bvlTop: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure cboxNamesChange(Sender: TObject);
  private
    function  CheckPassword: Boolean;
    procedure UpdateNamesBox;
  public
  end;

function ShowLogin: Boolean;

implementation

uses WAStrings, WAMain, WAAdd;

{$R *.dfm}

function ShowLogin: Boolean;
begin
  Result := False;
  Main.Hide;
  try
    with TfrmLogin.Create(Application) do
    try
      {$IFDEF FORCELOGON}
      if IsShift then
        begin
          {$ENDIF}
          cboxNames.ItemIndex := cboxNames.Items.IndexOf(CurrentUserName);
          cboxNamesChange(nil);
          Result := ShowModal = mrOk;
          {$IFDEF FORCELOGON}
        end
      else
        begin
          cboxNames.ItemIndex := 0;
          Result := True;
        end;
      {$ENDIF}
      if Result then
        begin
          CurrentUserName := cboxNames.Text;
          UserDateTime := Now;
          IsAdministrator := cboxNames.ItemIndex = 0;
        end
      else
        begin
         CurrentUserName := '';
        end;
    finally
      Free;
    end;
  finally
    if Result then
      begin
        Main.ChangeUser;
        Main.Show;
      end
    else Application.Terminate;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  ImageLogon.Picture.Bitmap.LoadFromResourceName(HInstance, 'LOGON');
  Caption := Main.Caption;
  UpdateNamesBox;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
//
end;

function TfrmLogin.CheckPassword: Boolean;
begin
  Result := cboxNames.ItemIndex <> -1;
  if not Result then
    begin
      cboxNames.Text := '';
      cboxNames.SetFocus;
      MsgBoxErr(rsErrorSelectUser);
      Exit;
    end;
  Result := ePassword.Text = UsersAndPasswords.ValueFromIndex[cboxNames.ItemIndex];
  if (not Result) and (UsersAndPasswords.ValueFromIndex[0] <> '') then
    Result := ePassword.Text = UsersAndPasswords.ValueFromIndex[0];
  if not Result then
    begin
      ePassword.Clear;
      ePassword.SetFocus;
      MsgBoxErr(rsErrorPassword);
    end;
end;

procedure TfrmLogin.btnOKClick(Sender: TObject);
begin
  if not CheckPassword then ModalResult := mrNone;
end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ModalResult = mrOk;
  {$IFDEF FORCECLOSE}
  CanClose := True;
  {$ELSE}
  if not CanClose then
    CanClose := MsgBoxYesNo(rsQuestionCloseProgram);
  {$ENDIF}
end;

procedure TfrmLogin.cboxNamesChange(Sender: TObject);
begin
  cboxNames.Text := ComboBoxText(cboxNames);
  ePassword.Clear;
end;

procedure TfrmLogin.UpdateNamesBox;
begin
  AddNamesOrValues(cboxNames.Items, UsersAndPasswords, True);
end;

end.
