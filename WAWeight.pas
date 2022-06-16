unit WAWeight;

interface

//{$DEFINE RANDOMDATA}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Utils_FileIni, ComPort, Utils_Misc,
  Utils_Log;

type
  TfrmWeight = class(TForm)
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    BevelBottom: TBevel;
    gbGross: TGroupBox;
    pnlGross: TPanel;
    Timer: TTimer;
    gbWeightType: TGroupBox;
    rbtnWeightTypeBrutto: TRadioButton;
    rbtnWeightTypeTare: TRadioButton;
    TimerSave: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerCOMConnect(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbtnWeightTypeBruttoClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure TimerSaveTimer(Sender: TObject);
  private
    COM: TComPort;
    COMFS: TFormatSettings;
    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure DisableEnable(AEnable: Boolean);
  public
  end;

function StartWeight(var ASQLDateTime, ABrutto: String; var ATypeBrutto: Boolean): Boolean;

implementation

uses WAAdd, WAStrings, WAMain, Math;

{$R *.dfm}

procedure TfrmWeight.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

function StartWeight(var ASQLDateTime, ABrutto: String; var ATypeBrutto: Boolean): Boolean;
var
  S: String;
begin
  WriteToLogForm(True, rsLOGFormWeight);
  with TfrmWeight.Create(Application) do
    try
      Result := ShowModal = mrOk;

      if Result then S := rsLOGWeightOK
      else S := rsLOGWeightCancel;
      WriteToLogForm(False, rsLOGFormWeight + ' ' + S);

      ASQLDateTime := DTToSQLStr(Now);
      ABrutto := pnlGross.Caption;
      ATypeBrutto := rbtnWeightTypeBrutto.Checked;
    finally
      Free;
    end;
end;

procedure TfrmWeight.FormCreate(Sender: TObject);
begin
  {$IFDEF RANDOMDATA}
  Randomize;
  Timer.Interval := 1000;
  {$ENDIF}
  COM := TComPort.Create(Application);
  COMFS.DecimalSeparator := '.';
  with COM do
    begin
      ComPort := TComPortNumber(Settings.ComNumber);
      ComPortSpeed := br9600;
      ComPortInputBufferSize := 64;
      ComPortOutputBufferSize := 64;
    end;
  with CreateINIFile do
    try
     ReadFormPosition(Self);
    finally
      Free;
    end;
  rbtnWeightTypeBruttoClick(Self);
end;

procedure TfrmWeight.FormDestroy(Sender: TObject);
begin
  COM.Free;
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmWeight.FormShow(Sender: TObject);
begin
  ShowWaitCursor;
  DisableEnable(False);
  Timer.Enabled := True;
end;

procedure TfrmWeight.DisableEnable(AEnable: Boolean);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if not (Components[i] is TTimer) then
      TControl(Components[i]).Enabled := AEnable;
end;

procedure TfrmWeight.TimerCOMConnect(Sender: TObject);
begin
  try
    Timer.Enabled := False;
    {$IFNDEF RANDOMDATA}
    if not COM.Connect then
      begin
        MsgBoxErr(Format(rsErrorOpenPort, [Settings.ComNumber + 1]), Handle);
        Close;
      end;
    {$ENDIF}
    Timer.OnTimer := TimerTimer;
  finally
    DisableEnable(True);
    btnSave.Enabled := False;
    RestoreCursor;
  end;
  Timer.Enabled := True;
end;

procedure TfrmWeight.TimerTimer(Sender: TObject);
var
  {$IFNDEF RANDOMDATA}
  S: String;
  {$ENDIF}
  F: Extended;
begin
  {$IFDEF RANDOMDATA}
  if rbtnWeightTypeBrutto.Checked then
    F := (50000 + Random(50000)) / 1000
  else
    F := Random(49900) / 1000;
  {$ELSE}
  COM.ReadString(S);
  {$ENDIF}
  try
    {$IFDEF RANDOMDATA}
    btnSave.Enabled := True;
    {$ELSE}
    F := StrToFloat(Copy(S, Length(S) - 8, 7), COMFS);
    if Abs(F - StrToFloat(pnlGross.Caption)) <= 0.02 then
      begin
        if not btnSave.Enabled then
          TimerSave.Enabled := True;
      end
    else
      begin
        btnSave.Enabled := False;
        TimerSave.Enabled := False;
      end;
    {$ENDIF}
    pnlGross.Caption := FmtFloat(F);
  except
  end;
end;

procedure TfrmWeight.TimerSaveTimer(Sender: TObject);
begin
  TimerSave.Enabled := False;
  btnSave.Enabled := True;
end;

procedure TfrmWeight.rbtnWeightTypeBruttoClick(Sender: TObject);
begin
  if rbtnWeightTypeBrutto.Checked then
    begin
      rbtnWeightTypeBrutto.Font.Style := [fsBold, fsUnderline];
      rbtnWeightTypeTare.  Font.Style := [];
    end
  else
    begin
      rbtnWeightTypeBrutto.Font.Style := [];
      rbtnWeightTypeTare.  Font.Style := [fsBold, fsUnderline];
    end;
end;

procedure TfrmWeight.btnSaveClick(Sender: TObject);
  function CheckBrutto: Boolean;
  var
    S: String;
  begin
    try
      Result := StrToFloat(pnlGross.Caption) > 0;
      if not Result then S := rsErrorNumberNil;
    except
      Result := False;
      S := rsErrorNumberBad;
    end;
    if not Result then MsgBoxErr(Format(rsErrorValueBad, [rsBrutto, S, pnlGross.Caption]));
  end;
begin
  if CheckBrutto then ModalResult := mrOk;
end;

end.
