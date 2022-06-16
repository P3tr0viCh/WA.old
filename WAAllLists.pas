unit WAAllLists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Utils_FileIni, Dialogs, ComCtrls, StdCtrls, ExtCtrls, DateUtils, Utils_Str,
  Utils_Misc, Utils_Files, Utils_Date, Utils_Graf, Utils_Log,
  WAAdd, ToolWin, DB, ADODB;

type
  TfrmAllLists = class(TForm)
    DataList: TListView;
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    tbtnClose: TToolButton;
    tbtnEdit: TToolButton;
    tbtnDelete: TToolButton;
    tbtnSeparatorEnd: TToolButton;
    tbtnSeparator01: TToolButton;
    tbtnFilter: TToolButton;
    PanelBottom: TPanel;
    SelTimer: TTimer;
    gbFilter: TGroupBox;
    eFilterDate: TLabeledEdit;
    gbAll: TGroupBox;
    eAllGross: TLabeledEdit;
    eAllTare: TLabeledEdit;
    eAllNetto: TLabeledEdit;
    eFilterAutoNum: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DataListDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DataListKeyPress(Sender: TObject; var Key: Char);
    procedure DataListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure tbtnEditClick(Sender: TObject);
    procedure tbtnDeleteClick(Sender: TObject);
    procedure tbtnCloseClick(Sender: TObject);
    procedure tbtnFilterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SelTimerTimer(Sender: TObject);
    procedure DataListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure DataListCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure DataListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
  private
    SelfChange, BaseServer: Boolean;
    ListTable: TListTable;
    RecordsFilter: TFilter;
    AError:    String;

    procedure WMGetSysCommand(var Message: TMessage); message WM_SYSCOMMAND;

    function  GetDataItem(AIndex: Integer): TListItem;
    function  GetDataItemSend(AIndex: Integer): Boolean;

    function  SetDataItemBrutto(AIndex: Integer; ADateTime, ANumber, AGross, ATare, ACargo,
                                                 AInvoice_Number, AInvoice_Supplier, AInvoice_Recipient, AInvoice_Netto,
                                                 ADriver, AOperator: String; ASend: TSend; AScales: String): TListItem;
    function  SetDataItemTare  (AIndex: Integer; ADateTime, ANumber, ATare, 
                                                 ADriver, AOperator: String; ASend: TSend; AScales: String): TListItem;

    function  LoadData(ASQLDateTime: String): Boolean;
    procedure UpdateColors;
    procedure SortData;

    procedure UpdateTotal;
    procedure UpdateCount;
    procedure UpdateSelCount;
    procedure UpdateFilter;
    function  CalcTotal(What: Byte): String;

    procedure CreateColumns;
    procedure ChangeView;
    procedure UpdateCaption;
  public
    constructor Create(AListTable: TListTable); reintroduce;
  end;

procedure ShowListForm(AListTable: TListTable);

implementation

uses WAMain, WAStrings, WALogin, WAProgress, WAFilter, WAAutoEdit;

{$R *.dfm}

const
  SI_NUMBER          = -1;

  // ltBrutto
  SI_BRUTTO_DATETIME = 0;
  SI_BRUTTO_NUMBER   = SI_BRUTTO_DATETIME + 1;
  SI_BRUTTO_GROSS    = SI_BRUTTO_NUMBER + 1;
  SI_BRUTTO_TARE     = SI_BRUTTO_GROSS + 1;
  SI_BRUTTO_NETTO    = SI_BRUTTO_TARE + 1;
  SI_BRUTTO_CARGO    = SI_BRUTTO_NETTO + 1;
  SI_BRUTTO_IN_NUM   = SI_BRUTTO_CARGO + 1;
  SI_BRUTTO_IN_SUPPL = SI_BRUTTO_IN_NUM + 1;
  SI_BRUTTO_IN_RECIP = SI_BRUTTO_IN_SUPPL + 1;
  SI_BRUTTO_IN_NETTO = SI_BRUTTO_IN_RECIP + 1;
  SI_BRUTTO_DRIVER   = SI_BRUTTO_IN_NETTO + 1;
  SI_BRUTTO_OPERATOR = SI_BRUTTO_DRIVER + 1;
  SI_BRUTTO_SEND     = SI_BRUTTO_OPERATOR + 1;
  SI_BRUTTO_SCALES   = SI_BRUTTO_SEND + 1;
  SI_BRUTTO_MAXINDEX = SI_BRUTTO_SCALES + 1;

  // ltTares
  SI_TARE_NUMBER     = 0;
  SI_TARE_TARE       = 1;
  SI_TARE_DATETIME   = 2;
  SI_TARE_DRIVER     = 3;
  SI_TARE_OPERATOR   = 4;
  SI_TARE_SEND       = 5;
  SI_TARE_SCALES     = 6;
  SI_TARE_MAXINDEX   = 7;


