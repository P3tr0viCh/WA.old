unit WAAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Utils_FileIni, Dialogs, ComCtrls, StdCtrls, ExtCtrls, Utils_Str, Utils_Misc,
  Utils_Files, Utils_Date, DateUtils, StrUtils, DB, ADODB, SqlTimSt,
  Utils_Log;

const                             
  CFGKEY      = 28510;
  SCALES_TYPE = 2007;
  CFGOK       = 'P3tr0viCh777';
  CFGEndUser  = '@EnD@UserS#';
  CFGEndRecep = '@EnD@Recep#';
  CFGEndSupp  = '@EnD@Supp#';
  CFGEndCargo = '@EnD@CargO#';

  ColorsRO: array[Boolean, Boolean] of TColor = ((clWindowText, clYellow), (clWindow, clBlack));

  ctServer = True;
  ctLocal  = False;

type
  TListTable        = (ltBrutto, ltTares);
  TEditForm         = (efUsers, efRecipients, efSuppliers, efCargoType);
  TWorkMode         = (wmReadWrite, wmReadOnly);
  TProcessAction    = (acLoad, acSave, acDelete);
  TSend             = (sdNo, sdUnknown, sdYes);
  TAutoEditState    = (asNew, asEdit);
  TAvitekMessage    = (amNewData, amOpenSession, amCloseSession, amCloseServer);

  TDates  = (dtAll, dtSelected);
  TFilter = record
    Apply: Boolean;
    DateFrom,
    DateTo: TDateTime;
    Dates: TDates;
    AutoNum: String;
  end;

  TSettings = record
    Scales:     SmallInt; // Номер весов
    Place:      String;   // Место установки
    TypeS:      String;   // Тип весов
    SClass:     String;   // Точность в статике
    CanAdd,
    CanEdit,
    CanDelete:  Boolean;  // Разрешения для пользователей
    ComNumber:  Integer;  // Номер порта COM
    MySQLUse:  Boolean;   // Взаимодействие с сервером MySQL
    MySQLIP:   String;    // IP сервера MySQL
    MySQLPort: String;    // Порт сервера MySQL
    MySQLUser: String;    // Пользователь на сервере
    MySQLPass: String;    // Пароль пользователя на сервере

    AvitekUse: Boolean;   // Сохранение на сервер посредством модуля "Авитек"
    AvitekPath: String;   // Путь модуля "Авитек"
  end;

var
  Settings: TSettings;
  BruttoFilter, TareFilter: TFilter;
  cFloatFmt: String  = ',0.00';

  Suppliers,
  Recipients,
  CargoTypes,
  UsersAndPasswords: TStringList;

  CurrentUserName: String;
  IsAdministrator: Boolean;
  UserDateTime: TDateTime;

function  CanServer: Boolean;
function  OpenConnections: Boolean;
procedure SelectConnection(AConnectionServer: Boolean);

procedure SetQuerySQL(ASQLString: String);

procedure SQLOpen(ALOGString: String; AServer: Boolean; AProgressDataRead: Boolean = True);
procedure SQLExec(ASQLString, ALOGString: String; AServer: Boolean);
function  SQLFormatValue(AValue: Variant): String;
function  SQLFormatValues(AValues: array of Variant): String;
function  SQLInsert(ATableName, AFields, AValues: String): String;
function  SQLUpdate(ATableName: String; AColumns: array of String; AValues: array of Variant; AWhere: String): String;
function  SQLDelete(ATableName, AWhere: String): String;
function  SQLSelect(ATableName, AWhat, AWhere: String): String;
function  SQLWhere(AWhere: String): String;
function  SQLLocateIndex(ATableName: String; ANameOfIndex: array of String; AIndex: array of Variant): Boolean;
function  SQLGetNewIndex(ATableName, ANameOfIndex: String): Variant;
function  SQLNameEqualValue(AName: String; AValue: Variant): String;
function  SQLNamesEqualValues(AColumns: array of String; AValues: array of Variant): String;

procedure ClearFilter(var AFilter: TFilter);
function  FilterToSQL(AConnectionServer: Boolean; AFilter: TFilter): String;

