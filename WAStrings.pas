unit WAStrings;

interface
                                                             
resourcestring
  rsCopyright = '© К.П. Дураев, Уральская Сталь, ЦВТС, 2004-2022|По возникшим вопросам обращаться непосредственно к автору';
  rsAddComp   = '• База данных Access, входящая в состав Microsoft® Office,'#13#10 +
             '  © Корпорация Майкрософт, 2003.'#13#10 +
             '• MySQL ODBC 3.51, © MySQL AB, 2005.';

  rsConnectionLocal  = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False;User ID=Admin;Jet OLEDB:Database Password="%s";';
  rsConnectionServer = 'DRIVER={MySQL ODBC 3.51 Driver};SERVER=%s;PORT=%s;DATABASE=wdb3;USER=%s;PASSWORD=%s;OPTION=3;';

  rsDateTimeFormatMDB  = '#M"/"d"/"yyyy" "hh":"mm":"ss#';
  rsDateTimeFormatSQL  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';
  rsDateTimeFormatLog  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';

  rsStateNew           = 'Ввод';
  rsStateEdit          = 'Редактирование';
  rsStateAdd           = ' данных';
  rsTypeBrutto         = 'Груженый';
  rsTypeTare           = 'Порожний';
  rsListCaption        = 'База %s (%s)';
  rsBrutto             = 'брутто';
  rsTares              = 'тары';
  rsInvoiceNetto       = 'веса по накладной';
  rsBaseLocal          = 'локальная';
  rsBaseServer         = 'сетевая';

  //   rsNo      = 'Нет';

  rsSendYes   = '+';
  rsSendNo    = '-';

  rsAllRecords   = 'Все записи';
  rsFilterApply  = 'Включен фильтр';

  rsServerOFF    = 'Сервер отключен';

  rsFilterBrutto = 'Filter Brutto';
  rsFilterTare   = 'Filter Tare';

  rsShowFilterAllDate  = 'Любая';
  rsShowFilterAllAuto  = 'Любой';
  rsShowFilterDate     = 'С %s по %s';

  rsRecords         = 'записи';
  rsRecordCount     = 'Всего записей: %d';
  rsRecordCountSel  = 'Выделено записей: %d';

  rsProgressInLAN         = ' (сервер)';
  rsProgressDataRead      = ' (запрос)';
  rsProgressConnection    = 'Соединение с базой';
  rsProgressScaleInfoSave = 'Сохранение данных о весах';
  rsProgressBruttoSave    = 'Сохранение брутто';
  rsProgressBruttoLoad    = 'Чтение брутто';
  rsProgressTareSave      = 'Сохранение тары';
  rsProgressTareLoad      = 'Чтение тары';
  rsProgressDriverLoad    = 'Чтение водителя';
  rsProgressDelAuto       = 'Удаление провесок';

  rsQuestionDelete        = 'Удалить выделенные %s?'#13#10 +
                         'Отмена данного действия невозможна';
  rsQuestionCloseProgram  = 'Закрыть программу?';

  rsError              = 'Ошибка';
  rsErrorNumber        = 'Не введен номер автомобиля';
  rsErrorString        = 'Необходимо ввести строку';
  rsErrorValueBad      = 'Значение %s %s (%s)';
  rsErrorGrossTare     = 'Значение тары больше значения брутто';
  rsErrorNumberNil     = 'меньше либо равно нулю';
  rsErrorNumberBad     = 'не является числом';
  rsErrorTareNotFound  = 'Тара автомобиля с номером "%s" в базе не найдена';
  rsErrorDriverNotFound= 'Водитель автомобиля с номером "%s" в базе не найден';

  rsErrorLocalNotExists   = 'Локальная база данных не существует или недоступна в данный момент';
  rsErrorAvitekNotExists  = 'Модуль передачи "Авитек" (%s) не существует или недоступен в данный момент';
  rsErrorServerNotExists  = 'Произошла ошибка во время открытия сетевой базы данных:'#13#10 +
                         '"%s".'#13#10#13#10 +
                         'Все сделанные изменения будут храниться в локальной базе данных и станут недоступны сетевым пользователям';
  rsErrorSettingsNotExists= 'База данных с настройками не существует';
  rsErrorLocalOpen        = 'Произошла ошибка во время открытия локальной базы данных:'#13#10 +
                         '"%s"';
  rsErrorSettingsBad      = 'База данных с настройками повреждена';
  rsErrorCloseApp         = '.'#13#10#13#10'Данная база необходима для работы, поэтому программа закрывается';

  rsErrorOpenPort      = 'Нет доступа к порту COM%d. Возможно он занят другим процессом';
  rsErrorNeedNumber    = 'Необходимо ввести положительное число';
  rsErrorSelectUser    = 'Выберите пользователя';
  rsErrorNeedUser      = 'Введите имя пользователя';
  rsErrorCheckPass     = 'Введенные пароли не совпадают. Повторите ввод нового пароля и его подверждения';
  rsErrorPassword      = 'Забыли пароль?'#13#10#13#10 +
                      'Введите пароль заново.'#13#10 +
                      'Проверьте правильность используемого регистра и раскладки клавиатуры';

  rsErrorSaveLoad      = 'Не удалось %s, так как произошла ошибка:'#13#10#13#10'%s';
  rsErrorSave          = 'сохранить %s в %s базе данных';
  rsErrorLoad          = 'прочитать %s из %s базы данных';
  rsErrorDelete        = 'удалить %s из %s базы данных';
  rsErrorLocalDB       = 'локальной';
  rsErrorServerDB      = 'сетевой';
  rsErrorSLSettings    = 'настройки';
  rsErrorSLAuto        = 'автомобили';
  rsErrorSLBrutto      = 'брутто';
  rsErrorSLTare        = 'тару';
  rsErrorSLDriver      = 'водителя';
  rsErrorSLScaleInfo   = 'данные о весах';

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

