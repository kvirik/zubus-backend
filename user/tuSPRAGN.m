tuSPRAGN	;;������� �ࠢ�筨�� ����⮢; ���ਪ���� �.�.(�); GT.M 2006-2016;
	; ��� ������⥬� ��� ���⠭樮����� �ਬ������
	;--------- �������:
	;   ^tAGENT("A")
	;   ^tAGENT("A",��������) ��� �������� 4 ����  (3 ���� �� ����� ��⥬� � 1 ��� �� ���� �����
	;                                                  �� ������᪮� ��⥬� ����஢����)
	;                          ��� ��砫� ������� �� ��� ����� ��稭����� ⮫쪮 � ���ન (5)
	; �ࠢ�� ���� ^tAGENT("A",��������)
	;  1. ������������ �����
	;  2. ��� ����� �������� (�� �⮣� �� �ࠢ�筨��) �� ���⮥ ���� ��� �㡠���⮢
	;   
	;   ^tAGENT("U")
	;   ^tAGENT("U",login)
	;  1. ��஫� ��� ��� ���
	;  2. ��� ����� �� �ࠢ�筨�� ����⮢ ^tAGENT("A")
	;  3. ��� ����� (2 �����) ��� ��᫥���� ����� �� ���� ����� ������᪮� ��⥬�
	;  4. ���� (1-�த��騩 �����, 0-⮫쪮 �����)
	;  5. ���� (1-ࠧ�襭�� ���짮��⥫�, 0-�������஢���� ���짮��⥫�)
	;   
	;   ^tAGENT("I")
	;   ^tAGENT("I",NKAS)  ��� NKAS ������᪨� ��� ���⥬�_�����⥬�_�������� (6 ���)
	;  1. login
	;
	;
	new i,buf,name,ind,key,zz,hdr,brd,ip,descr,reg,m,filt,%finder
	new y1,y2,x1,x2,hlen,width,rtn
	set rtn=$p($zpos,"^",2)
	;__�஢��塞 ���樠����஢��� �� "�������" ��⥬� %W
	set reg=$$registered^%W
	;__�᫨ ��� - ���樠�����㥬
	if 'reg if $$ZWNA^%W
	if $$ZWNS^%W("$mainwindowstgen")
	do Box^%WT(" "_$$Name_" ")
	;__�뢥��� ��ப� ���᪠��� (��ਠ�� 1) �����
	do DrawHlp(1)
	do SetCoord(0,.y1,.y2)
	do MakePict(.m,.hlen,.width,y2-y1+1)
	set x1=(80-width)\2,x2=x1+width+1
	if $$ZWNS^%W("kardlist$",x1,y1,x2+1,y2+1)
	if $$^%TMESS(m,"","0�"_x1_","_y1_"�15,1�"_x2_","_y2_"�1","")
	;__�����稬 ��⨢�� ������ ��� ᯨ᪠ ����ᥩ
	;__�����祭�� �� ����⨥ ��� ������
	set key=",NOKEY�,F7�,�DSearch^"_rtn_",CTRLF�,�DReFind^"_rtn_",F8�,�DDel^"_rtn_",F2�,�DAdd^"_rtn_",ENTER�,F4�,�DEdit^"_rtn_",DEL�,INS�,�DIns^tuSPRSTA,"
	;__��������� ᯨ᪠
	set hdr=" "_$$Name_" ��10,1"
	;__��ࠬ���� ࠬ�� ᯨ᪠
	set brd="3�"_(x1+2)_","_(y1+hlen+1)_"�11,1�"_(x2-2)_","_(y2-1)_"�1"
	;__��砫�� ������ ��� ��ॡ�� ᯨ᪠
	set ind=""
	set zz="set X=$$FormatLine^"_rtn_"(k)"
	set filt="if '$d(@%ch@(k,""D""))"
	set zz=$$^%TCHOI("",hdr,brd,"�1",1,15,1,0,7,14,1,$$Ref,.ind,.key,,,,zz,,"DChkEmpty^"_rtn,1,,,filt)
	;__���⨬ �࠭
	if $$ZWNR^%W("kardlist$")
	if $$ZWNK^%W("kardlist$")
	;write $$TA^%W(7,0),$$ED^%W
	if $$ZWNR^%W("$mainwindowstgen")
	if $$ZWNK^%W("$mainwindowstgen")
	;__�᫨ "�������" ��⥬� %W �뫠 ���樠����஢��� �� �室� - ���᪠�� ��
	if '$g(reg) set zz=$$ZWND^%W write $$CON^%W
	;__��� ��⮢� - ����� �������� �ணࠬ��
	quit

