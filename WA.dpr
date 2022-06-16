program WA;

{%ToDo 'WA.todo'}

uses
  Windows,
  Forms,
  Utils_Misc,
  WAMain in 'WAMain.pas' {Main},
  WAEdits in 'WAEdits.pas' {frmValueEdit},
  WAStrings in 'WAStrings.pas',
  WALogin in 'WALogin.pas' {frmLogin},
  WAAdd in 'WAAdd.pas',
  WAOptions in 'WAOptions.pas' {frmOptions},
  WAProgress in 'WAProgress.pas' {frmProgress},
  WAFilter in 'WAFilter.pas' {frmFilter},
  WAAllLists in 'WAAllLists.pas' {frmAllLists},
  WAWeight in 'WAWeight.pas' {frmWeight},
  WAAutoEdit in 'WAAutoEdit.pas' {frmAutoEdit};

{$R *.res}
{$R WAAdd.res}

function FirstInstance: Boolean;
var
  AppHandle: THandle;
begin
  AppHandle := FindWindow(PChar('TApplication'), PChar('Весовое ПО (А)'));
  Result := AppHandle = 0;
  if not Result then SwitchToThisWindow(AppHandle, True);
end;

begin
  if FirstInstance then
    begin
      Application.Initialize;
      Application.ShowMainForm:=False;
      Application.Title := 'Весовое ПО (А)';
      Application.CreateForm(TMain, Main);
      Application.Run;
    end;
end.