var
  SI_AUTO_NUM, SI_BDATETIME, SI_SEND, SI_SCALES: Integer;

procedure ShowListForm(AListTable: TListTable);
begin
  with TfrmAllLists.Create(AListTable) do
    try
      if LoadData('') then ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmAllLists.WMGetSysCommand(var Message: TMessage);
begin
  if (Message.wParam = SC_MINIMIZE) then Application.Minimize else inherited;
end;

constructor TfrmAllLists.Create(AListTable: TListTable);
begin
  ListTable := AListTable;
  inherited Create(Application);
end;

procedure TfrmAllLists.ChangeView;
begin
  case ListTable of
  ltBrutto:   begin
    SI_AUTO_NUM := SI_BRUTTO_NUMBER;
    SI_BDATETIME := SI_BRUTTO_MAXINDEX;
    SI_SEND := SI_BRUTTO_SEND;
    SI_SCALES := SI_BRUTTO_SCALES;
    AError := rsErrorSLBrutto;
    RecordsFilter := BruttoFilter;
  end;
  ltTares:    begin
    SI_AUTO_NUM := SI_TARE_NUMBER;
    SI_BDATETIME := SI_TARE_MAXINDEX;
    SI_SEND := SI_TARE_SEND;
    SI_SCALES := SI_TARE_SCALES;
    AError := rsErrorSLTare;
    RecordsFilter := TareFilter;
  end;
  end;
  gbAll.Visible := ListTable = ltBrutto;
  tbtnEdit.Visible := Settings.CanEdit or IsAdministrator;
  tbtnDelete.Visible := Settings.CanDelete or IsAdministrator;
  tbtnSeparator01.Visible := (tbtnEdit.Visible or tbtnDelete.Visible) and PanelBottom.Visible;
  tbtnFilter.Visible := PanelBottom.Visible;
  tbtnSeparatorEnd.Visible := tbtnEdit.Visible or tbtnDelete.Visible or tbtnFilter.Visible;
end;

procedure TfrmAllLists.UpdateCaption;
var
  ABaseServer: String;
begin
  case ListTable of
  ltBrutto:   Caption := rsBrutto;
  ltTares:    Caption := rsTares;
  end;
  if BaseServer then ABaseServer := rsBaseServer else ABaseServer := rsBaseLocal;
  Caption := Format(rsListCaption, [Caption, ABaseServer]);
end;

procedure TfrmAllLists.CreateColumns;
const
  ColumnsMax:       array[TListTable, Boolean] of Integer = ((SI_BRUTTO_MAXINDEX - 2, SI_BRUTTO_MAXINDEX),
                                                            (SI_TARE_MAXINDEX   - 2, SI_TARE_MAXINDEX));
  ColumnsCaption:   array[TListTable, 0..SI_BRUTTO_MAXINDEX] of String = (
                                                      ('Дата и время', '№ авто',      'Брутто',
                                                       'Тара',         'Нетто',       'Род груза',
                                                       '№ накладной',  'Отправитель', 'Получатель', 'Вес по накладной',
                                                       'Водитель',    'Оператор',
                                                       'Сеть', 'SCALES', 'BDATETIME'),
                                                      ('№ авто',       'Тара',        'Дата и время',
                                                       'Водитель',     'Оператор',    'Сеть',
                                                       'SCALES', 'BDATETIME', '', '', '', '', '', '', ''));
  ColumnsAlignment: array[TListTable, 0..SI_BRUTTO_MAXINDEX] of TAlignment = (
                                                          (taLeftJustify,  taLeftJustify,  taRightJustify,
                                                           taRightJustify, taRightJustify, taLeftJustify,
                                                           taLeftJustify,  taLeftJustify,  taLeftJustify, taRightJustify,
                                                           taLeftJustify,  taLeftJustify,  taCenter,
                                                           taCenter,       taCenter),
                                                          (taLeftJustify,  taRightJustify, taLeftJustify,
                                                           taLeftJustify,  taLeftJustify,  taCenter,
                                                           taLeftJustify,  taLeftJustify,       taCenter,       taCenter,
                                                           taCenter,       taCenter,       taCenter,
                                                           taCenter,       taCenter));
