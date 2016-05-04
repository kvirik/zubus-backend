%WPAGE	; HTML dynamic page generator (from patterm)
	; HTML генератор динамических страниц (из шаблонов)
	; Квирикадзе В.Р.(с) 2015
	; Вер. 1.0.1
	;
	; Основная функция.
	; Сгенерировать страницу/фрагмент из шаблона name, который расположен
	; в директории ОС path (по умолчанию в /var/www/pattern/)
pwrite(name,path,lang)
	new %zstr,%ztxt,%zixstr,%zexec,%zntxt,%zzvar,%zfname,%zstat,%zzval
	if $g(path)="" set path="/var/www/pattern/"
	if $g(lang)="" set lang="ua"
	set $zt="zgoto "_$zlevel_":SysError^%WPAGE"
	use 0:(nowrap)
	set %zfname=path_name_".html"
	set %zstat=$$OpenFile^%WFILE(%zfname,"RT",0)
	if '%zstat do error(1002,$$locale("PatternNotFound",lang)_name) quit
	for %zstr=0:1 set %zstat=$$ReadLine^%WFILE(.%ztxt,%zfname,0) quit:'%zstat  do parse
	if $$CloseFile^%WFILE(%zfname)
	quit


	; Основная функция.
	; Сгенерировать страницу/фрагмент из строки,
	; которая передана параметром
swrite(%ztxt)
	new %zstr,%zixstr,%zexec,%zntxt,%zzvar,%zfname,%zstat,%zzval
	set %ztxt=$g(%ztxt)
	set $zt="zgoto "_$zlevel_":SysError^%WPAGE"
	use 0:(nowrap)
	do parse
	quit


parse	if $e($$SL^%WT(%ztxt),1,2)="#!" do  set $x=0,$y=0 quit
	. set %zexec=$p(%ztxt,"#!",2,$l(%ztxt,"#!"))
	. xecute %zexec
	if %ztxt["#(",%ztxt[")#" set %zntxt="" do  set $x=0,$y=0 quit
	. for %zixstr=1:1:$l(%ztxt,"#(") do
	. . set %zzvar=$p($p(%ztxt,")#",%zixstr),"#(",2)
	. . if %zzvar="" set %zzval=""
	. . else  set @("%zzval="_%zzvar)
	. . set %zntxt=%zntxt_$s($p(%ztxt,"#(",%zixstr)[")#":$p($p(%ztxt,"#(",%zixstr),")#",2),1:$p(%ztxt,"#(",%zixstr))_%zzval
	. write %zntxt,!
	if %ztxt["#!(",%ztxt[")!#" set %zntxt="" do  set $x=0,$y=0 quit
	. for %zixstr=1:1:$l(%ztxt,"#!(") do
	. . set %zzvar=$p($p(%ztxt,")!#",%zixstr),"#!(",2)
	. . set %zntxt=%zntxt_$s($p(%ztxt,"#!(",%zixstr)[")!#":$p($p(%ztxt,"#!(",%zixstr),")!#",2),1:$p(%ztxt,"#!(",%zixstr))_$s(%zzvar'="":$g(@%zzvar),1:"")
	. write %zntxt,!
	write %ztxt,!
	set $x=0,$y=0
	quit



jsonstatus(result,message)
	quit "{""result"":"_(+result)_", ""errortext"":"""_$g(message)_"""}"

SysError
	do error($zstatus,$$locale("GtmError",$g(lang)))
	quit

error(ErrCode,ErrName,ErrData,lang)
	new %zbebuginx
	set lang=$g(lang)
	if lang="" set lang="ua"
	set ErrCode=$g(ErrCode,1000)
	set ErrName=$g(ErrName,$$locale("PageLoadError",lang))
	write "<html>",!
	write "<head>",!
	write "<META http-equiv=content-type content=""text/html; charset=utf-8"">",!
	write "<!--begin scripts-->",!
	write "<link type=""text/css"" href=""../scripts/jquery-ui-1.11.3/jquery-ui.theme.min.css"" rel=""Stylesheet"" media=""screen"" />",!
	write "<!--end scripts-->",!
	write "<title>"_$$locale("OnPageError",lang)_"</title>",!
	write "</head>",!
	write "<body>",!
	write "  <table border=0 width=""100%"">",!
	write "  <tr><td>",!
	write "  <div class=""ui-widget"" style=""float:center; margin-top:15px"">",!
	write "    <div class=""ui-state-error ui-corner-all"" style=""padding:0 .7em"">",!
	write "      <p align=""center"">",!
	write "        <span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>",!
	write "        <strong>"_$$locale("OnPageError",lang)_"</strong><br>"_(ErrCode)_": "_(ErrName),!
	write "      </p>",!
	write "    </div>",!
	write "  </div>",!
	write "  </td></tr>",!
	do ErrData(.ErrData)
	write "  </table>",!
	write "</body>",!
	write "</html>",!
	quit


ErrData(ErrData)
	new inx
	if '$d(ErrData) quit
	write "<tr><td>",!
	write "<div class=""ui-widget"" style=""float:center;"">",!
	write "  <div class=""ui-state-highlight ui-corner-all"" style=""padding:0 .7em"">",!
	write "    <p>",!
	write "      <span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>",!
	set inx=""
	for  set inx=$o(ErrData(inx)) quit:inx=""  do
	 . write $g(ErrData(inx)),!
	 . quit
	write "    </p>",!
	write "  </div>",!
	write "</div>",!
	write "</td></tr>",!
	quit
	;
	;
locale(resName,lang)
	if $g(resName)="" quit ""
	set lang=$g(lang)
	if $e($$LA^%WT(lang))="r" set lang="ru"
	if $e($$LA^%WT(lang))="e" set lang="en"
	if $e($$LA^%WT(lang))="u" set lang="ua"
	if lang="" set lang="ua"
	set result=""
	if resName="PatternNotFound" set result=$s(lang="ru":"Не найден шаблон страницы",lang="en":"Page pattern not found",1:"Не знайдено шаблон сторінки")
	if resName="PageLoadError" set result=$s(lang="ru":"Ошибка загрузки страницы",lang="en":"Error loading page",1:"Помилка завантаження сторінки")
	if resName="OnPageError" set result=$s(lang="ru":"Ошибка на странице",lang="en":"Error on page",1:"Помилка на сторінці")
	if resName="GtmError" set result=$s(lang="ru":"Ошибка сервера GT.M",lang="en":"GT.M server fault",1:"Помилка сервера GT.M")
	if result="" quit resName
	quit result
	;
	; Замена подстрок на другие подстроки
REPL(str,substr,replto)	
	new i,newstr
	if ($g(str)="")!($g(substr)="") quit $g(str)
	if str'[substr quit str
	set replto=$g(replto)
	for i=1:1:$l(str,substr) set newstr=$g(newstr)_replto_$p(str,substr,i)
	set $e(newstr,1,$l(replto))=""
	quit newstr
	;
	;
