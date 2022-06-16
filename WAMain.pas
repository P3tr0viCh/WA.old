unit WAMain;

interface                                      

{$IFDEF DEBUG}
  {$DEFINE FORCECLOSE}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms, ShellAPI,
  DateUtils, Dialogs, StdCtrls, ExcelXP, Classes, Utils_Date, Utils_Str,
  Utils_Misc, Utils_Files, Utils_FileIni, Buttons, AboutFrm, ComCtrls, ExtCtrls,
  DB, ADODB, ImgList, OleServer, WAAdd, Utils_Office, Printers, Math,
  Utils_Graf, Menus, Utils_Base64, Utils_Log, System.ImageList;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    ImageList32: TImageList;
    ConnectionLocal: TADOConnection;
    ConnectionServer: TADOConnection;
    gbWeight: TGroupBox;
    btnStartWeight: TBitBtn;
    gbBase: TGroupBox;
    btnBaseTares: TBitBtn;
    btnBaseBrutto: TBitBtn;
    ImageList16: TImageList;
    gbUserName: TGroupBox;
    pnlUserName: TPanel;
    btnChangeUser: TBitBtn;
    gbPrograms: TGroupBox;
    btnCalc: TBitBtn;
    gbOther: TGroupBox;
    btnOptions: TBitBtn;
    btnAbout: TBitBtn;
    btnClose: TBitBtn;
    Query: TADOQuery;
    procedure btnCloseClick(Sender: TObject);
    procedure btnBaseBruttoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnChangeUserClick(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnStartWeightClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBaseTaresClick(Sender: TObject);
  private
    WM_WA_NEW_DATA,
    WM_AVITEK_NEW_WDATA,
    WM_AVITEK_OPEN_WSESSION,
    WM_AVITEK_CLOSE_WSESSION,
    WM_AVITEK_CLOSE_ISERVER: UINT;
    function  PerformOpenDataBase: Boolean;
  public
    function  LoadSettings: Boolean;

    procedure ChangeUser;
    procedure SetWorkMode;
    procedure UpdateStatusBar;

    function  SaveToServer(AWhat: Byte; Values: array of String): Boolean;
    function  SaveScaleInfo: Boolean;

    procedure MessageNewData();
    procedure AvitekMessage(AMessage: TAvitekMessage);
    function  AvitekRun: Boolean;
    procedure AvitekStop;
    procedure AvitekNewData;
  end;

var
  Main: TMain;

implementation

uses WAStrings, WALogin, WAOptions, WAProgress, WAAllLists, WAWeight,
  WAAutoEdit;

{$R *.dfm}

procedure TMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TMain.PerformOpenDataBase: Boolean;
begin
  Result := LoadSettings;
  UpdateStatusBar;
  if Result then Result := ShowLogin;
  if Result and Settings.AvitekUse then AvitekRun;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  WM_WA_NEW_DATA := RegisterWindowMessage('WM_WA_NEW_DATA');
  WM_AVITEK_NEW_WDATA := RegisterWindowMessage('WM_AVITEK_NEW_WDATA');
  WM_AVITEK_OPEN_WSESSION := RegisterWindowMessage('WM_AVITEK_OPEN_WSESSION');
  WM_AVITEK_CLOSE_WSESSION := RegisterWindowMessage('WM_AVITEK_CLOSE_WSESSION');
  WM_AVITEK_CLOSE_ISERVER := RegisterWindowMessage('WM_AVITEK_CLOSE_ISERVER');

  WriteToLog('<><><><><><><>< START PROGRAM WA ' + GetFileVersion(Application.ExeName) + ' ><><><><><><><>');

  Query.SQL.Add('');
  StatusBar.Panels[0].Text := Copy(rsCopyright, 1, Pos('|', rsCopyright) - 1);
  Main.Caption := Application.Title + ' ' + GetFileVersion(Application.ExeName);

  frmProgress := TfrmProgress.Create(Self);

  with CreateINIFile do
    try
      with BruttoFilter do
        begin
          Apply := ReadBool(rsFilterBrutto, 'Apply', False);
          Dates := TDates(ReadInteger(rsFilterBrutto, 'Dates', 0));
          case Dates of
          dtAll:      begin DateFrom := 0; DateTo := 0; end;
          else
            begin
              DateFrom := ReadDate(rsFilterBrutto, 'DateFrom', StartOfTheDay(Date));
              DateTo :=   ReadDate(rsFilterBrutto, 'DateTo',   EndOfTheDay(Date));
            end;
          end;
          AutoNum := ReadString(rsFilterBrutto, 'AutoNum', '');
        end;
      with TareFilter do
        begin
          Apply := ReadBool(rsFilterTare, 'Apply', False);
          Dates := TDates(ReadInteger(rsFilterTare, 'Dates', 0));
          case Dates of
          dtAll:      begin DateFrom := 0; DateTo := 0; end;
          else
            begin
              DateFrom := ReadDate(rsFilterTare, 'DateFrom', StartOfTheDay(Date));
              DateTo :=   ReadDate(rsFilterTare, 'DateTo',   EndOfTheDay(Date));
            end;
          end;
          AutoNum := ReadString(rsFilterTare, 'AutoNum', '');
        end;
      ReadFormPosition(Self);
    finally
      Free;
    end;
  if not PerformOpenDataBase then Left := -1;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  frmProgress.Free;
  if Left <> -1 then
    begin
      with CreateINIFile do
        try
          with BruttoFilter do
            begin
              WriteBool(rsFilterBrutto,     'Apply',    Apply);
              WriteInteger(rsFilterBrutto,  'Dates',    Ord(Dates));
              WriteDate(rsFilterBrutto,     'DateFrom', DateFrom);
              WriteDate(rsFilterBrutto,     'DateTo',   DateTo);
              WriteString(rsFilterBrutto,   'AutoNum',  AutoNum);
            end;
          with TareFilter do
            begin
              WriteBool(rsFilterTare,     'Apply',    Apply);
              WriteInteger(rsFilterTare,  'Dates',    Ord(Dates));
              WriteDate(rsFilterTare,     'DateFrom', DateFrom);
              WriteDate(rsFilterTare,     'DateTo',   DateTo);
              WriteString(rsFilterTare,   'AutoNum',  AutoNum);
            end;
          WriteFormPosition(Self);
        finally
          Free;
        end;
      if Settings.AvitekUse then AvitekStop;
    end;
  WriteToLog('STOP PROGRAM');
end;

function  TMain.LoadSettings: Boolean;
var
  i: Integer;
  S1, S2: String;
  SettingsFile: String;
  SettingsList: TStringList;

  function GetSettingsList(var Index: Integer): String;
  begin
    Result := SettingsList[i]; Inc(i);
  end;
begin
  Result := False;
  SettingsFile := ChangeFileExt(Application.ExeName, '.cfg');
  SettingsList := TStringList.Create;
  try
  try
    Result := FileExists(SettingsFile);
    if not Result then
      begin
        ErrorSaveLoad(acLoad, rsErrorSLSettings, rsErrorSettingsNotExists + rsErrorCloseApp);
        Exit;
      end;

    SettingsList.LoadFromFile(SettingsFile);
    UsersAndPasswords.Clear;
    Recipients.Clear;
    Suppliers.Clear;

    SettingsList.Text := String(Decrypt(AnsiString(SettingsList[0]), CFGKEY));

    Result := SettingsList.Count >= 20;
    if Result then
      Result := SettingsList[SettingsList.Count - 1] = CFGOK;
    if not Result then
      begin
        ErrorSaveLoad(acLoad, rsErrorSLSettings, rsErrorSettingsBad + rsErrorCloseApp);
        Exit;
      end;

    with Settings do
      begin
        i := 0;
        Scales :=        SToI(GetSettingsList(i));
        Place :=         GetSettingsList(i);
        TypeS :=         GetSettingsList(i);
        SClass :=        GetSettingsList(i);
        CanAdd :=        SToBool(GetSettingsList(i), '1', '0');
        CanEdit :=       SToBool(GetSettingsList(i), '1', '0');
        CanDelete :=     SToBool(GetSettingsList(i), '1', '0');
        ComNumber :=     SToI(GetSettingsList(i));

        MySQLUse :=     SToBool(GetSettingsList(i));
        MySQLIP :=      GetSettingsList(i);
        MySQLPort :=    GetSettingsList(i);
        MySQLUser :=    GetSettingsList(i);
        MySQLPass :=    GetSettingsList(i);

        AvitekUse :=     SToBool(GetSettingsList(i));
        AvitekPath :=    GetSettingsList(i);
      end;
    while SettingsList[i] <> CFGEndUser do
      begin
        S1 := GetSettingsList(i);
        S2 := GetSettingsList(i);
        UsersAndPasswords.Add(ConcatNameAndValue(S1, S2));
      end;
    Inc(i);
    while SettingsList[i] <> CFGEndRecep do Recipients.Add(GetSettingsList(i));
    Inc(i);
    while SettingsList[i] <> CFGEndSupp  do Suppliers.Add(GetSettingsList(i));
    Inc(i);
    while SettingsList[i] <> CFGEndCargo do CargoTypes.Add(GetSettingsList(i));
    Result := True;
  except
    on E: Exception do
      begin
        Result := False;
        ErrorSaveLoad(acLoad, rsErrorSLSettings, rsErrorSettingsBad + rsErrorCloseApp);
      end;
  end;
  finally
    SettingsList.Free;
    if not Result then TerminateApplication;
  end;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {$IFNDEF FORCECLOSE}
  CanClose := MsgBoxYesNo(rsQuestionCloseProgram);
  {$ENDIF}
end;

procedure TMain.btnAboutClick(Sender: TObject);
begin
  WriteToLog('ABOUT');
  ShowAbout(13, 2, 1, #0, nil, rsAddComp, #0, #0, rsCopyright, rsEULA2 + sLineBreak + rsEULA3 + sLineBreak + rsEULA4);
end;

procedure TMain.ChangeUser;
begin
  pnlUserName.Caption := CurrentUserName;
  WriteToLog('USER: ' + CurrentUserName);
  SetWorkMode;
end;

procedure TMain.SetWorkMode;
const
  AboutTops:     array[Boolean] of Integer = (24,  76);
  OtherHeights:  array[Boolean] of Integer = (100, 152);
begin
  btnStartWeight.Enabled := Settings.CanAdd or IsAdministrator;
  btnOptions.Visible := IsAdministrator;
  gbOther.Height := OtherHeights[IsAdministrator];
  btnAbout.Top := AboutTops[IsAdministrator];
  btnClose.Top := AboutTops[IsAdministrator];
  gbOther.Top := ClientHeight - gbOther.Height - 32;
end;

procedure TMain.btnChangeUserClick(Sender: TObject);
begin
  ShowLogin;
end;

procedure TMain.btnCalcClick(Sender: TObject);
begin
  //   msgbox(DTToWTimeStr(StrToDateTime('26.06.2007 23:59:00')));
  //   MsgBox(DateTimeToStr(SQLStrToDT('1981-03-29 21:34:23')));
  ShellExec('Calc.exe');
end;

procedure TMain.btnStartWeightClick(Sender: TObject);
var
  ATypeBrutto: Boolean;
  ASQLDateTime, ABrutto: String;
begin
  if StartWeight(ASQLDateTime, ABrutto, ATypeBrutto) then
    ShowAutoNew(ASQLDateTime, ABrutto, ATypeBrutto);
end;

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_F4:   if btnStartWeight.Visible then btnStartWeight.Click;
    VK_F5:   btnBaseBrutto.Click;
    VK_F6:   btnBaseTares.Click;
    VK_F12:  btnChangeUser.Click;
    end;
end;

procedure TMain.btnBaseBruttoClick(Sender: TObject);
begin
  ShowListForm(ltBrutto);
end;

procedure TMain.btnBaseTaresClick(Sender: TObject);
begin
  ShowListForm(ltTares);
end;

procedure TMain.btnOptionsClick(Sender: TObject);
begin
  if ShowOptions then
    begin
      if SaveScaleInfo then ChangeUser;
      if Settings.AvitekUse then AvitekRun else AvitekStop;
    end;
end;

function TMain.SaveToServer(AWhat: Byte; Values: array of String): Boolean;
// AWhat: 0 - scalesinfo, 1 - heap_weighstep
var
  ATableName, AFields, AValues, AError: String;
begin
  frmProgress.Show;
  try
    with Settings do
      try
        Result := OpenConnections;
        if not Result then Exit;
        if not CanServer then Exit;

        case AWhat of
        0: begin
          frmProgress.ProgressCaption := rsProgressScaleInfoSave;
          ATableName := rsTableServerScalesInfo;
          AFields := rsSQLServerScalesInfo;
          AValues := SQLFormatValues([
            Scales,                    // Номер весов
            DTToWTimeStr(Now),         // Системное время начала связи
            DTToSQLStr(Now),           // Дата и время начала связи
            // Системное время окончания связи
            // Дата и время окончания связи
            // Системное время окончания последнего взвешивания
            GetLocalIP,                // ИП-адрес весов
            TypeS,                     // Тип весов
            SClass,                    // Класс точности в статике
            '',                        // Класс точности в динамике
            Place,                     // Место установки весов
            SCALES_TYPE                // Признак типа весов
            ]);
          AError := rsErrorSLScaleInfo;
        end;
        else Exit;
        end;

        SelectConnection(ctServer);

        frmProgress.MaxProgress(1, True);

        SQLExec(SQLDelete(ATableName, SQLNameEqualValue(rsScalesIndex, Scales)), '', True);
        //      MsgBox(SQLInsert(ATableName, AFields, AValues)); Exit;
        SQLExec(SQLInsert(ATableName, AFields, AValues), rsLOGScaleInfoSave, True);

        frmProgress.StepProgress;
      except
        on E: Exception do
          begin
            Result := False;
            ErrorSaveLoad(acSave, AError, E.Message);
          end;
      end;
  finally
      frmProgress.Hide;
  end;
end;

function TMain.SaveScaleInfo: Boolean;
begin
  Result := SaveToServer(0, []);
end;

procedure TMain.UpdateStatusBar;
begin
  //if ConnectionServer.Connected or Settings.AvitekUse then StatusBar.Panels[1].Text := '' else StatusBar.Panels[1].Text := rsServerOFF;
end;

procedure TMain.MessageNewData();
begin
  SendMessage(HWND_BROADCAST, WM_WA_NEW_DATA, 0, 0);
end;

procedure TMain.AvitekMessage(AMessage: TAvitekMessage);
var
  Msg: UINT;
  LogMsg: String;
begin
  Msg := 0;
  case AMessage of
  amNewData:        begin Msg := WM_AVITEK_NEW_WDATA;      LogMsg := rsLOGAvitekNewData;      end;
  amOpenSession:    begin Msg := WM_AVITEK_OPEN_WSESSION;  LogMsg := rsLOGAvitekOpenSession;  end;
  amCloseSession:   begin Msg := WM_AVITEK_CLOSE_WSESSION; LogMsg := rsLOGAvitekCloseSession; end;
  amCloseServer:    begin Msg := WM_AVITEK_CLOSE_ISERVER;  LogMsg := rsLOGAvitekCloseServer;  end;
  end;
  WriteToLog(LogMsg);
  SendMessage(HWND_BROADCAST, Msg, 0, 0);
end;

function TMain.AvitekRun: Boolean;
var
  Handle: HWND;
  Inst: HINST;
  S: String;
begin
  Result := EXEIsRunning(Settings.AvitekPath, True);
  if not Result then
    begin
      WriteToLog(rsLOGAvitekRunModule);
      Inst := ShellExecute(Application.Handle, nil,
        PChar(Settings.AvitekPath), nil, nil, SW_SHOWNORMAL);
      Delay(1000);
      Result := Inst > 32;
      if Result then
        begin
          SetForegroundWindow(Application.Handle);
          AvitekMessage(amOpenSession);
          Handle := FindWindow(PChar('TWServerForm'), nil);
          if Handle <> 0 then
            PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
        end
      else
        begin
          if Inst = ERROR_FILE_NOT_FOUND then
            S := Format(rsErrorAvitekNotExists, [Settings.AvitekPath])
          else
            S := SysErrorMessage(GetLastError);
          MsgBoxErr(S);
          WriteToLog('ERROR: ' + S);
        end;
    end;
end;

procedure TMain.AvitekStop;
begin
  if not EXEIsRunning(Settings.AvitekPath, True) then Exit;
  AvitekMessage(amCloseSession);
  Delay(1000);
  AvitekMessage(amCloseServer);
end;

procedure TMain.AvitekNewData;
begin
  if not EXEIsRunning(Settings.AvitekPath, True) then Exit;
  AvitekMessage(amNewData);
end;

end.
