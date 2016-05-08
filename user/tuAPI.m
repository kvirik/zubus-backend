tuAPI	;
	;Глобальные переменные:
	;  codepage - кодовая страница для генерации данных JSON
	;
	use $i:nowrap
	set %=$c(254)
	set codepage="utf8"
	set Depth=$l(%Request("URI"),"/")-$l(%Request("ScriptName"),"/")
	set DocRoot=""
	for i=1:1:Depth set DocRoot=DocRoot_"../"
	set Method=$p(%AppPath,"/",1)
	if Method="stations" do stations quit
	if Method="cities" do cities quit
	if Method="trips" do trips quit
	do apierror("E_METHOD",Method)
	quit
	;
	; Станции (не нужна)
	; /cgi-bin/gtmapp/wapi/stations?alpha="КИ"
stations
	new alpha,json,content,conf,i
	set alpha=$g(%Key("alpha"))
	set conf(0)="id"
	set conf(1)="id:%1:N|name:1|name_ua:2|region:3|country:4|name_en:5|address:6|address_ru:7|address_en:8|city:9|name_ru:10"
	do stations^tuAPIDB(.content,alpha)
	do FromTab^%WJSON("content",.json,.conf)
	do writejson(.json,codepage)
	quit
	;
	; Населенные пункты
	; /cgi-bin/gtmapp/wapi/cities?alpha="Ки"&lang="ua"
cities
	new alpha,json,content,conf,i,lang
	set alpha=$g(%Key("alpha"))
	set lang=$g(%Key("lang"))
	set conf(0)="id"
	set conf(1)="id:%1:N|name:1"
	do cities^tuAPIDB(.content,alpha,lang)
	do FromTab^%WJSON("content",.json,.conf)
	do writejson(.json,codepage)
	quit


trips
	new cFrom,cTo,when,hwhen,edges,json,content,conf,i,lang
	set cFrom=$g(%Key("from"))
	set cTo=$g(%Key("to"))
	set when=$g(%Key("when"))
	set edges=$g(%Key("edges"))
	set lang=$g(%Key("lang"))
	set hwhen=$$indate(when) if 'hwhen do apierror(hwhen,when,lang) quit
	set conf(0)="date|id"
	set conf(2)="date:%1|id:%2:N|from:1|to:2|places:3|busname:4|dist:5|price:6|bprice:7|racetime:8|period:9|block:10|platf:11|reref:12|carrier:15|insur:16|arrtime:17"
	do trips^tuAPIDB(.content,cFrom,cTo,hwhen,edges,lang)
	do FromTab^%WJSON("content",.json,.conf)
	do writejson(.json,codepage)
	quit

testtrips
	set $zstep="zprint @$zpos b  "
	set %Key("from")=4
	set %Key("to")=2
	set %Key("when")="2016-05-19"
	set codepage="utf8"
	zbreak jsfyt+19^%WJSON
	do trips
	quit
	;
	;

indate(date)
	new stat
	if $g(date)="" quit "E_DATE"
	set date=$tr(date,"-/.")
	set stat=$$CHK^%WH(.date,"101")
	if stat'="" quit "E_DATE"
	set date=$$IN^%WH($e(date,5,6)_"/"_$e(date,7,8)_"/"_$e(date,1,4))
	if date=0 quit "E_DATE"
	quit date


writejson(json,codepage)
	new i
	set i=""
	for  set i=$o(json(i)) quit:i=""  write $$gconv^%WU(json(i),"cp866",codepage),!
	quit

apierror(ecode,param,lang)
	write "{""error"":{""code"":"""_ecode_""",""name"":"""_$$apiecode(ecode,$g(lang))_""",""param"":"""_$g(param)_"""}}",!
	quit

apiecode(err,lang)
	set lang=$$LA^%WT($g(lang))
	set lang=$s(lang="en":3,lang=2:"ru",1:1)
	if err="E_CITYFROM" quit $p("Не вказане мiсце вiдправлення|Не указано место отправления|<From> field is empty","|",lang)
	if err="E_CITYTO" quit $p("Не вказане мiсце прибуття|Не указано место прибытия|<To> field is empty","|",lang)
	if err="E_WHEN" quit $p("Не вказана дата вiдправлення|Не указана дата отправления|<Date> field is empty","|",lang)
	if err="E_DATE" quit $p("Формат дати не вiрний|Не верен формат даты|Date format is wrong","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	;if err="" quit $p("","|",lang)
	quit $p("Невизначена помилка |Неопределенная ошибка |Undefined error ","|",lang)_err
