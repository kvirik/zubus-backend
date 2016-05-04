wtabloangjs ; Табло отправлений для станции Днепропетровск АВЦ (AngularJS)
	;
	;Глобальные переменные:
	;  codepage - кодовая страница для генерации итогового HTML
	;  ITEM     - номер или имя конфигурации (в конфигурации задается весь внешний вид в ^tabloht)
	;  BEGIN    - начальный номер рейса (для постраничного показа)
	;  NTAB     - количество строк на табло (задается в конфигурации)
	;  TABLO    - номер табло (предполагается запуск нескольких независимых браузеров
	;             для многомониторной конфигурации). Если не задано - обрабатывать будет другая программа
	;
	use $i:nowrap
	set %=$c(254)
	set codepage="utf8"
	set TABLO=$g(%Key("TABLO"))
	if TABLO="" set TABLO=0
	set ITEM=$g(%Key("ITEM"))
	if ITEM="" set ITEM=1
	set START=$g(%Key("START"))
	if START'="" set BEGIN="" do SetBegin
	set NTAB=$g(^tabloht(ITEM,"Config","RowCount"),10)
	if NTAB="" set NTAB=15
	do GetBegin
	set Depth=$l(%Request("URI"),"/")-$l(%Request("ScriptName"),"/")
	set DocRoot=""
	for i=1:1:Depth set DocRoot=DocRoot_"../"
	set Method=$p(%AppPath,"/",1)
	if Method="getraspdata" do getdatajson quit
	quit
	;
	;
	;
getdatajson
	new inx,json,jsoncnf,obj,row,fst,data
	do prepare(.data)
	do GetConfig(.jsoncnf)
	set inx="",fst=1,json="{"_jsoncnf_",""rasp"":["
	for inx=1:1:NTAB quit:'$d(data(inx))  do
	 . set row=$g(data(inx))
	 . set obj="{""date"":"""_$p(row,%,1)_""","
	 . set obj=obj_"""route"":"""_$p(row,%,2)_""","
	 . set obj=obj_"""timed"":"""_$p(row,%,3)_""","
	 . set obj=obj_"""timea"":"""_$p(row,%,4)_""","
	 . set obj=obj_"""places"":"""_$p(row,%,5)_""","
	 . set obj=obj_"""platf"":"""_$p(row,%,6)_"""}"
	 . set json=json_$s(fst:"",1:",")_obj
	 . set fst=0
	set json=json_"]}"
	write json,!
	quit
	;
	;
	;