function  DTToMDBStr(ADateTime: TDateTime): String;
function  DTToSQLStr(ADateTime: TDateTime): String;
function  DTToWTime(ADateTime: TDateTime): Integer;
function  DTToWTimeStr(ADateTime: TDateTime): String;
function  DTToStr   (ADateTime: TDateTime; WithSec: Boolean): String;
function  SQLStrToDT(ASQLDateTime: String): TDateTime;

procedure TerminateApplication;

procedure ShowMsg(AMessage: String);
procedure ErrorSaveLoad(ProcessAction: TProcessAction; AWhat, AError: String; CloseConnections: Boolean = True);

function  FmtFloat(Value: Double): String;
function  SToF(Value: String): Double;

procedure SetEditReadOnly(AEdit: TLabeledEdit; AReadOnly: Boolean); overload;
procedure SetEditReadOnly(AEdit: TEdit; AReadOnly: Boolean); overload;
procedure SetComboBoxReadOnly(AComboBox: TComboBox; AReadOnly: Boolean);
function  CheckedFirst(ARadioGroup: TRadioGroup): Boolean;
procedure CheckDataListKeyDown(DataList: TListView; Key: Word; Shift: TShiftState);

function  CalcTotal(DataList: TListView; What: Integer; OnlySelected: Boolean): String;
function  CalcDiff(X1, X2: String): String;
function  CalcSum(X1, X2: String): String;

implementation

uses WAStrings, WAMain, WAProgress, WALocalDBPass;

function CanConnectServer: Boolean;
begin
  with Settings do Result := MySQLUse and (Scales <> 0) and (MySQLIP <> '');
end;

function CanServer: Boolean;
begin
  Result := CanConnectServer;
  if Result then Result := Main.ConnectionServer.Connected;
  Main.UpdateStatusBar;
end;

function OpenConnections: Boolean;
var
  LocalDB, sError, sErrorE: String;
begin
   Result := False;
   sError := '';
   try
      frmProgress.ProgressCaption := rsProgressConnection;
      frmProgress.ProgressInLAN := False;

      LocalDB := ChangeFileExt(Application.ExeName, '.mdb');
      if not FileExists(LocalDB) then
         begin
            sError := Format(rsErrorLocalNotExists, [LocalDB]) + rsErrorCloseApp;
            Exit;
         end;
      if not Main.ConnectionLocal.Connected then
         begin
            Main.ConnectionLocal.ConnectionString := Format(rsConnectionLocal, [LocalDB, cLocalPassword]);
            try
               Main.ConnectionLocal.Open;
            except
               on E: Exception do sErrorE := E.Message;
            end;
            if not Main.ConnectionLocal.Connected then
               begin
                  sError := Format(rsErrorLocalOpen, [sErrorE]) + rsErrorCloseApp;
                  Exit;
               end;
         end;

      Result := sError = '';

      if CanConnectServer then
         begin
            frmProgress.ProgressInLAN := True;
            if not Main.ConnectionServer.Connected then
               begin
                  with Settings do
                     Main.ConnectionServer.ConnectionString := Format(rsConnectionServer,
                        [MySQLIP, MySQLPort, MySQLUser, MySQLPass]);
                  try
                     Main.ConnectionServer.Open;
                  except
                     on E: Exception do sErrorE := E.Message;
                  end;
                  if not Main.ConnectionServer.Connected then sError := Format(rsErrorServerNotExists, [sErrorE]);
               end;
         end;
   finally
      if sError <> '' then
         begin
            MsgBoxErr(sError);
            WriteToLog('ERROR: ' + sError);
            if not Main.ConnectionLocal.Connected then TerminateApplication;
         end;
   end;
end;

procedure SelectConnection(AConnectionServer: Boolean);
var
   ADOConnection: TADOConnection;
begin
   if AConnectionServer then ADOConnection := Main.ConnectionServer
                        else ADOConnection := Main.ConnectionLocal;
   Main.Query.Connection := ADOConnection;
   frmProgress.ProgressInLAN := AConnectionServer;
end;

procedure SetQuerySQL(ASQLString: String);
begin
   Main.Query.SQL[0] := ASQLString;
end;

procedure TerminateApplication;
begin
   Main.SetBounds(-1, -1, 0, 0);
   Application.Terminate;
end;

procedure ShowMsg(AMessage: String);
var
   MsgHandle: HWND;
begin
   if frmProgress.Visible then MsgHandle := frmProgress.Handle else MsgHandle := 1;
   MsgBox(AMessage, 64, '', MsgHandle);
