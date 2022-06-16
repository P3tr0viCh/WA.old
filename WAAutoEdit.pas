unit WAAutoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Utils_FileIni, Utils_Misc, Utils_Str, ExtCtrls, StdCtrls, WAAdd,
  Buttons, Utils_Log;

type
  TfrmAutoEdit = class(TForm)
    gbDateTime: TGroupBox;
    pnlDateTime: TPanel;
    gbAutoType: TGroupBox;
    pnlAutoType: TPanel;
    BevelBottom: TBevel;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    gbNumber: TGroupBox;
    eNumber: TEdit;
    gbNetto: TGroupBox;
    eNetto: TEdit;
    gbBrutto: TGroupBox;
    eBrutto: TEdit;
    gbTare: TGroupBox;
    eTare: TEdit;
    gbCargoType: TGroupBox;
    cboxCargoType: TComboBox;
    gbRecipient: TGroupBox;
    cboxRecipient: TComboBox;
    gbSupplier: TGroupBox;
    cboxSupplier: TComboBox;
    gbInvoice_Num: TGroupBox;
    eInvoice_Num: TEdit;
    gbDriver: TGroupBox;
    eDriver: TEdit;
    btnDriverFromBase: TBitBtn;
    btnTareFromBase: TBitBtn;
    pnlTareDate: TPanel;
    gbInvoice_Netto: TGroupBox;
    eInvoice_Netto: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eTareChange(Sender: TObject);
    procedure eTareKeyPress(Sender: TObject; var Key: Char);
    procedure eTareExit(Sender: TObject);
    procedure btnTareFromBaseClick(Sender: TObject);
    procedure btnDriverFromBaseClick(Sender: TObject);
    procedure eTareContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure eNumberChange(Sender: TObject);
    procedure eInvoice_NettoKeyPress(Sender: TObject; var Key: Char);
  private
    AutoEditState: TAutoEditState;
    SQLDateTime,
    SQLDateTimeTare: String;
    TypeBrutto: Boolean;
    ATableName,
    AErrorSaveLoad, AProgressCaptionSave, AProgressCaptionLoad: String;

    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure SetData(ASQLDateTime, ANumber, ABrutto, ATare, ATareDate,
                      ACargoType, AInvoice_Num, ASupplier, ARecipient,
                      AInvoice_Netto, ADriver: String);

    procedure UpdateEditState;
    procedure UpdateWeight;

    function  SaveData: Boolean;
    function  LoadData: Boolean;

    procedure LoadTare(ALoadTare, ALoadDriver: Boolean);
  public
  end;

function ShowAutoNew(ASQLDateTime, ABrutto: String; ATypeBrutto: Boolean): Boolean;
function ShowAutoEdit(ASQLDateTime: String; ATypeBrutto: Boolean): Boolean;

implementation

uses WAStrings, WAProgress, WAMain, DB;

{$R *.dfm}

function ShowAutoForm(AAutoEditState: TAutoEditState; ASQLDateTime, ABrutto: String;
   ATypeBrutto: Boolean): Boolean;
var
  S, ATare: String;
begin
  case AAutoEditState of
  asNew:   begin
    S := rsLOGFormAutoNew;
    if ATypeBrutto then S := S + ' brutto = ' + ABrutto
    else S := S + ' tare = ' + ABrutto;
  end;
  asEdit:  begin
    S := rsLOGFormAutoEdit;
    if ATypeBrutto then S := S + ' brutto'
    else S := S + ' tare';
    S := S + ', datetime = ' + ASQLDateTime;
  end;
  end;
  S := rsLOGFormAuto + ' ' + S;
  WriteToLogForm(True, S);

  with TfrmAutoEdit.Create(Application) do
    try
      AutoEditState := AAutoEditState;
      SQLDateTime := ASQLDateTime;
      TypeBrutto := ATypeBrutto;

      UpdateEditState;

      if TypeBrutto then
        begin
          ATare := '';
          ATableName := rsTableBrutto;
          AErrorSaveLoad := rsErrorSLBrutto;
          AProgressCaptionSave := rsProgressBruttoSave;
          AProgressCaptionLoad := rsProgressBruttoLoad;
          gbTare.Caption := 'Тара, дата и время провески тары';
        end
      else
        begin
          ATare := ABrutto;
          ATableName := rsTableTares;
          AErrorSaveLoad := rsErrorSLTare;
          AProgressCaptionSave := rsProgressTareSave;
          AProgressCaptionLoad := rsProgressTareLoad;
          gbTare.Caption := 'Тара';
        end;

      case AutoEditState of
      asNew:   begin
        SetData(ASQLDateTime, '', ABrutto, ATare, ASQLDateTime, '', '', '', '', '', '');
        UpdateWeight;
      end;
      asEdit:  begin
        Result := LoadData;
        UpdateWeight;
        if not Result then Exit;
      end;
      end;
      Result := ShowModal = mrOk;
      WriteToLogForm(False, rsLOGFormAuto);
    finally
      Free;
    end;
