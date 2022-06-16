unit WAOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc, Utils_Files, Utils_Date,
  Registry, ComCtrls, PathEdit, Grids, DB, ADODB, ValEdit, ExtSpin,
  Utils_Base64, Utils_FileIni, Utils_Log;

type
  TfrmOptions = class(TForm)
    BevelBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    PanelMain: TPanel;
    PageControl: TPageControl;
    tsProgram: TTabSheet;
    tsUsers: TTabSheet;
    lvUsers: TListView;
    btnUserAdd: TButton;
    btnUserDelete: TButton;
    gbComPort: TGroupBox;
    cboxComPort: TComboBox;
    tsScales: TTabSheet;
    gbPlace: TGroupBox;
    ePlace: TEdit;
    gbScales: TGroupBox;
    eScales: TExtSpinEdit;
    gbType: TGroupBox;
    eType: TEdit;
    gbSClass: TGroupBox;
    gbWorkMode: TGroupBox;
    cboxCanAdd: TCheckBox;
    cboxCanEdit: TCheckBox;
    cboxCanDelete: TCheckBox;
    tsMySQLOptions: TTabSheet;
    tsRecipients: TTabSheet;
    gbMySQLIP: TGroupBox;
    eMySQLIP: TEdit;
    gbMySQLPort: TGroupBox;
    eMySQLPort: TEdit;
    gbMySQLUser: TGroupBox;
    eMySQLUser: TEdit;
    gbMySQLPass: TGroupBox;
    eMySQLPass: TEdit;
    lvRecipients: TListView;
    btnRecipientAdd: TButton;
    btnRecipientDelete: TButton;
    tsSuppliers: TTabSheet;
    lvSuppliers: TListView;
    btnSupplierAdd: TButton;
    btnSupplierDelete: TButton;
    btnUserChange: TButton;
    btnRecipientChange: TButton;
    btnSupplierChange: TButton;
    cboxSClass: TComboBox;
    tsCargoTypes: TTabSheet;
    lvCargoTypes: TListView;
    btnCargoTypesAdd: TButton;
    btnCargoTypesChange: TButton;
    btnCargoTypesDelete: TButton;
    btnSave: TButton;
    btnLoad: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    tsMySQL: TTabSheet;
    cboxMySQLUse: TCheckBox;
    tsAvitek: TTabSheet;
    cboxAvitekUse: TCheckBox;
    gbAvitekPath: TGroupBox;
    peAvitekPath: TPathEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvUsersChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnUserDeleteClick(Sender: TObject);
    procedure btnUserAddClick(Sender: TObject);
    procedure lvUsersCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvRecipientsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvRecipientsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure eMySQLPortKeyPress(Sender: TObject; var Key: Char);
    procedure cboxCanEditClick(Sender: TObject);
    procedure lvSuppliersChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure eServerReadKeyPress(Sender: TObject; var Key: Char);
    procedure btnUserChangeClick(Sender: TObject);
    procedure lvCargoTypesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    function  SetUsersItem(AIndex: Integer; AUserName, APassword: String): TListItem;
    function  SetOtherItem(AIndex: Integer; S: String; What: Byte): TListItem;
    procedure LoadSettings;
    function  SaveSettings: Boolean;
    procedure SaveSettingsToINI(const AFileName: String);
    procedure LoadSettingsFromINI(const AFileName: String);
  public
  end;

function ShowOptions: Boolean;

implementation

uses WAStrings, WAMain, WAAdd, WAEdits, WAProgress, IniFiles;

{$R *.dfm}

function ShowOptions: Boolean;
begin
  with TfrmOptions.Create(Application) do
    try
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  WriteToLogForm(True, rsLOGFormOptions);
  LoadSettings;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  WriteToLogForm(False, rsLOGFormOptions);
end;

procedure TfrmOptions.LoadSettings;
var
  i: Integer;