var
  i: Integer;
begin
  for i := 0 to ColumnsMax[ListTable, IsAdministrator] do
    with DataList.Columns.Add do
      begin
        Caption := ColumnsCaption[ListTable, i];
        Alignment := ColumnsAlignment[ListTable, i];
        Width := 80;
      end;
end;

procedure TfrmAllLists.FormCreate(Sender: TObject);
var
  i: Integer;
  S1, S2: String;
begin
  case ListTable of
  ltBrutto:   WriteToLogForm(True, rsLOGFormBrutto);
  ltTares:    WriteToLogForm(True, rsLOGFormTare);
  end;

  ChangeView;
  CreateColumns;
  with CreateINIFile do
    try
      ReadFormBounds(Self);
      case ListTable of
      ltBrutto:   S1 := ReadString(Name, 'Columns Brutto', '');
      ltTares:    S1 := ReadString(Name, 'Columns Tares', '');
      else        S1 := '';
      end;
      if S1 <> '' then
        try
          for i := 0 to DataList.Columns.Count - 1 do
            begin
              SplitStr(S1, COMMA, 0, S2, S1);
              DataList.Columns[i].Width := SToI(S2);
            end;
        except
        end;
    finally
      Free;
    end;
  DataListChange(Self, nil, ctState);
end;

procedure TfrmAllLists.FormDestroy(Sender: TObject);
var
  i: Integer;
  Ident, S1: String;
begin
  case ListTable of
  ltBrutto:   begin
    BruttoFilter := RecordsFilter;
  end;
  ltTares:    begin
    TareFilter := RecordsFilter;
  end;
  end;
  with CreateINIFile do
    try
      WriteFormBounds(Self);
      S1 := '';
      if DataList.Columns.Count > 2 then
        for i := 0 to DataList.Columns.Count - 1 do
          S1 := ConcatStrings(S1, IToS(DataList.Columns[i].Width), COMMA);
      case ListTable of
      ltBrutto:   Ident := 'Columns Brutto';
      ltTares:    Ident := 'Columns Tares';
      else        Ident := '';
      end;
      WriteString(Name, Ident, S1);
    finally
      Free;
    end;
  case ListTable of
  ltBrutto:   WriteToLogForm(True, rsLOGFormBrutto);
  ltTares:    WriteToLogForm(True, rsLOGFormTare);
  end;
end;

procedure TfrmAllLists.UpdateColors;
var
  i: Integer;
  CurrentColor: TColor;
begin
  CurrentColor := clWindow;
  for i := 0 to DataList.Items.Count - 1 do
    with DataList.Items[i] do
      begin
        if CurrentColor = clMoneyGreen then CurrentColor := clWindow
        else CurrentColor := clMoneyGreen;
        ImageIndex := CurrentColor;
      end;
  Repaint;
end;

procedure TfrmAllLists.FormShow(Sender: TObject);
begin
  if IsWinXPOrGreat then Exit;
  if WindowState = wsMaximized then
    begin
      with Screen.WorkAreaRect do
        SetBounds(Left, Top, Right, Bottom);
      WindowState := wsNormal;
      WindowState := wsMaximized;
    end;
end;

function TfrmAllLists.GetDataItem(AIndex: Integer): TListItem;
var
  ColumnCount: Integer;
begin
  ColumnCount := DataList.Columns.Count;
  if not IsAdministrator then Inc(ColumnCount, 2);
  if AIndex < 0 then
    begin
      Result := DataList.Items.Add;
      AddSubItemsToListItem(Result, ColumnCount);
    end
  else
    Result := DataList.Items[AIndex];
end;

function TfrmAllLists.SetDataItemBrutto(AIndex: Integer; ADateTime, ANumber, AGross, ATare, ACargo,
                                                AInvoice_Number, AInvoice_Supplier, AInvoice_Recipient, AInvoice_Netto,
                                                ADriver, AOperator: String; ASend: TSend; AScales: String): TListItem;