end;

function ShowAutoNew(ASQLDateTime, ABrutto: String; ATypeBrutto: Boolean): Boolean;
begin
  Result := ShowAutoForm(asNew, ASQLDateTime, ABrutto, ATypeBrutto);
end;

function ShowAutoEdit(ASQLDateTime: String; ATypeBrutto: Boolean): Boolean;
begin
  Result := ShowAutoForm(asEdit, ASQLDateTime, '', ATypeBrutto);
end;

procedure TfrmAutoEdit.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

procedure TfrmAutoEdit.FormCreate(Sender: TObject);
begin
  with CreateINIFile do
    try
      cboxCargoType.Items := CargoTypes;
      //         cboxCargoType.Items.Insert(0, rsNo);
      cboxSupplier.Items := Suppliers;
      //         cboxSupplier.Items.Insert(0, rsNo);
      cboxRecipient.Items := Recipients;
      //         cboxRecipient.Items.Insert(0, rsNo);

      ReadFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmAutoEdit.FormDestroy(Sender: TObject);
begin
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmAutoEdit.UpdateEditState;
const
  FormHeights: array[Boolean] of Integer = (202, 458);
begin
  case AutoEditState of
  asNew:   Caption := rsStateNew;
  asEdit:  Caption := rsStateEdit;
  end;
  Caption := Caption + rsStateAdd;

  if TypeBrutto then pnlAutoType.Caption := rsTypeBrutto
  else
    begin
      pnlAutoType.Caption := rsTypeTare;
      gbTare.SetBounds(468, gbDriver.Top, 112, gbTare.Height);
      eTare.Width := gbTare.Width - 24;
    end;

  gbBrutto.Visible := TypeBrutto;
  gbNetto.Visible := TypeBrutto;

  gbCargoType.Visible := TypeBrutto;
  gbInvoice_Num.Visible := TypeBrutto;
  gbInvoice_Netto.Visible := TypeBrutto;
  gbSupplier.Visible := TypeBrutto;
  gbRecipient.Visible := TypeBrutto;
  pnlTareDate.Visible := TypeBrutto;
  btnTareFromBase.Visible := TypeBrutto;

  ClientHeight := FormHeights[TypeBrutto];

  SetEditReadOnly(eTare, not TypeBrutto);
end;

procedure TfrmAutoEdit.SetData(ASQLDateTime, ANumber, ABrutto, ATare, ATareDate,
  ACargoType, AInvoice_Num, ASupplier, ARecipient, AInvoice_Netto, ADriver: String);
  procedure ComboBoxSelect(ComboBox: TComboBox; AText: String);
  begin
    with ComboBox do
      begin
        if AText <> '' then
          begin
            ItemIndex := Items.IndexOf(AText);
            if ItemIndex = -1 then ItemIndex := Items.Add(AText);
          end
        else
          ItemIndex := -1;
      end;
  end;
begin
  if ATare = '' then ATare := '0';

  if ASQLDateTime <> #0 then
    pnlDateTime.Caption := DTToStr(SQLStrToDT(ASQLDateTime), True);

  if ANumber      <> #0 then eNumber.Text := ANumber;

  if ABrutto      <> #0 then eBrutto.Text := ABrutto;
  if ATare        <> #0 then eTare.Text := ATare;
  if ATareDate    <> #0 then
    begin
      if ATareDate = '' then SQLDateTimeTare := DTToSQLStr(Now)
      else SQLDateTimeTare := ATareDate;
      pnlTareDate.Caption := DTToStr(SQLStrToDT(SQLDateTimeTare), False);
    end;

  if ACargoType     <> #0 then ComboBoxSelect(cboxCargoType, ACargoType);
  if AInvoice_Num   <> #0 then eInvoice_Num.Text := AInvoice_Num;
  if ASupplier      <> #0 then ComboBoxSelect(cboxSupplier,  ASupplier);
  if ARecipient     <> #0 then ComboBoxSelect(cboxRecipient, ARecipient);
  if AInvoice_Netto <> #0 then eInvoice_Netto.Text := AInvoice_Netto;

  if ADriver        <> #0 then eDriver.Text := ADriver;