begin
  with Settings do
    begin
      eScales.Value := Scales;
      ePlace.Text := Place;
      eType.Text := TypeS;
      cboxSClass.Text := SClass;

      cboxCanAdd.Checked := CanAdd;
      cboxCanEdit.Checked := CanEdit;
      cboxCanDelete.Checked := CanDelete;
      cboxCanEditClick(Self);
      cboxComPort.ItemIndex := ComNumber;

      cboxMySQLUse.Checked := MySQLUse;
      eMySQLIP.Text := MySQLIP;
      eMySQLPort.Text := MySQLPort;
      eMySQLUser.Text := MySQLUser;
      eMySQLPass.Text := MySQLPass;

      cboxAvitekUse.Checked := AvitekUse;
      peAvitekPath.Text := AvitekPath;
    end;
  for i := 0 to UsersAndPasswords.Count - 1 do
    SetUsersItem(-1, UsersAndPasswords.Names[i], UsersAndPasswords.ValueFromIndex[i]);
  for i := 0 to Recipients.Count - 1 do
    SetOtherItem(-1, Recipients[i], 2);
  for i := 0 to Suppliers.Count - 1 do
    SetOtherItem(-1, Suppliers[i], 3);
  for i := 0 to CargoTypes.Count - 1 do
    SetOtherItem(-1, CargoTypes[i], 4);
end;

function TfrmOptions.SaveSettings: Boolean;
var
  i: Integer;
  TempSettings: TSettings;
  SettingsList, TempSuppliers, TempRecipients,
  TempCargoTypes, TempUsersAndPasswords: TStringList;
begin
  WriteToLog(rsLOGSettingsSave);
  Result := True;
  SettingsList := TStringList.Create;
  TempSuppliers := TStringList.Create;
  TempRecipients := TStringList.Create;
  TempCargoTypes := TStringList.Create;
  TempUsersAndPasswords := TStringList.Create;
  try // finally
  try // except
    with TempSettings do
      begin
        Scales := eScales.Value;
        Place := ePlace.Text;
        TypeS := eType.Text;
        SClass := cboxSClass.Text;

        CanAdd := cboxCanAdd.Checked;
        CanEdit := cboxCanEdit.Checked;
        CanDelete := cboxCanDelete.Checked;
        ComNumber := cboxComPort.ItemIndex;

        MySQLUse := cboxMySQLUse.Checked;

        MySQLIP := eMySQLIP.Text;
        MySQLPort := eMySQLPort.Text;
        MySQLUser := eMySQLUser.Text;
        MySQLPass := eMySQLPass.Text;

        AvitekUse := cboxAvitekUse.Checked;
        AvitekPath := peAvitekPath.Text;
      end;
    for i := 0 to lvUsers.Items.Count - 1 do
      TempUsersAndPasswords.Add(ConcatNameAndValue(lvUsers.Items[i].Caption, lvUsers.Items[i].SubItems[1]));
    for i := 0 to lvRecipients.Items.Count - 1 do
      TempRecipients.Add(lvRecipients.Items[i].Caption);
    for i := 0 to lvSuppliers.Items.Count - 1 do
      TempSuppliers.Add(lvSuppliers.Items[i].Caption);
    for i := 0 to lvCargoTypes.Items.Count - 1 do
      TempCargoTypes.Add(lvCargoTypes.Items[i].Caption);
    with TempSettings do
      begin
        SettingsList.Add(IToS(Scales));
        SettingsList.Add(Place);
        SettingsList.Add(TypeS);
        SettingsList.Add(SClass);

        SettingsList.Add(BoolToS(CanAdd, '1', '0'));
        SettingsList.Add(BoolToS(CanEdit, '1', '0'));
        SettingsList.Add(BoolToS(CanDelete, '1', '0'));
        SettingsList.Add(IToS(ComNumber));

        SettingsList.Add(BoolToS(MySQLUse));
        SettingsList.Add(MySQLIP);
        SettingsList.Add(MySQLPort);
        SettingsList.Add(MySQLUser);
        SettingsList.Add(MySQLPass);

        SettingsList.Add(BoolToS(AvitekUse));
        SettingsList.Add(AvitekPath);
      end;
    for i := 0 to TempUsersAndPasswords.Count - 1 do
      begin
        SettingsList.Add(TempUsersAndPasswords.Names[i]);
        SettingsList.Add(TempUsersAndPasswords.ValueFromIndex[i]);
      end;
    SettingsList.Add(CFGEndUser);
    for i := 0 to TempRecipients.Count - 1 do
      SettingsList.Add(TempRecipients[i]);
    SettingsList.Add(CFGEndRecep);
    for i := 0 to TempSuppliers.Count - 1 do
      SettingsList.Add(TempSuppliers[i]);
    SettingsList.Add(CFGEndSupp);
    for i := 0 to TempCargoTypes.Count - 1 do
      SettingsList.Add(TempCargoTypes[i]);
    SettingsList.Add(CFGEndCargo);

    SettingsList.Add(CFGOK);

    SettingsList.Text := String(Encrypt(AnsiString(SettingsList.Text), CFGKEY));
    SettingsList.SaveToFile(ChangeFileExt(Application.ExeName, '.cfg'));

    UsersAndPasswords.Assign(TempUsersAndPasswords);
    Recipients.Assign(TempRecipients);
    Suppliers.Assign(TempSuppliers);
    CargoTypes.Assign(TempCargoTypes);
    {      with Settings do
    if (MySQLUse  <> TempSettings.MySQLUse)  or
    (MySQLIP   <> TempSettings.MySQLIP)   or (MySQLPort <> TempSettings.MySQLPort) or
    (MySQLUser <> TempSettings.MySQLUser) or (MySQLPass <> TempSettings.MySQLPass) then}

    Main.ConnectionServer.Connected := False;

    Settings := TempSettings;
    CurrentUserName := UsersAndPasswords.Names[0];
    UserDateTime := Now;
  except
    on E: Exception do
      begin
        Result := False;
        ErrorSaveLoad(acSave, rsErrorSLSettings, E.Message);
      end;
  end;
  finally
    TempUsersAndPasswords.Free;
    TempCargoTypes.Free;
    TempRecipients.Free;
    TempSuppliers.Free;
    SettingsList.Free;
  end;
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
  if SaveSettings then ModalResult := mrOk;
