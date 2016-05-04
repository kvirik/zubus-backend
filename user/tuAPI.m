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
	do apierror
	quit
	;
	;
	; /cgi-bin/gtmapp/wapi/stations?alpha="КИ"
stations
	new alpha,json,content,conf,i
	set alpha=$g(%Key("alpha"))
	set conf(0)="id"
	set conf(1)="id:%1:N|name:1|name_ua:2|region:3|country:4|name_en:5|address:6|address_ru:7|address_en:8|city:9|name_ru:10"
	do getstations(.content,alpha)
	do FromTab^%WJSON("content",.json,.conf)
	do writejson(.json,codepage)
	quit
	;
	;__Станции по заданному фильтру по первым символам
getstations(content,alpha)
	new code,name,nameu,namer,namee,data,ldata,plen
	kill content
	set alpha=$$LA^%WT($$gconv^%WU($g(alpha),codepage,"cp866"))
	set plen=$l(alpha)
	set code=""
	for  set code=$o(^tSTGEN(code)) quit:code=""  do
	 . set data=$g(^tSTGEN(code))
	 . set ldata=$$LA^%WT(data)
	 . if data'="" do
	 . . set name=$p(ldata,$c(254),1)
	 . . set nameu=$p(ldata,$c(254),2)
	 . . set namer=$p(ldata,$c(254),10)
	 . . set namee=$p(ldata,$c(254),5)
	 . . if ($e(name,1,plen)=alpha)!($e(nameu,1,plen)=alpha)!($e(namee,1,plen)=alpha)!($e(namer,1,plen)=alpha) set content(code)=data
	quit
	;
	;
apierror
	write "{""error"":{""code"":1000,""name"":""Method not defined""}}",!
	quit

writejson(json,codepage)
	new i
	set i=""
	for  set i=$o(json(i)) quit:i=""  write $$gconv^%WU(json(i),"cp866",codepage),!
	quit
