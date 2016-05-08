%WJSON	;__Модуль конвертирования структурированных данных в формат JSON

FromTree(src,dst)
	set dst=$$jsfy(.src)
	quit:$quit dst
	quit

FromTab(src,dst,cfg)
	kill dst
	do jsfyt(.src,.cfg,.dst)
	if '$d(dst) set dst(1)="[]" quit
	set dst(1)="["_$g(dst(1))
	set dst(dst)=dst(dst)_"]"
	quit

jsfy(src,arr)
	new str,i,br
	set str="",pr="",arr=$g(arr)
	if $d(@src)=1 do  quit str
	 . if arr set str=$$v(@src)
	 . else  set str=$$q($qs(src,$ql(src)))_$$v(@src)
	if $o(@src@(""))?1.N,$o(@src@(""),-1)?1.N set br="[]"
	else  set br="{}"
	set i=""
	for  set i=$o(@src@(i)) quit:i=""  do
	 . if br="[]" set str=str_", "_$$jsfy($name(@src@(i)),1)
	 . else  do
	 . . if $d(@src@(i))>1 set str=str_", "_$$q(i)_$$jsfy($name(@src@(i)),0)
	 . . else  set str=str_", "_$$jsfy($name(@src@(i)),0)
	set str=$e(br,1)_$e(str,3,$l(str))_$e(br,2)
	if $d(@src)=11 do
	 . set str="{"_$$q($qs(src,$ql(src))_"_")_$$v(@src)_", "_$$q($qs(src,$ql(src)))_str_"}"
	quit str

	;__get correct key
q(prop)	if prop?1.N set prop="_"_prop
	quit """"_prop_""":"

	;__get correct value
v(val)	if val=+val quit val
	if $e(val)="{",$e(val,$l(val))="}" quit val
	quit """"_val_""""

	;__mask illegal symbols
m(str)	quit str




jsfyt(src,cfg,dst,lvl)
	new fldi,in,conf,fldc,val,fval,fname,fnum,ftype,fdel,gstr,str
	set lvl=$g(lvl)+1
	if $g(cfg(lvl))=""  do  quit  ;_этот уровень не описан - пропускаем
	 . set in="" for  set in=$o(@src@(in)) quit:in=""  do
	 . . if $d(@src@(in)) do jsfyt($name(@src@(in)),.cfg,.dst,lvl)
	set conf=cfg(lvl)
	set in="",gstr=""
	for  set in=$o(@src@(in)) quit:in=""  if $d(@src@(in))#10 do
	 . set fval=@src@(in),str=""
	 . for fldi=1:1:$l(conf,"|") do
	 . . set fldc=$p(conf,"|",fldi) if fldc="" quit
	 . . set fname=$p(fldc,":",1)
	 . . set fnum=$p(fldc,":",2) if fnum="" set fnum=fldi
	 . . set ftype=$p(fldc,":",3) if ftype="" set ftype="S"
	 . . set fdel=$p(fldc,":",4) if fdel="" set fdel=$c(254)
	 . . if $e(fnum)'="%" set val=$p(fval,fdel,fnum)
	 . . if $e(fnum)="%" set val=$qs($name(@src@(in)),$e(fnum,2,$l(fnum)))
	 . . . set fnum=$e(fnum,2,$l(fnum))
	 . . . set fname=$p($g(cfg(0)),"|",fnum)
	 . . set str=str_","_$$q(fname)_$$v(val)
	 . if $d(@src@(in))>1 do  set:val'="" str=str_","_$$q(fname)_$$v(val)
	 . . set fname=$p($g(cfg(0)),"|",lvl)
	 . . set val=$$jsfyt($name(@src@(in)),.cfg,.dst,lvl)
	 . if str'="" set dst($i(dst))="{"_$e(str,2,$l(str))_"}"_$s($o(@src@(in))'="":",",1:"")
	quit:$quit $g(dst(dst))
	quit


test	kill a
	set a("obj","a")=1
	set a("obj","b")=2
	set a("obj","c")=3
	set a("obj","d")=4
	write $$jsfy("a"),!

	kill a
	set a("obj",1)=1
	set a("obj",2)=2
	set a("obj",3)=3
	set a("obj",4)=4
	write $$jsfy("a"),!

	kill a
	set a("obj",1,"a")=1
	set a("obj",1,"ax")=2
	set a("obj",1,"ay")=3
	set a("obj",1,"az")=1
	set a("obj",2,"a")=2
	set a("obj",2,"ax")=3
	set a("obj",2,"ay")=1
	set a("obj",2,"az")=2
	set a("obj",3,"a")=3
	set a("obj",3,"ax")=1
	set a("obj",3,"ay")=2
	set a("obj",3,"az")=3
	set a("obj",4,"a")=1
	set a("obj",4,"ax")=2
	set a("obj",4,"ay")=3
	set a("obj",4,"az")=1
	write $$jsfy("a"),!

	kill a
	set a("obj","pr1","x")="is1x"
	set a("obj","pr1","y")="is1y"
	set a("obj","pr1","z")="is1z"
	set a("obj","pr2","a")="is2a"
	set a("obj","pr2","b")="is2b"
	set a("obj","pr2","c")="is2c"
	write $$jsfy("a"),!

	quit

test1	kill a
	set a="z"
	set a(1,"a")=1
	set a(1,"ax")=2
	set a(1,"ay")=3
	set a(1,"az")=1
	set a(2,"a")=2
	set a(2,"ax")=3
	set a(2,"ay")=1
	set a(2,"az")=2
	set a(3,"a")=3
	set a(3,"ax")=1
	set a(3,"ay")=2
	set a(3,"az")=3
	set a(4,"a")=1
	set a(4,"ax")=2
	set a(4,"ay")=3
	set a(4,"az")=1
	write $$jsfy("a"),!
	quit

test2	kill a
	set a("a")=1
	set a("b")=2
	set a("c")=3
	set a("d")=4
	write $$jsfy("a"),!

	kill a
	set a(1)=1
	set a(2)=2
	set a(3)=3
	set a(4)=4
	write $$jsfy("a"),!

	kill a
	set a(1,"a")=1
	set a(1,"ax")=2
	set a(1,"ay")=3
	set a(1,"az")=1
	set a(2,"a")=2
	set a(2,"ax")=3
	set a(2,"ay")=1
	set a(2,"az")=2
	set a(3,"a")=3
	set a(3,"ax")=1
	set a(3,"ay")=2
	set a(3,"az")=3
	set a(4,"a")=1
	set a(4,"ax")=2
	set a(4,"ay")=3
	set a(4,"az")=1
	write $$jsfy("a"),!

	kill a
	set a("pr1","x")="is1x"
	set a("pr1","y")="is1y"
	set a("pr1","z")="is1z"
	set a("pr2","a")="is2a"
	set a("pr2","b")="is2b"
	set a("pr2","c")="is2c"
	write $$jsfy("a"),!

	quit

test3
	set dsc(0)="code"
	set dsc(1)="code:%1:N|perc:1:N|name:2:S|addr:3:S|str:6:N|nds:8:N|email:13:S"
	do FromTab("^tAP",.dst,.dsc)
	zwr dst
	quit