prepare(data)
	new (data,codepage,ITEM,BEGIN,NTAB,TABLO)
	kill data,buf
	if $g(ITEM)="" set ITEM=1 ;__Oтладка
	set bD=+$h
	;set bT=+$p($h,",",2)-60
	;if (86400-bT)>21600 set eT=86400,eD=+$h
	;else  set eT=bT+21600-86400,eD=$h+1
	set eD=$h+1
	set bT=+$p($h,",",2)-60 if bT<0 set bT=0
	set eT=+$p($h,",",2)
	set %=$c(254)
	do ZM^%WT(1)
	for D=bD:1:eD set vr="" for  set vr=$o(^tMS(D,vr)) quit:vr=""  do
	.if $e(vr)'?1N quit
	.set time=$e(vr,1,$l(vr)-4)
	.if (time<bT)&(D=bD) quit
	.if (time>eT)&(D=eD) quit
	.set V1=vr
	.set tMS=^tMS(D,V1)
	.set dD=$p($$^%WH(4,D),".",1,2)
	.I $P(^tMS(D,V1),%,11)'=""!($P(^tMS(D,V1),%,10)'="") Q
	.;I 'PRIGOR,$P(^tM(+$P(^tMS(D,V1),%,4)),%,2)>2 Q  ;только межгород
	.;I PRIGOR,$P(^tM(+$P(^tMS(D,V1),%,4)),%,2)'>2 Q  ;только пригород
	.S t=$E(V1,1,$L(V1)-4)
	.S R=+$E(V1,$L(t)+1,255),t=t\60,t=(t\60)_":"_(t#60\10)_(t#10)
	.S StF=+$S($p(tMS,%,3)="":$p(tMS,%,1),1:$p(tMS,%,3))
	.S StN=+$p(tMS,%,2)
	.S STstrid=$g(^tST(StN)) I STstrid="" Q
	.I $g(^tSTDisplay(STstrid))'=TABLO Q
	.S Me=^tME(D,V1,1)+$P(^tME(D,V1,1),%,2)
	.S Meb=+^tME(D,V1,2)
	.S Pl=$p(tMS,%,9)
	.S P=$S($D(^tMS(D,V1,"S")):"^tMS(D,V1)",1:"^tRE(V1)")
	.S m=$L(@P@("S"),%)-1
	.S Prod=^tMS(D,V1,2)
	.S Prod=$l($tr(Prod," !""#$%&'()*"))
	.S Sost=$p(^tMS(D,V1),%,11)
	.S Sost=$s(Sost="":"",$l(Sost)>2:"ведомость",1:$g(^totm(Sost)))
	.I Sost="",$p(^tMS(D,V1),%,10)'="" S Sost="Блокирован"
	.I Sost'="" Q  ;I (Sost="Блокирован")!(Sost="ведомость") Q
	.S tP=$S($P(@P@("W"),%,m)'="":$P(@P@("W"),%,m),1:$P(@P@("V"),%,m))
	.;I StF'=^tTSYS("S") Q 
	.S StF=$g(^tST(StF))
	.S StN=$g(^tST(StN))
	.I StF'="",$p($g(^tSTAlias(StF)),%,1)'="" S StF=$p(^tSTAlias(StF),%,1)
	.I StN'="",$p($g(^tSTAlias(StN)),%,1)'="" S StN=$p(^tSTAlias(StN),%,1)
	.S Mars=$$gconv^%WU(StF_" - "_StN,"cp866",codepage)
	.;I Me'>0 Q
	.;S dNAM=$$gconv^%WU($p($$^%WH(3,D)," ",1,2),"cp866",codepage)
	.S buf(D_$tr($j(V1,9)," ",0))=dD_%_Mars_%_t_%_tP_%_Me_%_Pl_%_$$gconv^%WU(Sost,"cp866",codepage)
	.Q
	;if TABLO'=0 do RollSplit if 1
	;else  do RollNoSplit
	do RollNoSplit
	quit
	
	
RollSplit
	set inx=BEGIN
	set sinx=0,oD=$e($o(buf(inx)),1,5),split=0
	for j=1:1:NTAB set inx=$o(buf(inx)) quit:inx=""  do  quit:split  set data($i(sinx))=buf(inx)
	 . set split=($e(inx,1,5)>oD)
	 . set oD=$e(inx,1,5)
	 . if split set inx=$o(buf(inx),-1)
	if 'split,j'=NTAB for j=j:1:NTAB set inx=$o(buf(inx)) quit:inx=""  do  quit:split  set data($i(sinx))=buf(inx)
	 . set split=($e(inx,1,5)>oD)
	 . set oD=$e(inx,1,5)
	 . if split set inx=$o(buf(inx),-1)
	if inx="" set BEGIN="" do SetBegin quit
	set BEGIN=inx do SetBegin
	quit


RollNoSplit
	set inx=BEGIN,sinx=0
	for j=1:1:NTAB set inx=$o(buf(inx)) quit:inx=""  set data($i(sinx))=buf(inx)
	if inx="",'$d(data) for j=1:1:NTAB set inx=$o(buf(inx)) quit:inx=""  set data($i(sinx))=buf(inx)
	set BEGIN=inx do SetBegin
	quit

	;
	;
GetPictName(ITEM)
	set next='(+$g(^tabloht(ITEM,"Work","nextpict")))
	set ^tabloht(ITEM,"Work","nextpict")=next
	quit $s(next:""""_DocRoot_"../pictures/logo-ru-ani.gif""",1:""""_DocRoot_"../pictures/logo-en-ani.gif""")
	;
	;
	;
GetConfig(jsconf)
	new name,start,day,date,time,mar,next,logo
	set day=$$HDAY^%WH(+$H)
	set day=$p("НЕДІЛЯ:ПОНЕДІЛОК:ВІВТОРОК:СЕРЕДА:ЧЕТВЕР:П'ЯТНИЦЯ:СУБОТА",":",day+1)
	set date=$$^%WH(4)
	set time=$$TIME^%WH(0)
	set mar="Маршрут"
	if $g(TABLO)>0,$p(^tabloht("RouteNames",TABLO),$c(30),1)'="" do
	. set mar=$p(^tabloht("RouteNames",TABLO),$c(30),1)
	. set mar=$$gconv^%WU(mar,"CP866","utf8")
	set next='(+$g(^tabloht(ITEM,"Work","nextpict")))
	set ^tabloht(ITEM,"Work","nextpict")=next
	set logo=$s(next:""""_DocRoot_"pictures/logo-ru-ani.gif""",1:""""_DocRoot_"pictures/logo-en-ani.gif""")
	if '$d(^tabloht(ITEM,"Config","TabBorderColor")) set ^tabloht(ITEM,"Config","TabBorderColor")="#a6c9e2"  
	if '$d(^tabloht(ITEM,"Config","HdrBgImage")) set ^tabloht(ITEM,"Config","HdrBgImage")="ui-bg_gloss-wave_50_6eac2c_500x100.png"
	if '$d(^tabloht(ITEM,"Config","HdrBgImageTime")) set ^tabloht(ITEM,"Config","HdrBgImageTime")="ui-bg_gloss-wave_50_6eac2c_500x100.png"
	if '$d(^tabloht(ITEM,"Config","TabBgImage")) set ^tabloht(ITEM,"Config","TabBgImage")="ui-bg_glass_50_3baae3_1x400.png" 
	if '$d(^tabloht(ITEM,"Config","HdrFontFamily")) set ^tabloht(ITEM,"Config","HdrFontFamily")="Bookman Old Style"  
	if '$d(^tabloht(ITEM,"Config","DateFontFamily")) set ^tabloht(ITEM,"Config","DateFontFamily")="Times New Roman"  
	if '$d(^tabloht(ITEM,"Config","TimeFontFamily")) set ^tabloht(ITEM,"Config","TimeFontFamily")="Arial Black"  
	if '$d(^tabloht(ITEM,"Config","TabFontFamily")) set ^tabloht(ITEM,"Config","TabFontFamily")="Times New Roman"  
	if '$d(^tabloht(ITEM,"Config","StrFontFamily")) set ^tabloht(ITEM,"Config","StrFontFamily")="Arial Black"  
	if '$d(^tabloht(ITEM,"Config","HdrFontSize")) set ^tabloht(ITEM,"Config","HdrFontSize")="medium"  
	if '$d(^tabloht(ITEM,"Config","DateFontSize")) set ^tabloht(ITEM,"Config","DateFontSize")="x-small"  
	if '$d(^tabloht(ITEM,"Config","TimeFontSize")) set ^tabloht(ITEM,"Config","TimeFontSize")="medium"  
	if '$d(^tabloht(ITEM,"Config","TabFontSize")) set ^tabloht(ITEM,"Config","TabFontSize")="small"   
	if '$d(^tabloht(ITEM,"Config","StrFontSize")) set ^tabloht(ITEM,"Config","StrFontSize")="small"   
	if '$d(^tabloht(ITEM,"Config","HdrFontColor")) set ^tabloht(ITEM,"Config","HdrFontColor")="Black"   
	if '$d(^tabloht(ITEM,"Config","DateFontColor")) set ^tabloht(ITEM,"Config","DateFontColor")="Red"   
	if '$d(^tabloht(ITEM,"Config","TimeFontColor")) set ^tabloht(ITEM,"Config","TimeFontColor")="Blue"   
	if '$d(^tabloht(ITEM,"Config","TabFontColor")) set ^tabloht(ITEM,"Config","TabFontColor")="#110044"  
	if '$d(^tabloht(ITEM,"Config","StrFontColors")) set ^tabloht(ITEM,"Config","StrFontColors")="Blue,Black,Black,Black,Red,Black" 
	if '$d(^tabloht(ITEM,"Config","TabRowHeight")) set ^tabloht(ITEM,"Config","TabRowHeight")="1"   
	if '$d(^tabloht(ITEM,"Config","StrRowHeight")) set ^tabloht(ITEM,"Config","StrRowHeight")="1.75"   
	if '$d(^tabloht(ITEM,"Config","StrEvenColor")) set ^tabloht(ITEM,"Config","StrEvenColor")="#ffff99"  
	if '$d(^tabloht(ITEM,"Config","StrOddColor")) set ^tabloht(ITEM,"Config","StrOddColor")="#99ff99"  
	if '$d(^tabloht(ITEM,"Config","TabBgColor")) set ^tabloht(ITEM,"Config","TabBgColor")="#ccccff"  
	if '$d(^tabloht(ITEM,"Config","HdrBgColor")) set ^tabloht(ITEM,"Config","HdrBgColor")="#eeffee"  
	if '$d(^tabloht(ITEM,"Config","RefreshTime")) set ^tabloht(ITEM,"Config","RefreshTime")="20"   
	if '$d(^tabloht(ITEM,"Config","RowCount")) set ^tabloht(ITEM,"Config","RowCount")="10"   
	if '$d(^tabloht(ITEM,"Config","TitleText")) set ^tabloht(ITEM,"Config","TitleText")=$$gconv^%WU("Табло вiдправлень","utf8","CP866")
	if '$d(^tabloht(ITEM,"Config","RouteFontColor")) set ^tabloht(ITEM,"Config","RouteFontColor")="#110044"
	set name=""
	set jsconf="""conf"":{"
	for  set name=$o(^tabloht(ITEM,"Config",name)) quit:name=""  do
	 . set jsconf=jsconf_""""_name_""":"""_^(name)_""","
	set jsconf=jsconf_"""time"":"""_time_""",""date"":"""_date
	set jsconf=jsconf_""",""day"":"""_day_""",""DocRoot"":"""_DocRoot
	set jsconf=jsconf_""",""routeText"":"""_mar_""",""logoImg"":"_logo_"}"
	quit
	;
	;
	;
GetBegin
	set BEGIN=$g(^tabloht(ITEM,TABLO,"Work","begin"))
	quit
SetBegin	
	set ^tabloht(ITEM,TABLO,"Work","begin")=BEGIN
	quit
	;
	;
