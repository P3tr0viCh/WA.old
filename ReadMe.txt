Пароль локальной базы: 123
---------------------------------------------------------------------
*** Имена полей в БД ***

** Брутто (autob) Локальная = Сетевая **
bdatetime 		Дата/время	INDEX
scales			I[2]		INDEX Только в сетевой
auto_num		C[8]
brutto			F
tare	 		F
netto	 		F		Только в сетевой
cargotype		C[32]
invoice_num		C[16]
invoice_supplier	C[32]
invoice_recipient	C[32]
driver			C[32]
operator		C[32]
send			B		Только в локальной


** Тара (autot) Локальная = Сетевая **
bdatetime		Дата/время	INDEX
auto_num		C[8]		INDEX
scales			I[2]		INDEX Только в сетевой
tare			F
driver			C[32]
operator		C[32]
send			B		Только в локальной

---------------------------------------------------------------------
*** Настройки Ньютон-42 ***
SErIAL
	bAUd	9600
	Protoc	Prn1

---------------------------------------------------------------------
*** Создание сетевых баз ***

** Брутто **

CREATE TABLE autob (
bdatetime DATETIME,
scales SMALLINT,
auto_num CHAR(8),
brutto FLOAT(16,2),
tare FLOAT(16,2),
netto FLOAT(16,2),
cargotype CHAR(32),
invoice_num CHAR(16),
invoice_supplier CHAR(32),
invoice_recipient CHAR(32),
driver CHAR(32),
operator CHAR(32),
PRIMARY KEY (bdatetime),
KEY (scales));

** Тара **

CREATE TABLE autot (
auto_num CHAR(8),
scales SMALLINT,
tare FLOAT(16,2),
bdatetime DATETIME,
driver CHAR(32),
operator CHAR(32),
PRIMARY KEY (number),
KEY (scales));

