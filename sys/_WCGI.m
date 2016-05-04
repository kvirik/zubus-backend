%WCGI
 ;
 new i,data,entry,contype
 set $ZTRAP="Do Error^%WCGI()"
 ;
 if $ZTRNLNM("GTMXC_gtmxml")="" if $&gtmwin.gsetenv("GTMXC_gtmxml",$ZTRNLNM("gtm_dist")_"/gtmxml.xc")
 if $ZTRNLNM("GTMXC_gtmsec")="" if $&gtmwin.gsetenv("GTMXC_gtmsec",$ZTRNLNM("gtm_dist")_"/gtmsec.xc")
 ;
 if $ZTRNLNM("REQUEST_METHOD")="POST" do
 . ; Retrieve variables from <stdin>
 . read data#$ZTRNLNM("CONTENT_LENGTH"):5
 . quit
 else  do
 . ; Retrieve variables from Query-String
 . set data=$ZTRNLNM("QUERY_STRING")
 . quit
 ;
 ;do LogCGI(data)
 for i=1:1:$Length(data,"&") do
 . new ind,pc,val
 . set pc=$Piece(data,"&",i)
 . set ind=$$URLin($Piece(pc,"=",1)),val=$$URLin($Piece(pc,"=",2))
 . set:ind'="" %Key(ind)=$$Unquote(val)
 . quit
 ;
 set %Request("Root")=$ztrnlnm("DOCUMENT_ROOT")
 set %Request("Method")=$ztrnlnm("REQUEST_METHOD")
 set %Request("URI")=$ztrnlnm("REQUEST_URI")
 set %Request("HttpHost")=$ztrnlnm("HTTP_HOST")
 set %Request("HttpReferer")=$ztrnlnm("HTTP_REFERER")
 set %Request("UserAgent")=$ztrnlnm("HTTP_USER_AGENT")
 set %Request("Accept")=$$LA^%WT($ztrnlnm("HTTP_ACCEPT"))
 set %Request("ContentType")=$ztrnlnm("CONTENT_TYPE")
 set %Request("AcceptCharset")=$ztrnlnm("HTTP_ACCEPT_CHARSET")
 set %Request("AcceptEncoding")=$ztrnlnm("HTTP_ACCEPT_ENCODING")
 set %Request("AcceptLang")=$ztrnlnm("HTTP_ACCEPT_LANGUAGE")
 set %Request("PWD")=$ztrnlnm("PWD")
 set %Request("RemoteAddr")=$ztrnlnm("REMOTE_ADDR")
 set %Request("RemoteHost")=$ztrnlnm("REMOTE_HOST")
 set %Request("RemoteUser")=$ztrnlnm("REMOTE_USER")
 set %Request("ScriptName")=$ztrnlnm("SCRIPT_NAME")
 set %Request("ServerName")=$ztrnlnm("SERVER_NAME") 
 set %Request("ServerAdmin")=$ztrnlnm("SERVER_ADMIN")
 set %Request("ServerPort")=$ztrnlnm("SERVER_PORT")
 set %Request("ServerProto")=$ztrnlnm("SERVER_PROTOCOL")
 set %Request("ServerSign")=$ztrnlnm("SERVER_SIGNATURE")
 set %Request("ServerSoft")=$ztrnlnm("SERVER_SOFTWARE")
 set %Request("GwInterface")=$ztrnlnm("GATEWAY_INTERFACE")
 set %Request("Host")=$ztrnlnm("HOST")
 set %Request("Path")=$ztrnlnm("PATH_INFO")
 set %Request("PathTrans")=$ztrnlnm("PATH_TRANSLATED")
 set %AppPath=$p(%Request("URI"),%Request("ScriptName"),2)
 if $e(%AppPath)="/" set $e(%AppPath)=""
 set %Application=$p($p($p(%AppPath,"/",1),"?",1),"#",1)
 set %AppPath=$p($p($p(%AppPath,"/",2,$l(%AppPath,"/")),"?",1),"#",1)
 if %Application="" do Error("NO_APP")
 set %Entry=$g(^tWPAGE(%Application,"Routine"))
 if %Entry="" set %Entry=$s($text(+0^@%Application)'="":"^"_%Application,1:"")
 if %Entry="" do Error("NO_ENTRY")
 set %ContentType=$$LA^%WT($g(^tWPAGE(%Application,"ContentType")))
 do Header(%Entry,%ContentType,%Request("Accept"))
 set $et="do Error^%WCGI(""PAGE_ERROR"") halt"
 do @%Entry
 halt
 ;
 ;
Header(entry,ctype,accept)
 set entry="^"_$p($p(entry,"^",2),"(",1)
 if ctype="custom" do @("Header"_entry) quit
 if ctype["text/html",(accept["text/html")!(accept["*/*") do StdHeader("text/html") quit
 if ctype["application/xml",(accept["application/xml")!(accept["*/*") do StdHeader("application/xml") quit
 if ctype["application/xhtml",(accept["application/xhtml")!(accept["*/*") do StdHeader("application/xhtml") quit
 if ctype["application/json",(accept["application/json")!(accept["*/*") do StdHeader("application/json") quit
 do StdHeader("text/html")
 quit
 ;
 ;
StdHeader(contype)
 write "CONTENT-TYPE: "_contype,!!
 quit
 ;
 ;
URLin(x) 
 new c,e,hex,i,p,r,z
 set hex="0123456789abcdef",z=$tr(x,"ABCDEF","abcdef")
 set r="" for i=1:1:$Length(x) Do
 . set e=$Extract(x,i)
 . if e="+" Set r=r_" " Quit
 . if e="%" Do  Quit
 . . set c=$Find(hex,$Extract(z,i+1))-2*16+$Find(hex,$Extract(z,i+2))-2
 . . set r=r_$Char(c),i=i+2
 . . quit
 . set r=r_e
 . quit
 quit r
 ;
URLout(x) 
 new e,i,hex,r
 set hex="0123456789abcdef"
 set r="" for i=1:1:$Length(x) do
 . set e=$Extract(x,i)
 . if e?1AN set r=r_e Quit
 . if e=" " set r=r_"+" Quit
 . set e=$ASCII(e),r=r_"%"_$Extract(hex,e\16+1)_$Extract(hex,e#16+1)
 . quit
 quit r
 ;
HTMLout(x)
 new e,i,r
 set r="" For i=1:1:$Length(x) Do
 . set e=$Extract(x,i)
 . if e="&" Set r=r_"&amp;" Quit
 . if e="<" Set r=r_"&lt;" Quit
 . if e=">" Set r=r_"&gt;" Quit
 . if $Ascii(e)>126 Set r=r_"&#"_$Ascii(e)_";" Quit
 . set r=r_e
 . quit
 quit r
 ;
Unquote(str)
 set str=$$S^%WT(str)
 if $e(str)="""",$e(str,$l(str))="""" set $e(str,$l(str))="",$e(str)=""
 if $e(str)="'",$e(str,$l(str))="'" set $e(str,$l(str))="",$e(str)=""
 if $e(str)="`",$e(str,$l(str))="`" set $e(str,$l(str))="",$e(str)=""
 quit str
 ;

Error(MSG) ;
 if $$LA^%WT($ztrnlnm("HTTP_ACCEPT"))["text/html" do  halt
  . write "CONTENT-TYPE: text/html",!!
  . write "<html><title>GT.M Pages Error Report</title><body>"
  . write !,"<h2><font color=#ff0000>Error: "_$$HTMLout($g(MSG,0))_"</h2>"
  . write !,"<h3>GT.M version is ",$ZVERSION,"</h3>"
  . write !,"<h4><font color=#ff00ff>ERROR: ",$zstatus,"</h2><font color=#ff0000>"
  . write !,"<pre>"
  . zshow "*"
  . write !,"</pre>"
  . write !,"</body></html>"
 if $$LA^%WT($ztrnlnm("HTTP_ACCEPT"))["application/xml" do XMLError(.MSG) halt
 halt
 ;

XMLError(MSG)
 new %context
 set $et=""
 set $zt="halt  "
 if $g(MSG)="" do SaveContext(.%context)
 do WriteError($g(MSG,0),"General Interface Error",.%context)
 quit
 ;
 ;
WriteError(code,name,addon)
 new i
 write "<?xml version=""1.0"" encoding=""windows-1251""?>",!
 write "<error>",!
 write "<code>"
 write $g(code)
 write "</code>",!
 write "<name>"
 write $$Enc($g(name))
 write "</name>",!
 if $d(addon) do
  . write "<addon>",!
  . if $d(addon)>1 do
  . . set i=""
  . . for  set i=$o(addon(i)) quit:i=""  write "<item text=",$$QE(addon(i))," />",!
  . . quit
  . else  write "<item text=",$$QE(addon)," />",!
  . write "</addon>",!
  . quit
 write "</error>",!
 quit
 ;
 ;
SaveContext(%context)
 new zyx0
 kill ^zCtx($j)
 set ^zCtx($j)=1
 set ^zCtx($j,$i(^zCtx($j)))="$zstatus="_$zstatus
 set ^zCtx($j,$i(^zCtx($j)))="$s="_$s
 set ^zCtx($j,$i(^zCtx($j)))="$t="_$t
 set ^zCtx($j,$i(^zCtx($j)))="$p="_$p
 set ^zCtx($j,$i(^zCtx($j)))="$i="_$i
 set ^zCtx($j,$i(^zCtx($j)))="$j="_$j
 set ^zCtx($j,$i(^zCtx($j)))="$zjob="_$zjob
 set ^zCtx($j,$i(^zCtx($j)))="$zmode="_$zmode
 set ^zCtx($j,$i(^zCtx($j)))="$za="_$za
 set ^zCtx($j,$i(^zCtx($j)))="$zb="_$zb
 set ^zCtx($j,$i(^zCtx($j)))="$stack(-1)="_$stack(-1)
 set ^zCtx($j,$i(^zCtx($j)))="$stack="_$stack
 set ^zCtx($j,$i(^zCtx($j)))="$estack="_$estack
 for zyx0=1:1:$stack(-1) do
  . set ^zCtx($j,$i(^zCtx($j)))="$stack("_zyx0_")="_$stack(zyx0)
  . set ^zCtx($j,$i(^zCtx($j)))="$stack("_zyx0_",place)="_$stack(zyx0,"place")
  . set ^zCtx($j,$i(^zCtx($j)))="$stack("_zyx0_",ecode)="_$stack(zyx0,"ecode")
  . set ^zCtx($j,$i(^zCtx($j)))="$stack("_zyx0_",mcode)="_$stack(zyx0,"mcode")
  . quit
 if $d(%)#10 set ^zCtx($j,$i(^zCtx($j)))="%="_%
 set %="%"
 for  set %=$o(@%) quit:%=""  if ",zyx0,%context,"'[(","_%_",") do VarIndex(%)
 merge %context=^zCtx($j)
 set zyx0=$$TIME^%WH(4)
 kill ^zCtx($j)
 quit
VarIndex(%)
 if $d(@%)#10 set ^zCtx($j,$i(^zCtx($j)))=$tr(%_"="_$e($g(@%),1,255),"""'&"_$c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))
 for  set %=$q(@%) quit:%=""  set ^zCtx($j,$i(^zCtx($j)))=$tr(%_"="_$e($g(@%),1,255),"""'&"_$c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))
 quit

 ;__Заключение строки в двойные кавычки
Quot(Str)
 quit """"_$tr(Str,"""'","``")_""""
 ;
 ;__Заключение строки в двойные кавычки с перекодировкой DOS -> WIN
QE(Str)
 quit $$Quot($$Enc(Str))
 ;__Перекодировка строки из кодировки DOS (866) в кодировку WIN (1251)
Enc(Str)
 set Str=$tr(Str,$c(209,210),$c(73,244))
 quit $$gconv^%WU(Str,"CP866","CP1251")

 