end;

procedure ErrorSaveLoad(ProcessAction: TProcessAction; AWhat, AError: String; CloseConnections: Boolean = True);
var
   S, SAction, SDB: String;
   MsgHandle: HWND;
begin
   if CloseConnections then
      begin
         Main.ConnectionLocal.Close;
         Main.ConnectionServer.Close;
         CanServer;
      end;
   if frmProgress.Visible then MsgHandle := frmProgress.Handle else MsgHandle := 1;
   if frmProgress.ProgressInLAN then SDB := rsErrorServerDB else SDB := rsErrorLocalDB;
   case ProcessAction of
   acLoad:     SAction := rsErrorLoad;
   acSave:     SAction := rsErrorSave;
   acDelete:   SAction := rsErrorDelete;
   end;
   S := Format(rsErrorSaveLoad, [Format(SAction, [AWhat, SDB]), AError]);
   WriteToLog('ERROR: ' + S);
   MsgBoxErr(S, MsgHandle);
end;

function FmtFloat(Value: Double): String;
begin
   Result := FormatFloat(cFloatFmt, Value);
end;

function  SToF(Value: String): Double;
begin
   Result := StrToFloat(Value);
end;

procedure ClearFilter(var AFilter: TFilter);
begin
   with AFilter do
      begin
         Apply := False;
         DateFrom := Yesterday;
         DateTo := Today;
         Dates := dtAll;
         AutoNum := '';
      end;
end;

function FilterToSQL(AConnectionServer: Boolean; AFilter: TFilter): String;
var
  sDates, ADateFrom, ADateTo: String;
begin
  Result := '';
  with AFilter do
    begin
      case Dates of
      dtAll:      sDates := '';
      else
        begin
          DateFrom := StartOfTheDay(DateFrom);
          DateTo := EndOfTheDay(DateTo);
          if AConnectionServer then
            begin
              ADateFrom := SQLFormatValue(DTToSQLStr(DateFrom));
              ADateTo :=   SQLFormatValue(DTToSQLStr(DateTo));
            end
          else
            begin
              ADateFrom := SQLFormatValue(Double(DateFrom));
              ADateTo :=   SQLFormatValue(Double(DateTo));
            end;
          if DateTo > Now then
            sDates := Format(rsFilterDate1, [ADateFrom])
          else
            sDates := Format(rsFilterDate2, [ADateFrom, ADateTo]);
        end;
      end;
      Result := sDates;
      if AutoNum <> '' then Result := ConcatStrings(Result,
        Format(rsFilterAutoNum, [AutoNum]), rsFilterAnd);
    end;
//  ShowMsg(Result);
end;