Lite	if $$Dict(,1)
	quit

	;__�������㠫�� ����ன�� ��� �ࠢ�筨��
Name()	quit "��ࠢ�筨� ����⮢/�㡠���⮢"

Ref()	quit $name(^tAGENT("A"))

SetCoord(isHelp,top,bottom)
	if isHelp set top=12,bottom=22 quit
	set top=4,bottom=20
	quit

SetHeader(hdr,formula,width)
	set hdr(1)="�������������������������������������������������������������"
	set hdr(2)=" ��� �     ������������ �����      �   ����� ��� �㡠����  "
	set hdr(3)="�������������������������������������������������������������"
	set formula="4,30,24"
	set width=$l(hdr(1))+2
	quit

Dict(ReadOnly,GrpOp,Filter)
	new i,buf,name,ind,key,zz,hdr,brd,ip,descr,reg,m,filt,%finder
	new y1,y2,x1,x2,hlen,width,rtn
	set rtn=$p($zpos,"^",2)
	set ReadOnly=$g(ReadOnly)
	do SetCoord(1,.y1,.y2)
	if $$ZWNS^%W("helpline$",2,24,79,24)
	do DrawHlp(4+''ReadOnly)
	do MakePict(.m,.hlen,.width,y2-y1+1)
	set x1=(80-width)\2,x2=x1+width+1
	if $$ZWNS^%W("kardlist$",x1,y1,x2+1,y2+1)
	if $$^%TMESS(m," "_$$Name()_" ","0�"_x1_","_y1_"�1,7�"_x2_","_y2_"�1","")
	set key=",NOKEY�,F7�,�DSearch^"_rtn_",CTRLF�,�DReFind^"_rtn_",F8�,�DDel^"_rtn_",F2�,�DAdd^"_rtn_$s($g(GrpOp):",ENTER�",1:"")_",F4�,�DEdit^"_rtn_",DEL�,INS�,�"_$s($g(GrpOp):"DIns^tuSPRSTA,",1:"XS PR=0,")
	if ReadOnly set key=",NOKEY�,F7�,�DSearch^"_rtn_",CTRLF�,�DReFind^"_rtn_",DEL�,INS�,�XS PR=0,"
	set hdr=" "_$$Name_" ��10,1"
	set brd="3�"_(x1+2)_","_(y1+hlen+1)_"�1,7�"_(x2-2)_","_(y2-1)_"�1"
	set ind=""
	set zz="set X=$$FormatLine^"_rtn_"(k)"
	set filt=""
	if $g(Filter)'="" set filt=Filter
	set zz=$$^%TCHOI("",hdr,brd,"�1",1,0,7,7,0,5,7,$$Ref,.ind,.key,,,,zz,,"DChkEmpty^"_rtn,1,,,filt)
	set zz=$$ZWNR^%W("kardlist$"),zz=$$ZWNK^%W("kardlist$")
	set zz=$$ZWNR^%W("helpline$"),zz=$$ZWNK^%W("helpline$")
	if key="ENTER" quit ind
	quit ""


MakePict(m,hdrLen,width,num)
	kill m
	do SetHeader(.m,,.width)
	set hdrLen=$o(m(""),-1)
	for i=1:1:num-hdrLen set m=$g(m)_$$J^%WT($g(m(i)),$l(m(1)))
	quit