end;

procedure TfrmOptions.eMySQLPortKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, False, False, []);
end;

function TfrmOptions.SetUsersItem(AIndex: Integer; AUserName, APassword: String): TListItem;
begin
  if AIndex < 0 then
    begin
      Result := lvUsers.Items.Add;
      AddSubItemsToListItem(Result, lvUsers.Columns.Count + 1);
    end
  else
    Result := lvUsers.Items[AIndex];
  with Result do
    begin
      if AUserName <> #0 then Caption := AUserName;
      if APassword <> #0 then
        begin
          SubItems[1] := APassword;
          if APassword = '' then SubItems[0] := 'Нет' else SubItems[0] := 'Есть';
        end;
    end;
end;

function TfrmOptions.SetOtherItem(AIndex: Integer; S: String; What: Byte): TListItem;
var
  ListView: TListView;
begin
  case What of
  2: ListView := lvRecipients;
  3: ListView := lvSuppliers;
  4: ListView := lvCargoTypes;
  else ListView := nil;
  end;
  if AIndex < 0 then
    begin
      Result := ListView.Items.Add;
      AddSubItemsToListItem(Result, ListView.Columns.Count);
    end
  else
    Result := ListView.Items[AIndex];
  with Result do
    begin
      if S <> #0 then Caption := S;
    end;
end;

procedure TfrmOptions.lvUsersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnUserDelete.Enabled := Assigned(lvUsers.Selected);
  btnUserChange.Enabled := btnUserDelete.Enabled;
  if btnUserDelete.Enabled then btnUserDelete.Enabled := lvUsers.Selected.Index > 0;
end;

procedure TfrmOptions.lvRecipientsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnRecipientDelete.Enabled := Assigned(lvRecipients.Selected);
  btnRecipientChange.Enabled := btnRecipientDelete.Enabled;
end;

procedure TfrmOptions.lvSuppliersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnSupplierDelete.Enabled := Assigned(lvSuppliers.Selected);
  btnSupplierChange.Enabled := btnSupplierDelete.Enabled;
end;

procedure TfrmOptions.lvCargoTypesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btnCargoTypesDelete.Enabled := Assigned(lvCargoTypes.Selected);
  btnCargoTypesChange.Enabled := btnCargoTypesDelete.Enabled;