end;

procedure TfrmAutoEdit.btnSaveClick(Sender: TObject);
begin
  if SaveData then ModalResult := mrOk;
end;

procedure TfrmAutoEdit.UpdateWeight;
begin
  if TypeBrutto then
    eNetto.Text := CalcDiff(eBrutto.Text, eTare.Text);
end;

procedure TfrmAutoEdit.eTareChange(Sender: TObject);
begin
  UpdateWeight;
end;

procedure TfrmAutoEdit.eTareKeyPress(Sender: TObject; var Key: Char);
begin
  if CheckKeyIsNumeral(Key, True, False, []) then
    SetData(#0, #0, #0, #0, '', #0, #0, #0, #0, #0, #0);
end;

procedure TfrmAutoEdit.eTareExit(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then TEdit(Sender).Text := '0';
end;

procedure TfrmAutoEdit.eInvoice_NettoKeyPress(Sender: TObject; var Key: Char);
begin
  CheckKeyIsNumeral(Key, True, False, []);
end;

function TfrmAutoEdit.SaveData: Boolean;
var
  SaveOnServer: Boolean;

  function CheckData: Boolean;
  var
    ErrorMessage: String;

    function CheckNeedString(S, sError: String): Boolean;
    begin
      Result := S = '';
      if Result then ErrorMessage := ConcatStrings(ErrorMessage, sError, sLineBreak);
    end;

    function CheckInteger(sInteger, sError: String; CantZero: Boolean): Boolean;
    var
      F: Double;
      S: String;
    begin
      Result := IsNumber(sInteger, True, True);
      if Result then
        begin
          F := StrToFloat(sInteger);
          if CantZero then Result := F <> 0;
          if Result then Result := F >= 0;
          if not Result then S := Format(rsErrorValueBad, [sError, rsErrorNumberNil, sInteger]);
        end
      else
        begin
         S := Format(rsErrorValueBad, [sError, rsErrorNumberBad, sInteger]);
        end;
      if not Result then ErrorMessage := ConcatStrings(ErrorMessage, S, sLineBreak);
    end;

    procedure CheckGrossAndTare(Gross, Tare: String);
    begin
      if StrToFloat(Tare) > StrToFloat(Gross) then
      ErrorMessage := ConcatStrings(ErrorMessage, rsErrorGrossTare, sLineBreak);
    end;
  begin
    ErrorMessage := '';
    if eTare.Text          = '' then eTare.Text := '0';
    if eInvoice_Netto.Text = '' then eInvoice_Netto.Text := '0';

    if CheckNeedString(eNumber.Text, rsErrorNumber) then eNumber.SetFocus;
    if not CheckInteger(eInvoice_Netto.Text, rsInvoiceNetto, False) then eInvoice_Netto.SetFocus;
    if CheckInteger(eTare.Text, rsTares, False) and TypeBrutto then
    CheckGrossAndTare(eBrutto.Text, eTare.Text);

    Result := ErrorMessage = '';
    if not Result then
    ErrorSaveLoad(acSave, AErrorSaveLoad, ErrorMessage, False);
  end;

  function PerformSaveData(AConnectionServer: Boolean): Boolean;
  var
    AFields, AValues, AWhere, S: String;
    ADateTime: TDateTime;
    WTime: Integer;

    function GetComboBoxText(AComboBox: TComboBox): String;
    begin
      with AComboBox do
        Result := Text;
      //            if ItemIndex = 0 then Result := '' else Result := Items[ItemIndex];
    end;
  begin
    Result := True;
    SelectConnection(AConnectionServer);
    ADateTime := SQLStrToDT(SQLDateTime);
    WTime := DTToWTime(ADateTime);
    if AConnectionServer then
      begin
        AWhere := SQLNameEqualValue(rsDateTimeIndex, SQLDateTime) + rsFilterAnd +
          SQLNameEqualValue(rsScalesIndex, Settings.Scales);
        if TypeBrutto then AFields := rsSQLServerBruttoSave
        else AFields := rsSQLServerTares;
      end
    else
      begin
        AWhere := SQLNameEqualValue(rsDateTimeIndex, ADateTime);
        if TypeBrutto then AFields := rsSQLLocalBrutto else
        AFields := rsSQLLocalTares;
      end;
    try
//      ShowMsg(SQLDelete(ATableName, AWhere)); Exit;
      if AWhere <> '' then
        SQLExec(SQLDelete(ATableName, AWhere), '', AConnectionServer);

      if AConnectionServer then
        begin
          if TypeBrutto then
            AValues := SQLFormatValues([
              SQLDateTime,
              WTime,
              eNumber.Text,
              SToF(eBrutto.Text),
              SToF(eTare.Text),
              SQLDateTimeTare,
              SToF(eNetto.Text),
              GetComboBoxText(cboxCargoType),
              eInvoice_Num.Text,
              GetComboBoxText(cboxSupplier),
              GetComboBoxText(cboxRecipient),
              SToF(eInvoice_Netto.Text),
              eDriver.Text,
              CurrentUserName,
              Settings.Scales])
          else
            AValues := SQLFormatValues([
              SQLDateTime,
              WTime,
              eNumber.Text,
              SToF(eTare.Text),
              eDriver.Text,
              CurrentUserName,
              Settings.Scales]);
        end
      else // AConnectionServer
        begin
          if TypeBrutto then
            AValues := SQLFormatValues([
              ADateTime,
              WTime,
              eNumber.Text,
              SToF(eBrutto.Text),
              SToF(eTare.Text),
              SQLStrToDT(SQLDateTimeTare),
              GetComboBoxText(cboxCargoType),
              eInvoice_Num.Text,
              GetComboBoxText(cboxSupplier),
              GetComboBoxText(cboxRecipient),
              SToF(eInvoice_Netto.Text),
              eDriver.Text,
              CurrentUserName,
              SaveOnServer])
          else
            AValues := SQLFormatValues([
              ADateTime,
              WTime,
              eNumber.Text,
              SToF(eTare.Text),
              eDriver.Text,
              CurrentUserName,
              SaveOnServer]);
        end;

//      ShowMsg(SQLInsert(ATableName, AFields, AValues)); Exit;
      if TypeBrutto then S := 'ins auto ' + eNumber.Text + ' brutto ' + eBrutto.Text
      else S := 'ins auto ' + eNumber.Text + ' tare '   + eTare.Text;

      SQLExec(SQLInsert(ATableName, AFields, AValues), S, AConnectionServer);

      if AConnectionServer then SaveOnServer := True;

      frmProgress.StepProgress;
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acSave, AErrorSaveLoad, E.Message);
        end;
    end;
  end;
begin
  Result := CheckData;
  if not Result then Exit;

  frmProgress.Show;
  try
    SaveOnServer := False;
    Result := OpenConnections;
    if not Result then Exit;
    frmProgress.MaxProgress(1, False);
    frmProgress.ProgressCaption := AProgressCaptionSave;

    if CanServer then PerformSaveData(ctServer);
    Result := PerformSaveData(ctLocal);
  finally
    Main.MessageNewData;
    Main.AvitekNewData;
    frmProgress.Hide;
  end;
end;

function TfrmAutoEdit.LoadData: Boolean;
  function PerformLoadData: Boolean;
  var
    AFields, S: String;
  begin
    SelectConnection(ctLocal);
    if TypeBrutto then
      begin
        S := rsLOGBruttoLoad;
        AFields := rsSQLLocalBrutto;
      end
    else
      begin
        S := rsLOGTareLoad;
        AFields := rsSQLLocalTares;
      end;
    SetQuerySQL(SQLSelect(ATableName, AFields,
      SQLNameEqualValue(rsDateTimeIndex, SQLStrToDT(SQLDateTime))));

//    MsgBox(Main.Query.SQL[0]); //Exit;

    with Main.Query do
      try // except
        SQLOpen(S, ctLocal);
        try // finally
          Result := RecordCount <> 0;
          if not Result then Exit;
          if TypeBrutto then
            begin
              SetData(
                DTToSQLStr(
                  Fields[0].AsDateTime), // Дата и время взвешивания (BDATETIME)
                Fields[2].AsString,      // Номер авто (NUMBER)
                Fields[3].AsString,      // Брутто (BRUTTO)
                Fields[4].AsString,      // Тара (TARE)
                DTToSQLStr(
                  Fields[5].AsDateTime), // Дата и время взвешивания тары (IDATETIME_TARE)
                Fields[6].AsString,      // Род груза (CARGOTYPE)
                Fields[7].AsString,      // Номер накладной (INVOICE_NUM)
                Fields[8].AsString,      // Грузоотправитель (INVOICE_SUPPLIER)
                Fields[9].AsString,      // Грузополучатель (INVOICE_RECIPIENT)
                Fields[10].AsString,     // Вес по накладной (INVOICE_NETTO)
                Fields[11].AsString)     // Водитель (DRIVER)
            end
          else
            begin
              SetData(
                DTToSQLStr(
                  Fields[0].AsDateTime),
                Fields[2].AsString,
                '',
                Fields[3].AsString,
                #0,
                '',
                '',
                '',
                '',
                '',
                Fields[4].AsString);
            end;
        finally
          Close;
        end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acLoad, AErrorSaveLoad, E.Message);
          end;
      end;
  end;