FormatLine(id)
	new fld,i,types,formula,types,star
	if $g(id)="" quit ""
	set star=$s($d(%ind(id)):"*",1:" ")
	do SetHeader(,.formula)
	for i=1:1:$l(formula,",") set fld(i-1)=$j("",$p(formula,",",i))
	set fld(0)=$j(id,$p(formula,",",1))
	if $g(@%ch@(id))'="" do
	 . set data=@%ch@(id)
	 . set fld(1)=$p(data,"�",1)
	 . set fld(2)=$p(data,"�",2)
	 . if fld(2)'="",$d(@$$Ref@(fld(2))) set fld(2)=$p(@$$Ref@(fld(2)),"�",1)
	 . quit
	set fld=""
	for i=0:1:$l(formula,",")-1 set fld=fld_"�"_$$JE^%WT(fld(i),$p(formula,",",i+1))
	set $e(fld)=star
	quit fld

	;__�஢�ઠ �� ���� �� ᯨ᮪ ��। �뢮��� ��� �� �࠭
	;__�᫨ ���� - �ࠧ� �����⨬ ��楤��� ���������� 㧫��
ChkEmpty
	if $d(@%choi) kill %PrP quit
	do Add
	kill %PrP quit


	;__��楤�� 㤠����� ����� | ᯨ᪠ 㧫��
Del	set PR=0
	new code,i,answ,msg,list,inx,idfd,id
	;__� ��६����� k ᨤ�� ⥪�騩 ������ � "த�⥫�᪮�" ᯨ᪥
	;__�� ��� ������ ��� 㧫�
	set code=$g(k),list=0
	if $d(%ind)>1 set list=1
	if 'list,code="" quit  ;__⠪ �� �뢠��, �� �� ��...
	;__���⠢�� �஧��� ᮮ�饭�� ��� ������� ⨯� ��/���
        set msg(1)="�� ����⢨⥫쭮 ��� 㤠����"
	if list set msg(2)="�뤥����� ᯨ᮪ ����ᥩ �ࠢ�筨��?"
	else  set msg(2)="������ �ࠢ�筨�� � ����� "_code_" ?"
	set msg(5)="���⢥न� 㤠�����..."
	;__�뢥��� ������ �� �࠭, 堩 � �롥�� 祣� ��� ����
	set answ=$$D^%WT(.msg," ������� � �� 㤠���� ","e",12,2,2)
	;__�᫨ �� ��ᮬ������� - ���� �멤�� �� ��楤���
	if answ'=1 quit
	;__�᫨ �� �� ���� 㤠���� � 㤠��� 㧥� �� ���䨣��樨
	;_... � c���஭����� � �⠭�ﬨ (�᫨ ����祭�)
	if 'list set %ind(k)=""
	set i="" for  set i=$o(%ind(i)) quit:i=""  do
	 . kill %ind(i)
	 . kill @%choi@(i)
	 . ;_��᪠���� 㤠����� �� ���� "�������" �ࠢ�筨�� �⠭権
	 . set idfd=2
	 . set id="" for  set id=$o(@$$Ref@(id)) quit:id=""  do
	 . . if $p(@$$Ref@(id),"�",idfd)=i set $p(@$$Ref@(id),"�",idfd)=""
	;__������ ��㣮� ⥪�騩 ������
	set inx=$o(@%choi@(k),-1)
	if inx="" set inx=$o(@%choi@(k))
	set (Index,k)=inx
	;__�᫨ 㦥 �� ������� 㤠���� �� ���ᨢ�
	;__� �멤�� � ���⠢�� "த�⥫�᪨�" ᯨ᮪ ⮦� �४����
	;__ࠡ��� (PR=2) ���� ����ᨬ "த�⥫�᪨�" ᯨ᮪ ����ᮢ����� (PR=3)
	if k="" set PR=2
	else  set PR=3
	quit

Add	
	new stat
	set stat=$$kard("")
	if +stat set (k,Index)=$p(stat,"�",2),PR=3
	quit

Edit
	new name,stat
	set name=$g(k)
	if name="" quit
	set stat=$$kard(name)
	if +stat set Index=k,PR=3
	quit


	;-------------------------------------------------------------------------------
	;
	; ����窠
	;