end;

procedure TfrmOptions.btnUserDeleteClick(Sender: TObject);
var
  ListView: TListView;
  i: Integer;
begin
  case TButton(Sender).Tag of
  1: ListView := lvUsers;
  2: ListView := lvRecipients;
  3: ListView := lvSuppliers;
  4: ListView := lvCargoTypes;
  else Exit;
  end;
  if MsgBoxYesNo(Format(rsQuestionDelete, [rsRecords])) then
    for i := ListView.Items.Count - 1 downto 0 do
      if ListView.Items[i].Selected then ListView.Items[i].Delete;
end;

procedure TfrmOptions.btnUserAddClick(Sender: TObject);
var
  ListView: TListView;
begin
  case TControl(Sender).Tag of
  1: ListView := lvUsers;
  2: ListView := lvRecipients;
  3: ListView := lvSuppliers;
  4: ListView := lvCargoTypes;
  else Exit;
  end;
  ListView.Selected := nil;
  btnUserChangeClick(Sender);
end;

procedure TfrmOptions.btnUserChangeClick(Sender: TObject);
var
  Index: Integer;
  ListItem: TListItem;
  ListView: TListView;
  AEditForm: TEditForm;
  S1, S2: String;
begin
  case TControl(Sender).Tag of
  1: begin
    ListView := lvUsers;
    AEditForm := efUsers;
    if Assigned(lvUsers.Selected) then
      begin
        S1 := lvUsers.Selected.Caption;
        S2 := lvUsers.Selected.SubItems[1];
      end;
  end;
  2: begin
    ListView := lvRecipients;
    AEditForm := efRecipients;
    if Assigned(lvRecipients.Selected) then
      S1 := lvRecipients.Selected.Caption;
  end;
  3: begin
    ListView := lvSuppliers;
    AEditForm := efSuppliers;
    if Assigned(lvSuppliers.Selected) then
      S1 := lvSuppliers.Selected.Caption;
  end;
  4: begin
    ListView := lvCargoTypes;
    AEditForm := efCargoType;
    if Assigned(lvCargoTypes.Selected) then
      S1 := lvCargoTypes.Selected.Caption;
  end;
  else Exit;
  end;
  if ShowEdit(Self, AEditForm, S1, S2, S2) then
    begin
      ListItem := ListView.FindCaption(0, S1, False, True, False);
      if Assigned(ListItem) then Index := ListItem.Index
      else
        begin
          if Assigned(ListView.Selected) then Index := ListView.Selected.Index
          else Index := -1;
        end;
      case TControl(Sender).Tag of
      1:       ListItem := SetUsersItem(Index, S1, S2);
      2, 3, 4: ListItem := SetOtherItem(Index, S1, TControl(Sender).Tag);
      end;
      ListView.AlphaSort;
      ListView.Selected := nil;
      SelectListItem(ListItem);
    end;
end;

procedure TfrmOptions.lvUsersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if Item1.Index = 0 then Compare := -1
  else
    if Item2.Index = 0 then Compare := 1
    else
      Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
end;

procedure TfrmOptions.lvRecipientsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare := AnsiCompareStr(Item1.Caption, Item2.Caption);
end;

procedure TfrmOptions.cboxCanEditClick(Sender: TObject);
  procedure UpdateCheckBoxes(CheckBox: TCheckBox);
  begin
    CheckBox.Enabled := cboxCanEdit.Checked;
    if not CheckBox.Enabled then CheckBox.Checked := False;
  end;
begin
  UpdateCheckBoxes(cboxCanAdd);
  UpdateCheckBoxes(cboxCanDelete);
end;

procedure TfrmOptions.eServerReadKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, False, False, [COMMA]);
end;

procedure TfrmOptions.SaveSettingsToINI(const AFileName: String);
var
  i: Integer;
