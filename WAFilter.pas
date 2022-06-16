unit WAFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Utils_Date, Utils_Misc, Utils_Files, Utils_Str, Utils_FileIni, StdCtrls,
  ExtCtrls, ComCtrls, Menus, WAAdd, Utils_Log;

type
  TfrmFilter = class(TForm)
    btnOK: TButton;
    btnHide: TButton;
    btnClear: TButton;
    gbDate: TGroupBox;
    pckDateFrom: TDateTimePicker;
    rbtnDateAll: TRadioButton;
    rbtnDateFromTo: TRadioButton;
    pckDateTo: TDateTimePicker;
    lblDateFrom: TLabel;
    lblDateTo: TLabel;
    pmDate: TPopupMenu;
    miDateCurrent: TMenuItem;
    miDateYesterday: TMenuItem;
    miDateLastDay: TMenuItem;
    miDateFirstDay: TMenuItem;
    miSeparator01: TMenuItem;
    gbAutoNum: TGroupBox;
    eAutoNum: TEdit;
    bvlBottom: TBevel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure rbtnDateAllClick(Sender: TObject);
    procedure miDateYesterdayClick(Sender: TObject);
  private
    Filter: TFilter;
    procedure ClearFormFilter;
  public
    procedure CheckFormFilter;
  end;

function ShowFilter(var AFilter: TFilter): Boolean;

implementation

uses WAStrings, DateUtils;

{$R *.dfm}

function ShowFilter(var AFilter: TFilter): Boolean;
begin
  with TfrmFilter.Create(Application) do
    try
      Filter := AFilter;
      CheckFormFilter;
      Result := ShowModal = mrOk;
      AFilter := Filter;
    finally
      Free;
    end;
end;

procedure TfrmFilter.FormCreate(Sender: TObject);
begin
  WriteToLogForm(True, rsLOGFormFilter);
  with CreateINIFile do
    try
      ReadFormPosition(Self);
    finally
      Free;
    end;
end;

procedure TfrmFilter.FormDestroy(Sender: TObject);
begin
  with CreateINIFile do
    try
      WriteFormPosition(Self);
    finally
      Free;
    end;
  WriteToLogForm(False, rsLOGFormFilter);
end;

procedure TfrmFilter.btnHideClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFilter.btnClearClick(Sender: TObject);
begin
  ClearFormFilter;
end;

procedure TfrmFilter.ClearFormFilter;
begin
  WriteToLog(rsLOGFilterClear);
  ClearFilter(Filter);
  CheckFormFilter;
end;

procedure TfrmFilter.btnOKClick(Sender: TObject);
begin
  if rbtnDateFromTo.Checked and (pckDateFrom.DateTime > pckDateTo.DateTime) then
    pckDateTo.DateTime := pckDateFrom.DateTime;
  ClearFilter(Filter);
  with Filter do
    begin
      if rbtnDateFromTo.Checked then Dates := dtSelected else Dates := dtAll;
      case Dates of
      dtSelected: begin
        DateFrom := pckDateFrom.DateTime;
        DateTo := pckDateTo.DateTime;
      end;
      else
        begin
          DateFrom := 0;
          DateTo := 0;
        end;
      end;
      AutoNum := eAutoNum.Text;
      Apply := (Dates <> dtAll) or (AutoNum <> '');
    end;
  WriteToLog(rsLOGFilterApply);
  ModalResult := mrOk;
end;

procedure TfrmFilter.CheckFormFilter;
begin
  with Filter do
    begin
      if Dates = dtSelected then
        begin
          pckDateFrom.DateTime := DateFrom;
          pckDateTo.DateTime := DateTo;
        end
      else
        begin
          pckDateFrom.DateTime := Date - 1;
          pckDateTo.DateTime := Date;
        end;
      case Dates of
      dtSelected: rbtnDateFromTo.Checked := True;
      else        rbtnDateAll.Checked := True;
      end;
      eAutoNum.Text := AutoNum;
    end;
end;

procedure TfrmFilter.rbtnDateAllClick(Sender: TObject);
begin
  pckDateFrom.Enabled := rbtnDateFromTo.Checked;
  pckDateTo.Enabled := pckDateFrom.Enabled;
end;

procedure TfrmFilter.miDateYesterdayClick(Sender: TObject);
begin
  with TDateTimePicker(pmDate.PopupComponent) do
    case TMenuItem(Sender).Tag of
    1: DateTime := StartOfTheMonth(Now);
    2: DateTime := EndOfTheMonth(Now);
    3: DateTime := Yesterday;
    4: DateTime := Today;
    end;
end;

end.