kard(id)
	new %l,%pN,aaa,ins,xA,zz,lockid,data,types,ms,startFld
	new i,vars,desc,fld,keys,answ,msg,true,false,edited,descr
	new stat,x,unreg,newid,saved,x1,x2,y1,y2,dx,formula,rtn
	set rtn=$p($zpos,"^",2)
	do SetHeader(,.formula)
	set edited=0
	set saved=0
	set newid=0
	set ins=1
	if $g(id)="" set newid=1 for i=5000:1 if '$d(@$$Ref@(i)) set lockid=i lock +@$$Ref@(lockid):0 if  quit
	if $g(id)'="" set lockid=id lock +@$$Ref@(lockid):1  else  set zz=$$D^%WT("������ ������ ।������ ��㣮� ���짮��⥫�","  ��  ","inf",12) quit:$quit 0 quit
	set true="I 1",false="I 0"
	set data=$s(id'="":$g(@$$Ref@(id)),1:"")
	set startFld=1
	if newid set msg(1)="���                                               "
	else     set msg(1)="���                 "_id
	         set msg(2)="������������ �����                               "
	         set msg(3)="����� ��� �㡠����                               "
	set vars="1�fld",ms=""
	for i=1:1:$o(msg(""),-1) set fld(i)="" if $d(msg(i)) set ms=ms_$$JE^%WT(msg(i),$l(msg(2)))
	set x1=80-$l(msg(2))\2-1,x2=x1+$l(msg(2))+3
	set y2=$p($p(%parRC,"�",4),",",2)-1
	set y1=y2-($o(msg(""),-1)+1)
	set dx=22  ;dx-ᬥ�.������
	if newid set vars(1)="1�fld(1)"  ;_���
	set vars(2)="1�fld(2)"  ;__������������
	set vars(3)="1�fld(3)"  ;__����� ��� �㡠����
	set desc=0
	;_X,Y,���������,������,������,<none>,?�?,<none>,EndCode,��楤�ࠏ஢�ન,����葨�����
	if newid set desc(1)=(x1+dx)_","_(y1+1)_",5,,,,,,do fillflds^tuSPRSTA,DchkID^"_rtn_",0123456789"
	set desc(2)=(x1+dx)_","_(y1+2)_",30,,,,,,do fillflds^tuSPRSTA,DchkName^"_rtn
	set desc(3)=(x1+dx)_","_(y1+3)_",4,,,,,,do fillflds^tuSPRSTA,DchkAgent^"_rtn_",0123456789"
	;__�᫨ �� ।���஢���� - �।���⥫쭮 �������� ���� ⥪. ���祭�ﬨ
	if newid set fld(1)=lockid
	else  if data'="" do FillData(.fld,data)
	;
	set disp="do DispAgent^"_rtn_"(fld(3))"  ;__��ࢮ���.����஢��
	;
	;__�� 㬮�砭�� - %TFORMA �� ��ࠡ��뢠�� ��५�� �����/����
	;__���⮬� ᫥��� ������頥��� � �����稬 �� ��� ��楤��� UpDn^tuSPRCUR
	set keys=",UP�,DOWN�,�DUpDn^tSTGEN,F10�,F1�,�DHelp^"_rtn

	if $$ZWNS^%W("jkardwin$",x1,y1,x2+1,y2+1)
	if $$^%TMESS(ms_"��0,3"," ������஢���� ����� ��14,3","1�"_x1_","_y1_"�15,3�"_x2_","_y2_"�1")

	;__�뢮��� ��ப� ���᪠��� (��ਠ�� 2)
	if $$ZWNS^%W("helpline$k",2,24,79,24)
	do DrawHlp(2)
	;__����᪠�� ������ ���. ��ࠬ���� �� ���ᠭ�
form	set zz=$$^%TFORMA(disp,0,3,0,7,.vars,.desc,startFld,"�",.keys,"","W $$COFF^%W","")
	;__�᫨ �뫮 ��-� �����ﭮ - ������ ����� �� ��࠭����
	;__���࠭���� ��ࠡ��뢠���� ����� �㭪樨 $$SaveKard
	;__�᫨ १���� ����� - �⬥��, � ��୥��� �� �ࠢ�� ���
	if $g(edited) set saved=$$SaveKard if saved=2 goto form
	if $$ZWNR^%W("helpline$k")
	if $$ZWNK^%W("helpline$k")
	;__���६ ���誮 ��� ��࠭����� �뢮��� ���⮣� ᮮ�饭��
	if $$ZWNR^%W("jkardwin$")
	if $$ZWNK^%W("jkardwin$")
	;;;;  ;__����ᨬ "த�⥫�᪨�" ᯨ᮪ ����ᮢ����� � �멤��
	;;;;  set PR=3
	set unreg=""
	for x=1:1:$o(fld(""),-1) set unreg=unreg_"�"_$g(fld(x))
	lock
	quit:$quit $s(saved:1_unreg,1:0) quit

	;__���������� �����
FillData(fld,data)
	set fld(2)=$p(data,"�",1)
	set fld(3)=$p(data,"�",2)
	quit

	;
	;__����� �� ��࠭���� ��।���஢����� ������ �� 㧫�
	;__� �맮� ��楤��� ��࠭���� �� �⢥न⥫쭮� �⢥�
SaveKard()
	new answ
	if '$$ValidData(.startFld) quit 2
	;__�뢥��� ������ �� �࠭
	set answ=$$D^%WT("���࠭���?","������� ������ ","w",15,1,3)
	if answ=3 quit 2
	if answ=2 quit 0
	;__�᫨ ���짮��⥫� ���⢥न� ��࠭���� - �����⨬ ��࠭����
	do SaveKardData
	quit 1
	;
	;__�맮� ��楤��� ��࠭���� ��।���஢����� ������ �� 㧫�
SaveKardData	
	new data,dataN
	if newid set id=fld(1)
	set data=$s(id="":"",1:$g(@$$Ref@(id)))
	set $p(data,"�",1)=fld(2)
	set $p(data,"�",2)=fld(3)
	set @$$Ref@(id)=data
	;__���࠭���� �����襭�
	quit

	;__�������� ��������� ������ ��᫥ ��室� �� ���
ValidData(fldn)
	if newid,fld(1)="" do M^%WT("�訡��! ��� ���⮩",18,2,"e") set fldn=1 quit 0
	if newid,fld(1)'?4N do M^%WT("�訡��! ��ଠ� ���� ����७ (�.�. 4 ����)",18,2,"e") set fldn=1 quit 0
	if newid,$d(@$$Ref@(fld(1))) do M^%WT("�訡��! ������ ����",18,2,"e") set fldn=1 quit 0
	if newid,$e(fld(1))'=5 do M^%WT("�訡��! ��ࢠ� ��� �.�.'5'",18,2,"e") set fldn=1 quit 0
	if fld(2)'="",$d(@$$Ref@(fld(2))) do M^%WT("�訡��! � �ࠢ�筨�� ��� ����� � ����� "_fld(2),18,2,"e") set fldn=2 quit 0
	quit 1
	;
	;
	;__��楤��, ����� ���⠢��� "������ ���" ��ࠡ��뢠�� ��५��
	;__����� � ����. ����� � P ���� ������� ���� ���室� ⨯�
	;__"���멍��������,���멍��������". �।���⥫쭮 � P ᨤ�� �����
	;__⥪�饣� ����
UpDn	new newfld,flds,oldfld
	set flds=$o(vars(""),-1)
	set oldfld=P
	set newfld=$s(FPtr="UP":oldfld-1,1:oldfld+1)
	if newfld>flds set newfld=1
	if newfld<1 set newfld=flds
	set P=newfld_","_oldfld
	quit
	;
	;
chkID	new zz,lockerr
	set $p(%FPa(1),"�",4)=""
	if (%ZKr="F1")!(%ZKr="F10") xecute true quit
	if X="" do M^%WT("�訡��! ���⮩ ���",18,2,"e") xecute false quit
	if $d(@$$Ref@(X)) do M^%WT("�訡��! ������ ����",18,2,"e") xecute false quit
	if X'?4N do M^%WT("�訡��! ��ଠ� ���� ����७ (�.�. 4 ����)",18,2,"e") xecute false quit
	if $e(X)'=5 do M^%WT("�訡��! ��ࢠ� ��� �.�.'5'",18,2,"e") xecute false quit
	if fld(1)'=X set lockerr=0 do  xecute:lockerr false quit:lockerr  set edited=1
	 . if fld(1)'="" lock -@$$Ref@(fld(1))
	 . lock +@$$Ref@(X):1
	 . else  set zz=$$D^%WT("������ ������ ।������ ��㣮� ���짮��⥫�","  ��  ","inf",18) set lockerr=1
	xecute true
	quit
	;
	;
chkName
	if (%ZKr="F1")!(%ZKr="F10") xecute true quit
	if X="" do M^%WT("�訡��! ��易⥫�� ४�����!",18,2,"e") xecute false quit
	if fld(2)'=X set edited=1
	xecute true
	quit
	;
	;
chkAgent
	if (%ZKr="F1")!(%ZKr="F10") xecute true quit
	if X="" do DispAgent(X) set:fld(3)'=X edited=1 xecute true quit
	if X'?4N do M^%WT("�訡��! ������ ���� ����, ��ࢠ� �.� = '5'",18,2,"e") xecute false quit
	if '$d(@$$Ref@(X)) do M^%WT("�訡��! ��� � �ࠢ�筨�� ����⮢ (F10)",18,2,"e") xecute false quit
	if id'="",id=X do M^%WT("�訡��! �� ����� ���� ����⮬ ᠬ��� ᥡ�",18,2,"e") xecute false quit
	if $p(@$$Ref@(X),"�",2)'="" do M^%WT("�訡��! �㡠���� �� �.�. ����⮬",18,2,"e") xecute false quit
	if fld(3)'=X set edited=1
	do DispAgent(X)
	xecute true
	quit

DispAgent(code)
	new x,y
	set x=$p(%FPa(3),",",1)+$p(%FPa(3),",",3),y=$p(%FPa(3),",",2)
	write $$TA^%W(0,%FPFP),$$CUP^%W(y,x),$$S^%W($$JE^%WT($s(code="":"",1:"-"_$p(@$$Ref@(code),"�",1)),24))
	quit


Help	new name
	set name="Help"_$p($p(%prov,"Dchk",2),"(",1)
	do @name
	quit

HelpName
	new msg
	set msg(1)="����� �������� ������������ �����"
	set msg(3)="   ** ������ ���� ������� **"
	do M^%WT(.msg,17,0,"helpcolor")
	quit

HelpID
	new msg
	set msg(1)="    ����� �������� ��� �����.      "
	set msg(2)="����� ����, ��ࢠ� ��� �.� = '5'"
	set msg(4)="   ** ������ ���� ������� **"
	do M^%WT(.msg,17,0,"helpcolor")
	quit

HelpAgent
	new val
	set val=$$Dict^tuSPRAGN(,,"if $p($g(@%ch@(k)),""�"",2)=""""")
	if val="" quit
	set X=val
	do DispAgent(X)
	quit

	;__��楤�� ���᪠ �����
Search	new stat,keycfg,key,name,x,y,len,cf,cb,xend,xver,par,ins,patt,code,msg,fnd,nval,answ
	set PR=0
	;__� ��६����� k ᨤ�� ⥪�騩 ������ � "த�⥫�᪮�" ᯨ᪥
	set code=$g(k)
	if %ZK="NOKEY" set:(%Kc?1.N)!(%Kc?1"*") answ=1,val=%Kc set:(%Kc'?1.N)&(%Kc'?1"*") answ=2,val=%Kc
	else  set answ=$p($g(%finder),$c(30),1),val=$p($g(%finder),$c(30),2) do  if answ=0 quit
	 . set msg(1)=$j("",14)_"��� �㤥� �᪠��?"_$j("",14)
	 . if answ'>0 set answ=1
	 . set answ=$$D^%WT(.msg,"[     � �����     ]�[ � ������������� ]","info",15,answ)
	set msg(1)="�᪠��:                                   "
	if answ=1 set msg(2)="����� 㪠���� '*' � ��砫� ��� ���� ���� "
	if answ=2 set msg(2)=""
	set msg(3)="                                          "
	set msg(4)="  ��� ����� �⮣� ���᪠ ������ Ctrl+F "
	set x=27,y=15,len=34
	set cf=0,cb=7
	set keycfg=",DOWN�,�XS PR=1,"
	set xend="",xver=""
	set ins=1,patt=""
	do M^%WT(.msg,14,"$listsearch$","s"," ���� "_$s(answ=1:"����",1:"⥪��")_" �� �ࠢ�筨�� ")
	for  do  quit:((val'="")&((key="ENTER")!(key="DOWN")))!(key="ESC")
	 . set key=keycfg
	 . set val=$$^%TREAD(x,y,len,cf,cb,ins,val_$c(254),.key,xend,xver,patt)
	if $$ZWNR^%W("$listsearch$")
	if $$ZWNK^%W("$listsearch$")
	write $$COFF^%W
	if ((key'="ENTER")&(key'="DOWN"))!(val="") quit
	set %finder=answ_$c(30)_val
	set fnd=$$Finder(%choi,.code,%finder)
	if 'fnd quit
	set k=code
	set PR=3,Index=k
	quit

ReFind	new code,val
	set PR=0
	set code=$g(k)
	set val=$g(%finder)
	if $p(val,$c(30),2)="" quit
	set fnd=$$Finder(%choi,.code,val)
	if 'fnd quit
	set k=code
	set PR=3,Index=k
	quit

Finder(ref,code,finder)
	new fnd,val,type,fr,rc,name
	set val=$p(finder,$c(30),2)
	set type=$p(finder,$c(30),1)
	set fnd=0
	do
	 . if type=1,val?1.ULN1"*" set fr=$p(val,"*",1) for  set code=$o(@ref@(code)) quit:code=""  if $e(code,1,$l(fr))=fr set fnd=1 quit
	 . if type=1,val?1"*"1.ULN set fr=$p(val,"*",2) for  set code=$o(@ref@(code)) quit:code=""  if $e(code,$l(code)-$l(fr)+1,$l(code))=fr set fnd=1 quit
	 . if type=1,val?1.ULN for  set code=$o(@ref@(code)) quit:code=""  if code=val set fnd=1 quit
	 . if type=2 for  set code=$o(@ref@(code)) quit:code=""  set name=@ref@(code) if name[val set fnd=1 quit
	if 'fnd set stat=$$D^%WT("   �� �������   "," OK ","info",16) quit 0
	quit 1

	;__����� ���� �뢮� ���᪠��� � ��ப� ����� �࠭�
	;__� ��㬥�� ��।����� ��ਠ�� ���᪠���
DrawHlp(n)	
	set n=$g(n,1)
	if n=1 write $$TA^%W(0,7),$$CUP^%W(24,2),$$S^%W("F2-���멳                      �F4-������஢���F7-���᪳F8-�������Esc-��室") quit
	if n=2 write $$TA^%W(0,7),$$CUP^%W(24,2),$$S^%W("F1,F10-���᪠��� �Enter-���� �Up/Down-��६�饭���Ins-��⠢��/�������Esc-��室") quit
	if n=3 write $$TA^%W(0,7),$$CUP^%W(24,2),$$S^%W("             �           �              �                �          �         ") quit
	if n=4 write $$TA^%W(0,3),$$CUP^%W(24,2),$$S^%W("�nter-�����F2-���멳                 �F4-������஢���F8-�������Esc-��室") quit
	if n=5 write $$TA^%W(0,3),$$CUP^%W(24,2),$$S^%W("�nter-�����F7-����   �                �          �              �Esc-��室") quit
	quit