begin
  with CreateINIFile(AFileName), Settings do
    try
      WriteInteger('Settings', 'Scales',     Scales);
      WriteString ('Settings', 'Place',      Place);
      WriteString ('Settings', 'TypeS',      TypeS);
      WriteString ('Settings', 'SClass',     SClass);
      WriteBool   ('Settings', 'CanAdd',     CanAdd);
      WriteBool   ('Settings', 'CanEdit',    CanEdit);
      WriteBool   ('Settings', 'CanDelete',  CanDelete);
      WriteInteger('Settings', 'ComNumber',  ComNumber);

      WriteBool   ('MySQL', 'Use',  MySQLUse);
      WriteString ('MySQL', 'IP',   MySQLIP);
      WriteString ('MySQL', 'Port', MySQLPort);
      WriteString ('MySQL', 'User', MySQLUser);

      WriteBool   ('Avitek',   'Use',    cboxAvitekUse.Checked);
      WriteString ('Avitek',   'Path',   peAvitekPath.Text);

      for i := 0 to Suppliers.Count - 1 do
        WriteString('Suppliers', IToS(i), Suppliers[i]);
      for i := 0 to Recipients.Count - 1 do
        WriteString('Recipients', IToS(i), Recipients[i]);
      for i := 0 to CargoTypes.Count - 1 do
        WriteString('CargoTypes', IToS(i), CargoTypes[i]);
      for i := 0 to UsersAndPasswords.Count - 1 do
        WriteString('Users', IToS(i), UsersAndPasswords.Names[i]);
    finally
      Free;
    end;
end;

procedure TfrmOptions.LoadSettingsFromINI(const AFileName: String);
var
  i: Integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  with CreateINIFile(AFileName) do
    try
      eScales.Value :=         ReadInteger('Settings', 'Scales',     eScales.Value);
      ePlace.Text :=           ReadString ('Settings', 'Place',      ePlace.Text);
      eType.Text :=            ReadString ('Settings', 'TypeS',      eType.Text);
      cboxSClass.Text :=       ReadString ('Settings', 'SClass',     cboxSClass.Text);
      cboxCanAdd.Checked :=    ReadBool   ('Settings', 'CanAdd',     cboxCanAdd.Checked);
      cboxCanEdit.Checked :=   ReadBool   ('Settings', 'CanEdit',    cboxCanEdit.Checked);
      cboxCanDelete.Checked := ReadBool   ('Settings', 'CanDelete',  cboxCanDelete.Checked);
      cboxCanEditClick(Self);
      cboxComPort.ItemIndex := ReadInteger('Settings', 'ComNumber',  cboxComPort.ItemIndex);

      cboxMySQLUse.Checked :=  ReadBool   ('MySQL', 'Use',  cboxMySQLUse.Checked);
      eMySQLIP.Text :=         ReadString ('MySQL', 'IP',   eMySQLIP.Text);
      eMySQLPort.Text :=       ReadString ('MySQL', 'Port', eMySQLPort.Text);
      eMySQLUser.Text :=       ReadString ('MySQL', 'User', eMySQLUser.Text);

      cboxAvitekUse.Checked :=     ReadBool   ('Avitek', 'Use',    cboxAvitekUse.Checked);
      peAvitekPath.Text :=         ReadString ('Avitek', 'Path',   peAvitekPath.Text);

      ReadSectionValues('Suppliers', TempList);
      lvSuppliers.Clear;
      for i := 0 to TempList.Count - 1 do SetOtherItem(-1, TempList.ValueFromIndex[i], 3);
      ReadSectionValues('Recipients', TempList);
      lvRecipients.Clear;
      for i := 0 to TempList.Count - 1 do SetOtherItem(-1, TempList.ValueFromIndex[i], 2);
      ReadSectionValues('CargoTypes', TempList);
      lvCargoTypes.Clear;
      for i := 0 to TempList.Count - 1 do SetOtherItem(-1, TempList.ValueFromIndex[i], 4);
      ReadSectionValues('Users', TempList);
      lvUsers.Clear;
      for i := 0 to TempList.Count - 1 do SetUsersItem(-1, TempList.ValueFromIndex[i], '');
    finally
      TempList.Free;
      Free;
    end;
end;

procedure TfrmOptions.btnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then SaveSettingsToINI(SaveDialog.FileName);
end;

procedure TfrmOptions.btnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then LoadSettingsFromINI(OpenDialog.FileName);
end;

end.

