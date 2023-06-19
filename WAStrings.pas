unit WAStrings;

interface
                                                             
resourcestring
  rsCopyright = '� �.�. ������, ��������� �����, ����, 2004-2023|�� ��������� �������� ���������� ��������������� � ������';
  rsAddComp   = '� ���� ������ Access, �������� � ������ Microsoft� Office,'#13#10 +
             '  � ���������� ����������, 2003.'#13#10 +
             '� MySQL ODBC 3.51, � MySQL AB, 2005.';

  rsConnectionLocal  = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False;User ID=Admin;Jet OLEDB:Database Password="%s";';
  rsConnectionServer = 'DRIVER={MySQL ODBC 3.51 Driver};SERVER=%s;PORT=%s;DATABASE=wdb3;USER=%s;PASSWORD=%s;OPTION=3;';

  rsDateTimeFormatMDB  = '#M"/"d"/"yyyy" "hh":"mm":"ss#';
  rsDateTimeFormatSQL  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';
  rsDateTimeFormatLog  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';

  rsStateNew           = '����';
  rsStateEdit          = '��������������';
  rsStateAdd           = ' ������';
  rsTypeBrutto         = '��������';
  rsTypeTare           = '��������';
  rsListCaption        = '���� %s (%s)';
  rsBrutto             = '������';
  rsTares              = '����';
  rsInvoiceNetto       = '���� �� ���������';
  rsBaseLocal          = '���������';
  rsBaseServer         = '�������';

  //   rsNo      = '���';

  rsSendYes   = '+';
  rsSendNo    = '-';

  rsAllRecords   = '��� ������';
  rsFilterApply  = '������� ������';

  rsServerOFF    = '������ ��������';

  rsFilterBrutto = 'Filter Brutto';
  rsFilterTare   = 'Filter Tare';

  rsShowFilterAllDate  = '�����';
  rsShowFilterAllAuto  = '�����';
  rsShowFilterDate     = '� %s �� %s';

  rsRecords         = '������';
  rsRecordCount     = '����� �������: %d';
  rsRecordCountSel  = '�������� �������: %d';

  rsProgressInLAN         = ' (������)';
  rsProgressDataRead      = ' (������)';
  rsProgressConnection    = '���������� � �����';
  rsProgressScaleInfoSave = '���������� ������ � �����';
  rsProgressBruttoSave    = '���������� ������';
  rsProgressBruttoLoad    = '������ ������';
  rsProgressTareSave      = '���������� ����';
  rsProgressTareLoad      = '������ ����';
  rsProgressDriverLoad    = '������ ��������';
  rsProgressDelAuto       = '�������� ��������';

  rsQuestionDelete        = '������� ���������� %s?'#13#10 +
                         '������ ������� �������� ����������';
  rsQuestionCloseProgram  = '������� ���������?';

  rsError              = '������';
  rsErrorNumber        = '�� ������ ����� ����������';
  rsErrorString        = '���������� ������ ������';
  rsErrorValueBad      = '�������� %s %s (%s)';
  rsErrorGrossTare     = '�������� ���� ������ �������� ������';
  rsErrorNumberNil     = '������ ���� ����� ����';
  rsErrorNumberBad     = '�� �������� ������';
  rsErrorTareNotFound  = '���� ���������� � ������� "%s" � ���� �� �������';
  rsErrorDriverNotFound= '�������� ���������� � ������� "%s" � ���� �� ������';

  rsErrorLocalNotExists   = '��������� ���� ������ �� ���������� ��� ���������� � ������ ������';
  rsErrorAvitekNotExists  = '������ �������� "������" (%s) �� ���������� ��� ���������� � ������ ������';
  rsErrorServerNotExists  = '��������� ������ �� ����� �������� ������� ���� ������:'#13#10 +
                         '"%s".'#13#10#13#10 +
                         '��� ��������� ��������� ����� ��������� � ��������� ���� ������ � ������ ���������� ������� �������������';
  rsErrorSettingsNotExists= '���� ������ � ����������� �� ����������';
  rsErrorLocalOpen        = '��������� ������ �� ����� �������� ��������� ���� ������:'#13#10 +
                         '"%s"';
  rsErrorSettingsBad      = '���� ������ � ����������� ����������';
  rsErrorCloseApp         = '.'#13#10#13#10'������ ���� ���������� ��� ������, ������� ��������� �����������';

  rsErrorOpenPort      = '��� ������� � ����� COM%d. �������� �� ����� ������ ���������';
  rsErrorNeedNumber    = '���������� ������ ������������� �����';
  rsErrorSelectUser    = '�������� ������������';
  rsErrorNeedUser      = '������� ��� ������������';
  rsErrorCheckPass     = '��������� ������ �� ���������. ��������� ���� ������ ������ � ��� ������������';
  rsErrorPassword      = '������ ������?'#13#10#13#10 +
                      '������� ������ ������.'#13#10 +
                      '��������� ������������ ������������� �������� � ��������� ����������';

  rsErrorSaveLoad      = '�� ������� %s, ��� ��� ��������� ������:'#13#10#13#10'%s';
  rsErrorSave          = '��������� %s � %s ���� ������';
  rsErrorLoad          = '��������� %s �� %s ���� ������';
  rsErrorDelete        = '������� %s �� %s ���� ������';
  rsErrorLocalDB       = '���������';
  rsErrorServerDB      = '�������';
  rsErrorSLSettings    = '���������';
  rsErrorSLAuto        = '����������';
  rsErrorSLBrutto      = '������';
  rsErrorSLTare        = '����';
  rsErrorSLDriver      = '��������';
  rsErrorSLScaleInfo   = '������ � �����';

  rsTableBrutto  = 'autob';
  rsTableTares   = 'autot';

  rsTableServerScalesInfo = 'scalesinfo';

  rsSQLServerScalesInfo   = 'scales, ctime, cdatetime, ipaddr, type, sclass, dclass, place, tag1';

  rsSQLLocalBrutto        = 'bdatetime, wtime, auto_num, brutto, tare, idatetime_tare, ' +
                         'cargotype, invoice_num, invoice_supplier, invoice_recipient, invoice_netto, ' +
                         'driver, operator, send';
  rsSQLServerBruttoLoad   = 'bdatetime, auto_num, brutto, tare, idatetime_tare, ' +
                         'cargotype, invoice_num, invoice_supplier, invoice_recipient, invoice_netto, ' +
                         'driver, operator, scales';
  rsSQLServerBruttoSave   = 'bdatetime, wtime, auto_num, brutto, tare, idatetime_tare, netto, ' +
                         'cargotype, invoice_num, invoice_supplier, invoice_recipient, invoice_netto, ' +
                         'driver, operator, scales';
  rsSQLLocalTares         = 'bdatetime, wtime, auto_num, tare, driver, operator, send';
  rsSQLServerTares        = 'bdatetime, wtime, auto_num, tare, driver, operator, scales';

  rsSQLTareLoad           = 'tare, bdatetime, driver';

  rsSQLLocalNotSend       = '(send=false)';

  rsSQLInsert    = 'INSERT INTO %s (%s) VALUES (%s)';
  rsSQLUpdate    = 'UPDATE %s SET %s WHERE %s';
  rsSQLDelete    = 'DELETE FROM %s';
  rsSQLSelect    = 'SELECT %s FROM %s';
  rsSQLWhere     = ' WHERE ';
  rsSQLOrder     = ' ORDER BY ';
  rsSQLOrderDesc = ' DESC';
  rsSQLLimitOne  = ' LIMIT 1';

  rsNameEqualValue = '%s=%s';

  rsDateTimeIndex   = 'bdatetime';
  rsScalesIndex     = 'scales';
  rsAuto_NumIndex   = 'auto_num';

  rsFilterAnd       = ' AND ';

  rsFilterDate1    = '(bdatetime>=%s)';
  rsFilterDate2    = '((bdatetime>=%s) AND (bdatetime<=%s))';
  rsFilterAutoNum  = '(auto_num LIKE ''%s'')';

  rsLOGBruttoLoad      = 'load brutto';
  rsLOGBruttoDelete    = 'delete brutto auto $s with bdatetime $s';
  rsLOGTareLoad        = 'load tare';
  rsLOGTareDelete      = 'delete tare auto %s with bdatetime %s';
  rsLOGTareDriverFind  = 'find tare/driver';
  rsLOGScaleInfoSave   = 'save scale info';
  rsLOGFormOptions     = 'options';
  rsLOGSettingsSave    = 'save settings';
  rsLOGFormFilter      = 'filter';
  rsLOGFilterClear     = 'filter clear';
  rsLOGFilterApply     = 'filter apply';
  rsLOGFormBrutto      = 'brutto';
  rsLOGFormTare        = 'tare';
  rsLOGFormWeight      = 'weight';
  rsLOGWeightOK        = '(OK)';
  rsLOGWeightCancel    = '(cancel)';
  rsLOGFormAuto        = 'auto';
  rsLOGFormAutoNew     = 'new';
  rsLOGFormAutoEdit    = 'edit';

  rsLOGAvitekRunModule       = 'start avitek module';
  rsLOGAvitekNewData         = 'avitek new data';
  rsLOGAvitekOpenSession     = 'avitek open session';
  rsLOGAvitekCloseSession    = 'avitek close session';
  rsLOGAvitekCloseServer     = 'avitek close server';

implementation

end.

