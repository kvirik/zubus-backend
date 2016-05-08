tuAPIDB	;__Запросы к базе данных для API


	;__Станции по заданному фильтру по первым символам
stations(content,alpha)
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

	;__Населенн. пункты по заданному фильтру по первым символам
cities(content,alpha,lang)
	new code,name,nameu,namer,namee,data,ldata,plen,fldn
	set lang=$$LA^%WT($g(lang))
	set fldn=$s(lang="en":3,lang=2:"ru",1:1)
	kill content
	set alpha=$$LA^%WT($$gconv^%WU($g(alpha),codepage,"cp866"))
	set plen=$l(alpha)
	set code=""
	for  set code=$o(^tCITY(code)) quit:code=""  do
	 . set data=$g(^tCITY(code))
	 . set ldata=$$LA^%WT(data)
	 . if data'="" do
	 . . set name=$p(ldata,$c(254),fldn)
	 . . if (name'="")&($e(name,1,plen)=alpha) set content(code)=data
	quit
	;
	; content(i)=
	;from:1|to:2|places:3|busname:4|dist:5|price:6|bprice:7|racetime:8|period:9|block:10|platf:11|reref:12|carrier:15|insur:16|arrtime:17
	; 
trips(content,cFrom,cTo,when,edges,lang)
	new (content,cFrom,cTo,when,lang)
	if $g(cFrom)="" quit "E_CITYFROM"
	if $g(cTo)="" quit "E_CITYTO"
	if $g(when)="" quit "E_WHEN"
	set lang=$$LA^%WT($g(lang))
	set lang=$s(lang="en":"en",lang="ru":"ru",1:"ua")
	set edges=+$g(edges)
	kill content,lfrom,lto,dates
	do IndexateStations
	merge lfrom=^tCITYST(cFrom) if $d(lfrom)<10 quit 1
	merge lto=^tCITYST(cTo) if $d(lfrom)<10 quit 1
	for date=when-edges:1:when+edges if date'<+$h set dates(date)=""
	set date="" for  set date=$o(dates(date)) quit:date=""  do
	 . set from="" for  set from=$o(lfrom(from)) quit:from=""  do
	 . . set to="" for  set to=$o(lto(to)) quit:to=""  do
	 . . . if $d(^tSTR(from,to)) do getraces(.content,from,to,date,lang)
	quit


getraces(content,from,to,date,lang)
	new RE,CRE,%
	set %=$c(254)
	set CRE=""
	for  set CRE=$o(^tSTR(from,to,CRE)) quit:CRE=""  set RE=$p(^tSTR(from,to,CRE),%,1) if RE'="" do
	 . new insurance,carrier,txt,nDate,nVR,Shift,V1,data
	 . set Shift=$p(^tSTR(from,to,CRE),%,2)
	 . set nDate=date-Shift
	 . set V1=CRE,nVR=RE
	 . set data=$$Make^trKASRE2(nDate,nVR,to,from)
	 . if $p(data,%,13)'="" do
	 . . set txt=$p($g(^tAP($p(data,%,13))),%,2,3)
	 . . set carrier=$p(data,%,13)_$c(30)_$p(txt,%,1)_$c(30)_$p($p(txt,%,2),"*",1)_$c(30)_$p($p(txt,%,2),"*",2)_$c(30)_$p($p(txt,%,2),"*",3)
	 . . set insurance=$p($g(^tAP($p(data,%,13))),%,6)
	 . . if insurance'="" set insurance=insurance_$c(30)_$tr($p(^tSK(insurance),%,2,4),%,$c(30))
	 . . set $p(data,%,15,16)=carrier_%_insurance
	 . . quit
	 . set $p(data,%,17)=$$VRv^tU(CRE)
	 . if $p(data,%,10)="" set content(date,nVR)=data  ;__только если есть в этот день
	 . quit
	quit


IndexateStations
	new st,city,data,inx
	if ($$Sec($h)-$$Sec($g(^tCITYST)))<60 quit
	set st="" for  set st=$o(^tSTGEN(st)) quit:st=""  set data=$g(^tSTGEN(st)) set city=$p(data,$c(254),9) if city'="" set inx(city,st)=""
	set city="" for  set city=$o(^tCITYST(city)) quit:city=""  set st="" for  set st=$o(^tCITYST(city,st)) quit:st=""  if '$d(inx(city,st)) kill ^tCITYST(city,st)
	merge ^tCITYST=inx set ^tCITYST=$h
	quit


Sec(hdt)
	quit ($p(hdt,",",1)*86400)+($p(hdt,",",2))