begin
  frmProgress.Show;
  try
    Result := OpenConnections;
    if not Result then Exit;
    frmProgress.ProgressCaption := AProgressCaptionLoad;
    Result := PerformLoadData;
  finally
    frmProgress.Hide;
  end;
end;

procedure TfrmAutoEdit.LoadTare(ALoadTare, ALoadDriver: Boolean);
var
  AErrorNotFound: Boolean;
  AError, ATare, ATareDate, ADriver: String;

  function CheckNumber: Boolean;
  begin
    Result := eNumber.Text <> '';
    if not Result then
      ErrorSaveLoad(acLoad, AError, rsErrorNumber, False);
  end;

  function PerformLoadTare(AConnectionServer: Boolean): Boolean;
  var
    AQuery: String;
  begin
    Result := True;
    SelectConnection(AConnectionServer);
    with Main.Query do
      try // except
        AQuery := SQLSelect(rsTableTares, rsSQLTareLoad,
        SQLNameEqualValue(rsAuto_NumIndex, eNumber.Text)) + rsSQLOrder + rsDateTimeIndex + rsSQLOrderDesc;
        if AConnectionServer then AQuery := AQuery + rsSQLLimitOne;
        SetQuerySQL(AQuery);

        //            ShowMsg(AQuery); //Exit;

        SQLOpen(rsLOGTareDriverFind, AConnectionServer);
        try
          AErrorNotFound := RecordCount = 0;
          //               MsgBox(RecordCount); //Exit;
          if not AErrorNotFound then
            begin
              if ALoadTare then
                begin
                  ATare := FmtFloat(Fields[0].AsFloat);
                  ATareDate := DTToSQLStr(Fields[1].AsDateTime);
                end
              else
                begin
                  ATare := #0;
                  ATareDate := #0;
                end;
              if ALoadDriver then ADriver := Fields[2].AsString else ADriver := #0;
              SetData(#0, #0, #0, ATare, ATareDate, #0, #0, #0, #0, #0, ADriver);
            end;
        finally
          Close;
        end;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acLoad, AError, E.Message);
          end;
      end;
  end;