function  SQLFormatValue(AValue: Variant): String;
begin
  Result := VarToStr(AValue);
  case VarType(AValue) of
  varUString,
  varString:
    Result := AddQuotes(
      StringReplace(StringReplace(StringReplace(Result, '\',  '\\',  [rfReplaceAll]),
        '"',  '\"',  [rfReplaceAll]),
        '''', '\''', [rfReplaceAll]));
  varDouble:  Result := StringReplace(Result, COMMA, DOT, []);
  varDate:    Result := DTToMDBStr(AValue);
  end;
end;

function  SQLFormatValues(AValues: array of Variant): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(AValues) to High(AValues) do
    Result := ConcatStrings(Result, SQLFormatValue(AValues[i]), ', ');
end;

function  SQLInsert(ATableName, AFields, AValues: String): String;
begin
   Result := Format(rsSQLInsert, [ATableName, AFields, AValues]);
end;

function  SQLUpdate(ATableName: String; AColumns: array of String; AValues: array of Variant; AWhere: String): String;
begin
  Result := Format(rsSQLUpdate, [ATableName, SQLNamesEqualValues(AColumns, AValues), AWhere]);
end;

function  SQLWhere(AWhere: String): String;
begin
  Result := rsSQLWhere + AWhere;
end;

function  SQLDelete(ATableName, AWhere: String): String;
begin
  Result := Format(rsSQLDelete, [ATableName]) + SQLWhere(AWhere);
end;

function  SQLSelect(ATableName, AWhat, AWhere: String): String;
begin
  Result := Format(rsSQLSelect, [AWhat, ATableName]);
  if AWhere <> '' then Result := Result + SQLWhere(AWhere);
end;

function  SQLNameEqualValue(AName: String; AValue: Variant): String;
begin
  Result := Format(rsNameEqualValue, [AName, SQLFormatValue(AValue)]);
end;

function  SQLNamesEqualValues(AColumns: array of String; AValues: array of Variant): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(AColumns) to High(AColumns) do
    Result := ConcatStrings(Result,
      SQLNameEqualValue(AColumns[i], AValues[i]), ', ');
end;

function  SQLLocateIndex(ATableName: String; ANameOfIndex: array of String; AIndex: array of Variant): Boolean;
var
  i: Integer;
  ANamesOfIndex, AIndexes: String;
begin
  for i := Low(ANameOfIndex) to High(ANameOfIndex) do
    begin
      ANamesOfIndex := ConcatStrings(ANamesOfIndex, ANameOfIndex[i], COMMA);
      AIndexes := ConcatStrings(AIndexes, SQLNameEqualValue(ANameOfIndex[i], AIndex[i]), rsFilterAnd);
    end;
  SetQuerySQL(SQLSelect(ATableName, ANamesOfIndex, AIndexes));
  //   MsgBox(Main.Query.SQL[0]);
  SQLOpen('', False);
  try
    Result := Main.Query.RecordCount <> 0;
  finally
    Main.Query.Close;
  end;
end;

function  SQLGetNewIndex(ATableName, ANameOfIndex: String): Variant;
begin
  Randomize;
  repeat
    Result := Random(MAXLONG - 1) + 1;
  until not SQLLocateIndex(ATableName, ANameOfIndex, Result);
end;

type
  TSQLOpenThread = class(TThread)
  protected
    FErrorMessage: String;
    FQuery: TADOQuery;
  procedure Execute; override;
  public
    constructor Create(AQuery: TADOQuery);
  end;

constructor TSQLOpenThread.Create(AQuery: TADOQuery);
begin
  FQuery := AQuery;
  FreeOnTerminate := False;
  inherited Create(True);
end;

procedure TSQLOpenThread.Execute;
begin
  try
    try
      FQuery.Open;
    except
      on E: Exception do
        begin
          FErrorMessage := E.Message;
        end;
    end;
  finally
    Terminate;
  end;
end;

function GetLOGOpenExecServer(AOpen, AServer: Boolean): String;
begin
  Result := 'SQL ';
  if AOpen then Result := Result + 'OPEN' else Result := Result + 'EXEC';
  Result := Result + ' (';
  if AServer then Result := Result + 'server' else Result := Result + 'local';
  Result := Result + '): ';
end;

procedure SQLOpen(ALOGString: String; AServer: Boolean; AProgressDataRead: Boolean = True);
var
  FirstTick: LongWord;
  ErrorMessage: String;
begin
  StartTimer(FirstTick);
  ErrorMessage := '';
  if AProgressDataRead then frmProgress.ProgressDataRead := True;
  with TSQLOpenThread.Create(Main.Query) do
    try
      ShowWaitCursor;
      {$WARNINGS OFF}
      Resume;
      {$WARNINGS ON}
      while not Terminated do ProcMess;
    finally
      ErrorMessage := FErrorMessage;
      Free;
      if ALOGString <> '' then
        WriteToLog(GetLOGOpenExecServer(True, AServer) + ALOGString +
          ' (' + MyFormatTime(ExtractHMSFromMS(GetTickCount - FirstTick), True) + ')');
      if AProgressDataRead then frmProgress.ProgressDataRead := False;
      RestoreCursor;
    end;
  if ErrorMessage <> '' then raise Exception.Create(ErrorMessage);
end;

procedure SQLExec(ASQLString, ALOGString: String; AServer: Boolean);
begin
  if ALOGString <> '' then
    WriteToLog(GetLOGOpenExecServer(True, AServer) + ALOGString);
  SetQuerySQL(ASQLString);
  Main.Query.ExecSQL;
end;

function  DTToSQLStr(ADateTime: TDateTime): String;
begin
  Result := FormatDateTime(rsDateTimeFormatSQL, ADateTime);
end;

function  DTToMDBStr(ADateTime: TDateTime): String;
begin
  Result := FormatDateTime(rsDateTimeFormatMDB, ADateTime);
end;

function  SQLStrToDT(ASQLDateTime: String): TDateTime;
var
  Year, Month, Day, Hour, Min, Sec: String;
begin
  SplitStr(ASQLDateTime, '-', 0, Year,  ASQLDateTime);
  SplitStr(ASQLDateTime, '-', 0, Month, ASQLDateTime);
  SplitStr(ASQLDateTime, ' ', 0, Day,   ASQLDateTime);
  SplitStr(ASQLDateTime, ':', 0, Hour,  ASQLDateTime);
  SplitStr(ASQLDateTime, ':', 0, Min,   Sec);
  Result := EncodeDateTime(SToI(Year), SToI(Month), SToI(Day), SToI(Hour), SToI(Min), SToI(Sec), 0);
end;

function  DTToWTime(ADateTime: TDateTime): Integer;
begin
  Result := Integer(DateTimeToUnix(IncHour(ADateTime, -5)));
end;

function  DTToWTimeStr(ADateTime: TDateTime): String;
begin
  Result := IToS(DTToWTime(ADateTime));
end;

function  DTToStr(ADateTime: TDateTime; WithSec: Boolean): String;
begin
  with DTToST(ADateTime) do
    begin
      Result := IToS_0(wDay) + '.' + IToS_0(wMonth) + '.' +
        Copy(IToS(wYear), 3, 2) + ' ' +
        IToS_0(wHour) + ':' + IToS_0(wMinute);
      if WithSec then Result := Result + ':' + IToS_0(wSecond);
    end;
end;

procedure SetEditReadOnly(AEdit: TLabeledEdit; AReadOnly: Boolean);
begin
  with AEdit do
    begin
      ReadOnly := AReadOnly;
      Color := ColorsRO[True, AReadOnly];
      Font.Color := ColorsRO[False, AReadOnly];
    end;
end;

procedure SetEditReadOnly(AEdit: TEdit; AReadOnly: Boolean);
begin
  with AEdit do
    begin
      ReadOnly := AReadOnly;
      Color := ColorsRO[True, AReadOnly];
      Font.Color := ColorsRO[False, AReadOnly];
    end;
end;

procedure SetComboBoxReadOnly(AComboBox: TComboBox; AReadOnly: Boolean);
begin
  with AComboBox do
    begin
      Enabled := not AReadOnly;
      Color := ColorsRO[True, AReadOnly];
      Font.Color := ColorsRO[False, AReadOnly];
    end;
end;

function CheckedFirst(ARadioGroup: TRadioGroup): Boolean;
begin
  Result := ARadioGroup.ItemIndex = 0
end;

procedure CheckDataListKeyDown(DataList: TListView; Key: Word; Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
    case Key of
    {A} 65:  DataList.SelectAll;
    {U} 85:  DataList.Selected := nil;
    end;
end;

function CalcTotal(DataList: TListView; What: Integer; OnlySelected: Boolean): String;
var
  W: Extended;
  I: Integer;
begin
  W := 0;
  if OnlySelected then OnlySelected := DataList.SelCount <> 0;
  for I := 0 to DataList.Items.Count - 1 do
    try
      if OnlySelected then
        begin
          if DataList.Items[i].Selected then
            W := W + StrToFloat(DataList.Items[i].SubItems[What]);
        end
      else
        W := W + StrToFloat(DataList.Items[i].SubItems[What]);
    except
    end;
  Result := FmtFloat(W);
end;

function CalcDiffOrSum(X1, X2: String; CalcSum: Boolean): String;
begin
  if (X1 = '') or (X2 = '') then Result := rsError
  else
    try
      if CalcSum then
        Result := FmtFloat(StrToFloat(X1) + StrToFloat(X2))
      else
        Result := FmtFloat(StrToFloat(X1) - StrToFloat(X2));
    except
      Result := rsError;
    end;
end;

function CalcDiff(X1, X2: String): String;
begin
  Result := CalcDiffOrSum(X1, X2, False);
end;

function CalcSum(X1, X2: String): String;
begin
  Result := CalcDiffOrSum(X1, X2, True);
end;

initialization
  Suppliers := TStringList.Create;
  Recipients := TStringList.Create;
  CargoTypes := TStringList.Create;
  UsersAndPasswords := TStringList.Create;

finalization
  UsersAndPasswords.Free;
  CargoTypes.Free;
  Recipients.Free;
  Suppliers.Free;

end.