begin
  Result := GetDataItem(AIndex);
  with Result do
    begin
      Caption := IToS(Index + 1);
      if ATare               = '' then ATare := '0';

      if ADateTime          <> #0 then SubItems[SI_BRUTTO_DATETIME] := ADateTime;
      if ANumber            <> #0 then SubItems[SI_BRUTTO_NUMBER] := ANumber;
      if AGross             <> #0 then SubItems[SI_BRUTTO_GROSS] := AGross;
      if ATare              <> #0 then SubItems[SI_BRUTTO_TARE] := ATare;
      if ACargo             <> #0 then SubItems[SI_BRUTTO_CARGO] := ACargo;
      if AInvoice_Number    <> #0 then SubItems[SI_BRUTTO_IN_NUM] := AInvoice_Number;
      if AInvoice_Supplier  <> #0 then SubItems[SI_BRUTTO_IN_SUPPL] := AInvoice_Supplier;
      if AInvoice_Recipient <> #0 then SubItems[SI_BRUTTO_IN_RECIP] := AInvoice_Recipient;
      if AInvoice_Netto     <> #0 then SubItems[SI_BRUTTO_IN_NETTO] := AInvoice_Netto;
      if ADriver            <> #0 then SubItems[SI_BRUTTO_DRIVER] := ADriver;
      if AOperator          <> #0 then SubItems[SI_BRUTTO_OPERATOR] := AOperator;
      if (AGross <> #0) or (ATare <> #0)then
        SubItems[SI_BRUTTO_NETTO] := CalcDiff(SubItems[SI_BRUTTO_GROSS], SubItems[SI_BRUTTO_TARE]);
      case ASend of
      sdNo:    SubItems[SI_BRUTTO_SEND] := rsSendNo;
      sdYes:   SubItems[SI_BRUTTO_SEND] := rsSendYes;
      end;
      if AScales            <> #0 then SubItems[SI_BRUTTO_SCALES] := AScales;
    end;
end;

function TfrmAllLists.SetDataItemTare(AIndex: Integer; ADateTime, ANumber, ATare,
  ADriver, AOperator: String; ASend: TSend; AScales: String): TListItem;
begin
  Result := GetDataItem(AIndex);
  with Result do
    begin
      Caption := IToS(Index + 1);
      if ATare               = '' then ATare := '0';

      if ADateTime          <> #0 then SubItems[SI_TARE_DATETIME] := ADateTime;
      if ANumber            <> #0 then SubItems[SI_TARE_NUMBER] := ANumber;
      if ATare              <> #0 then SubItems[SI_TARE_TARE] := ATare;
      if ADriver            <> #0 then SubItems[SI_TARE_DRIVER] := ADriver;
      if AOperator          <> #0 then SubItems[SI_TARE_OPERATOR] := AOperator;
      case ASend of
      sdNo:    SubItems[SI_TARE_SEND] := rsSendNo;
      sdYes:   SubItems[SI_TARE_SEND] := rsSendYes;
      end;
      if AScales            <> #0 then SubItems[SI_TARE_SCALES] := AScales;
    end;
end;

function TfrmAllLists.GetDataItemSend(AIndex: Integer): Boolean;
begin
  Result := DataList.Items[AIndex].SubItems[SI_SEND] = rsSendYes;
end;

procedure TfrmAllLists.DataListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  try
    Compare := CompareBool(GetDataItemSend(Item1.Index), GetDataItemSend(Item2.Index));
    if Compare = 0 then
      case ListTable of
      ltBrutto:
        Compare := CompareDateTime(StrToDateTime(Item2.SubItems[SI_BRUTTO_DATETIME]),
          StrToDateTime(Item1.SubItems[SI_BRUTTO_DATETIME]));
      ltTares: begin
        Compare := AnsiCompareText(Item1.SubItems[SI_TARE_NUMBER],
          Item2.SubItems[SI_TARE_NUMBER]);
        if Compare = 0 then
          Compare := CompareDateTime(StrToDateTime(Item2.SubItems[SI_TARE_DATETIME]),
            StrToDateTime(Item1.SubItems[SI_TARE_DATETIME]));
      end;
      end;
  except
    Compare := 0;
  end;
end;

procedure TfrmAllLists.SortData;
begin
  DataList.Items.BeginUpdate;
  try
    DataList.AlphaSort;
    RethinkNumbers(DataList);
    UpdateColors;
  finally
    DataList.Items.EndUpdate;
  end;
end;

procedure TfrmAllLists.DataListDblClick(Sender: TObject);
begin
  if tbtnEdit.Visible and tbtnEdit.Enabled then tbtnEdit.Click;
end;

procedure TfrmAllLists.tbtnEditClick(Sender: TObject);
begin
  DataList.Selected := nil;
  DataList.ItemFocused.Selected := True;
  if ShowAutoEdit(DataList.ItemFocused.SubItems[SI_BDATETIME], ListTable = ltBrutto) then
    LoadData(DataList.ItemFocused.SubItems[SI_BDATETIME]);
  UpdateSelCount;
end;

procedure TfrmAllLists.tbtnDeleteClick(Sender: TObject);
  function PerformDeleteAuto(AConnectionServer: Boolean; AIndex: Integer): Boolean;
  var
    ATableName, AWhere, S: String;
  begin
    Result := True;
    with DataList.Items[AIndex] do
      if ListTable = ltBrutto then
        begin
          S := rsLOGBruttoDelete;
          ATableName := rsTableBrutto;
          if AConnectionServer then
            AWhere := SQLNameEqualValue(rsDateTimeIndex, SubItems[SI_BDATETIME]) +
              rsFilterAnd + SQLNameEqualValue(rsScalesIndex, Settings.Scales)
          else
            AWhere := SQLNameEqualValue(rsDateTimeIndex,
              SQLStrToDT(SubItems[SI_BDATETIME]));
        end
      else
        begin
          S := rsLOGTareDelete;
          ATableName := rsTableTares;
          if AConnectionServer then
            AWhere := SQLNameEqualValue(rsDateTimeIndex, SubItems[SI_BDATETIME]) +
              rsFilterAnd + SQLNameEqualValue(rsScalesIndex, Settings.Scales)
          else
            AWhere := SQLNameEqualValue(rsDateTimeIndex,
              SQLStrToDT(SubItems[SI_BDATETIME]));
        end;
    SelectConnection(AConnectionServer);
    try
      with DataList.Items[AIndex] do
        SQLExec(SQLDelete(ATableName, AWhere),
          Format(S, [SubItems[SI_AUTO_NUM], SubItems[SI_BDATETIME]]),
            AConnectionServer);
//      MsgBox(SQLDelete(ATableName, AWhere));
    except
      on E: Exception do
        begin
          Result := False;
          ErrorSaveLoad(acDelete, rsErrorSLAuto, E.Message);
        end;
    end;
  end;
var
  i: Integer;
  Result: Boolean;
begin
  if not MsgBoxYesNo(Format(rsQuestionDelete, [rsErrorSLAuto])) then Exit;
  frmProgress.Show;
  DataList.Items.BeginUpdate;
  try
    if not OpenConnections then Exit;
    frmProgress.ProgressCaption := rsProgressDelAuto;
    frmProgress.MaxProgress(DataList.SelCount, False);
    for i := DataList.Items.Count - 1 downto 0 do
      begin
        with DataList.Items[i] do
          if Selected then
            begin
              if GetDataItemSend(i) then Result := PerformDeleteAuto(ctServer, i)
              else Result := True;
              if Result then
                Result := PerformDeleteAuto(ctLocal,  i);
              if Result then Delete else Break;
              if frmProgress.StepProgress then Break;
            end;
      end;
  finally
    SortData;
    DataListChange(Self, nil, ctState);
    UpdateCount;
    DataList.Items.EndUpdate;
    UpdateTotal;
    frmProgress.Hide;
  end;
end;

procedure TfrmAllLists.tbtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAllLists.tbtnFilterClick(Sender: TObject);
begin
  if ShowFilter(RecordsFilter) then LoadData('');
end;

procedure TfrmAllLists.UpdateTotal;
begin
  if SelfChange then Exit;
  case ListTable of
  ltBrutto: begin
    eAllGross.Text := CalcTotal(SI_BRUTTO_GROSS);
    eAllTare.Text :=  CalcTotal(SI_BRUTTO_TARE);
    eAllNetto.Text := CalcTotal(SI_BRUTTO_NETTO);
  end;
  end;
end;

procedure TfrmAllLists.DataListKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then DataListDblClick(Self);
end;

procedure TfrmAllLists.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
    VK_F5:      LoadData('');
    VK_ESCAPE:  tbtnClose.Click;
    end;
end;

procedure TfrmAllLists.DataListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CheckDataListKeyDown(DataList, Key, Shift);
end;

procedure TfrmAllLists.SelTimerTimer(Sender: TObject);
begin
  SelTimer.Enabled := False;
  UpdateTotal;
end;

procedure TfrmAllLists.UpdateSelCount;
begin
  StatusBar.Panels[0].Text := Format(rsRecordCountSel, [DataList.SelCount]);
end;

procedure TfrmAllLists.UpdateCount;
begin
  StatusBar.Panels[1].Text := Format(rsRecordCount, [DataList.Items.Count]);
end;

function TfrmAllLists.CalcTotal(What: Byte): String;
begin
  Result := WAAdd.CalcTotal(DataList, What, True);
end;

procedure TfrmAllLists.DataListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if SelfChange then Exit;
  if Change <> ctState then Exit;
  tbtnEdit.Enabled := DataList.ItemFocused <> nil;
  tbtnDelete.Enabled := DataList.SelCount <> 0;
  UpdateSelCount;
  RestartTimer(SelTimer);
end;

procedure TfrmAllLists.DataListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  DataList.Canvas.Brush.Color := Item.ImageIndex;
end;

var
  C: Boolean;

procedure TfrmAllLists.DataListCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;
  Dec(SubItem);
  case ListTable of
  ltBrutto:   C := SubItem = SI_BRUTTO_NETTO;
  ltTares:    C := SubItem = SI_TARE_TARE;
  else        C := False;
  end;
  DataList.Canvas.Brush.Color := Item.ImageIndex;
  if C then
    DataList.Canvas.Font.Style := [fsBold]
  else
    DataList.Canvas.Font.Style := [];
  if not Settings.MySQLUse then Exit;
  if GetDataItemSend(Item.Index) then
    DataList.Canvas.Font.Color := clBlack
  else
    DataList.Canvas.Font.Color := clRed;
end;

procedure TfrmAllLists.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAllLists.FormHide(Sender: TObject);
begin
  DataList.Clear;
end;

procedure TfrmAllLists.UpdateFilter;
begin
  with RecordsFilter do
    begin
      if Apply then
        begin
          if Dates = dtAll then
           eFilterDate.Text := rsShowFilterAllDate
          else
            begin
              if SameDate(DateFrom, DateTo) then
                eFilterDate.Text := DateToStr(DateFrom)
              else
                eFilterDate.Text := Format(rsShowFilterDate, [DateToStr(DateFrom), DateToStr(DateTo)]);
            end;
          if AutoNum <> '' then
            eFilterAutoNum.Text := AutoNum
          else
            eFilterAutoNum.Text := rsShowFilterAllAuto;
          StatusBar.Panels[2].Text := rsFilterApply;
        end
      else
        begin
          eFilterDate.Text := rsShowFilterAllDate;
          eFilterAutoNum.Text := rsShowFilterAllAuto;
          StatusBar.Panels[2].Text := rsAllRecords;
        end;
  end;
end;

function TfrmAllLists.LoadData(ASQLDateTime: String): Boolean;
  function PerformLoadData(AConnectionServer: Boolean; ALoadFromLocalOnlyNotSend: Boolean): Boolean;
  var
    ATableName, AFields, AWhere, AOrderBy, AScales, S: String;
    ASend: TSend;
  begin
    Result := True;
    SelectConnection(AConnectionServer);
    with Main.Query do
      try // except
        case ListTable of
        ltBrutto: begin S := rsLOGBruttoLoad; ATableName := rsTableBrutto; end;
        ltTares:  begin S := rsLOGTareLoad;   ATableName := rsTableTares;  end;
        end;
        if AConnectionServer then
          begin
            case ListTable of
            ltBrutto: AFields := rsSQLServerBruttoLoad;
            ltTares:  AFields := rsSQLServerTares;
            end;
          end
        else
          begin
            case ListTable of
            ltBrutto: AFields := rsSQLLocalBrutto;
            ltTares:  AFields := rsSQLLocalTares;
            end;
            if ALoadFromLocalOnlyNotSend then
              AWhere := rsSQLLocalNotSend
            else
              AWhere := '';
          end;
        AScales := '';
        ASend := sdYes;

        if RecordsFilter.Apply then
          begin
            if AWhere <> '' then AWhere := AWhere + rsFilterAnd;
            AWhere := AWhere + FilterToSQL(AConnectionServer, RecordsFilter);
          end;

        SetQuerySQL(SQLSelect(ATableName, AFields, AWhere) + AOrderBy);

  //            MsgBox(SQL.Text); //Exit;

        SQLOpen(S, AConnectionServer);
        try
          frmProgress.MaxProgress(RecordCount, False);
          while not Eof do
            begin
              if AConnectionServer then
                begin
                  AScales := FieldByName('scales').AsString;
                end
              else
                begin
                  if FieldByName('send').AsBoolean then ASend := sdYes else ASend := sdNo;
                end;
              case ListTable of
              ltBrutto:
                with SetDataItemBrutto(-1,
                  DTToStr(Fields[0].AsDateTime, False),  // Дата и время взвешивания (BDATETIME)
                  Fields[2].AsString,                    // Номер авто (NUMBER)
                  FmtFloat(Fields[3].AsFloat),           // Брутто (BRUTTO)
                  FmtFloat(Fields[4].AsFloat),           // Тара (TARE)
                  Fields[6].AsString,                    // Род груза (CARGOTYPE)
                  Fields[7].AsString,                    // Номер накладной (INVOICE_NUM)
                  Fields[8].AsString,                    // Грузоотправитель (INVOICE_SUPPLIER)
                  Fields[9].AsString,                    // Грузополучатель (INVOICE_RECIPIENT)
                  Fields[10].AsString,                   // Вес по накладной (INVOICE_NETTO)
                  Fields[11].AsString,                   // Водитель (DRIVER)
                  Fields[12].AsString,                   // Оператор (OPERATOR)
                  ASend,                                 // Сохранено на сервере (SEND, всегда)
                  AScales) do                            // Номер весов (нет, SCALES)
                  begin
                    SubItems[SI_BRUTTO_MAXINDEX] := DTToSQLStr(Fields[0].AsDateTime);
                  // Дата и время взвешивания (BDATETIME) (INDEX)
                  end;
              ltTares:
                with SetDataItemTare(-1,
                  DTToStr(Fields[0].AsDateTime, False),  // Дата и время взвешивания (BDATETIME)
                  Fields[2].AsString,                    // Номер авто (NUMBER)
                  FmtFloat(Fields[3].AsFloat),           // Тара (TARE)
                  Fields[4].AsString,                    // Водитель (DRIVER)
                  Fields[5].AsString,                    // Оператор (OPERATOR)
                  ASend,                                 // Сохранено на сервере (SEND, всегда)
                  AScales) do                            // Номер весов (нет, SCALES)
                  begin
                    SubItems[SI_TARE_MAXINDEX] := DTToSQLStr(Fields[0].AsDateTime);
                  // Дата и время взвешивания (BDATETIME) (INDEX)
                  end;
              end;
              if frmProgress.StepProgress then Break;
              Next;
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

  procedure SelectBySQLDateTime(ASQLDateTime: String);
  var
    i: Integer;
  begin
    for i := 0 to DataList.Items.Count - 1 do
      if DataList.Items[i].SubItems[SI_BDATETIME] = ASQLDateTime then
        begin
          SelectListItem(DataList.Items[i], True);
          Break;
        end;
  end;
begin
  frmProgress.Show;
  try
    Result := OpenConnections;
    if not Result then Exit;

    case ListTable of
    ltBrutto:   frmProgress.ProgressCaption := rsProgressBruttoLoad;
    ltTares:    frmProgress.ProgressCaption := rsProgressTareLoad;
    end;

    DataList.Clear;

    UpdateTotal;
    SelfChange := True;

    UpdateFilter;
    UpdateSelCount;
    UpdateCount;

    DataList.Items.BeginUpdate;

    {      if CanServer and Settings.ServerRead then Result := PerformLoadData(ctServer, True) else Result := False;
    BaseServer := Result;
    if frmProgress.Canceled then Exit;
    if not Result then DataList.Clear;}

    Result := PerformLoadData(ctLocal, False);
  finally
    SortData;
    DataListChange(Self, nil, ctState);
    if ASQLDateTime <> '' then SelectBySQLDateTime(ASQLDateTime);
    UpdateCount;
    DataList.Items.EndUpdate;
    frmProgress.Hide;
    SelfChange := False;
    UpdateTotal;
    UpdateCaption;
  end;
end;

end.