begin
  if ALoadTare then AError := rsErrorSLTare else AError := rsErrorSLDriver;
  if ALoadTare then SetData(#0, #0, #0, '', '', #0, #0, #0, #0, #0, '');
  if not CheckNumber then Exit;
  frmProgress.Show;
  try
    if not OpenConnections then Exit;

    if ALoadTare then
      frmProgress.ProgressCaption := rsProgressTareLoad
    else
      frmProgress.ProgressCaption := rsProgressDriverLoad;

    if CanServer then
      begin
        if not PerformLoadTare(ctServer) then
          PerformLoadTare(ctLocal);
      end
    else
      PerformLoadTare(ctLocal);
  finally
    frmProgress.Hide;
  end;
  if AErrorNotFound then
    begin
      if ALoadTare then AError := rsErrorTareNotFound else AError := rsErrorDriverNotFound;
      MsgBox(Format(AError, [eNumber.Text]), MB_OK or MB_ICONEXCLAMATION);
    end;
end;

procedure TfrmAutoEdit.btnTareFromBaseClick(Sender: TObject);
begin
  LoadTare(True, True);
end;

procedure TfrmAutoEdit.btnDriverFromBaseClick(Sender: TObject);
begin
  LoadTare(False, True);
end;

procedure TfrmAutoEdit.eTareContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
end;

procedure TfrmAutoEdit.eNumberChange(Sender: TObject);
begin
  if TypeBrutto then SetData(#0, #0, #0, '', '', #0, #0, #0, #0, #0, #0);
end;

end.
