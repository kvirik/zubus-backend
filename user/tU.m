tU	;������⥪� �㭪権 ��� ३ᮢ;27.01.11;v.1.7
	;_v.1.7_27.01.11_�㪢���� ����� ३ᮢ �.�.
	;_v.1.6_14.07.10_��������� DB
	;_v.1.5_29.07.09_㭨���ᠫ쭮 ��� ����� � ���쪮��
	;_v.1.4_23.12.08_��������� $$OurKas, $$SysKas
	;_v.1.3_23.04.08_��� �⪠�� �� tSPVR, ��������� ��ࠬ���� 6 � 7 � $$VR
	;_v.1.2_22.02.08_��७�ᥭ tUTL (tUTL - ����� ��� !)
	;_v.1.1_01.10.07_��ࠢ����� �� ������ �������稢���� (�. $$nVR^tU(VR))
	Q
	;
	;---�஢�ઠ �⠫��� (�����頥� 1, �᫨ ����)
ELRE(VR,DB)
	N D
	set DB=$g(DB)
	S D="" F  S D=$O(^|DB|tEL(D)) Q:D=""  I $D(^|DB|tEL(D,VR)) Q
	Q $T
	;
	;---�஢�ઠ 室���� ��� ^tEL (�����頥� 1, �᫨ ����)
MSRE(VR,DB)
	N D
	set DB=$g(DB)
	S D=+$h F  S D=$O(^|DB|tMS(D)) Q:D=""  I $D(^|DB|tMS(D,VR)) Q
	Q $T
	;---��������� �� VR
VR(VR,p,raz,DB)
	; VR -����� ����� ३�
	; raz-ᨬ���-ࠧ����⥫�
	; p  -��ࠬ��� ����� ��ப�
	;     1-��� �ଠ�஢����                     {9:30�20�St1-St2�R}
	;     2-��.��. �� ������ ���               { 9:30�   20�[St1  ]-[St2  ]�R}
	;   * 3-��.��. �� 業��� (㬮�砭��)        { 9:30�   20�[  St1]-[St2  ]�R}
	;     4-��.��. �� ���. ��� � ࠧ����⥫��  { 9:30�   20� [St1  ]- [St2  ]�R}
	;       (� �������⥫�� �஡���� ᫥��!)
	;     5-��.��. �� 業��� � ࠧ����⥫��     { 9:30�   20�[  St1]�[St2  ]�R}
	;     6-��.��. �� 業��� � [ - ]            { 9:30�   20�[  St1] - [St2  ]�R}
	;     7-��� �ଠ�஢���� � ࠧ����⥫��      {9:30�20�St1�St2�R}
	;       (��� ������ tSPVR)	
	;     8-��� �ଠ�஢���� � ࠧ����⥫�� � ����� {9:30�20�StCode1�StCode2�R}
	N v,r,R,St1,St2,l,zp,tRE
	Q:VR="" ""
	S VR=$$nVR(VR)
	set DB=$g(DB)
	I '$D(^|DB|tRE(VR)) Q ""
	S zp=$g(%),%="�"
	S:$G(raz)="" raz=%
	S:$G(p)=""!(p>8) p=3
	S tRE=$G(^|DB|tRE(VR)) I tRE="" Q "" 
	S l=12 ;����� �⠭樨
	S v=$$VRv(VR)\60,v=v\60_":"_(v#60\10)_(v#10)
	S r=$$VRr(VR)
	S St2=$p(tRE,%,2),St1=$S($p(tRE,%,3)'="":$p(tRE,%,3),1:$p(tRE,%,1))
	I p'=8 S St1=$E(^|DB|tST(St1),1,l),St2=$E(^|DB|tST(St2),1,l)
	S R=$p(tRE,%,4)
	I p'=8 S R=$S($E(R)=2:$E(R,2,8),1:$E(^|DB|tREG($E(R)),1,7))
	S R=R_$J("",7-$L(R))
	S %=zp
	;
	;_______ ���⮩ �뢮� ______________________________________________________
	I p=1 Q v_raz_r_raz_St1_"-"_St2_raz_R
	;_______ �ଠ�஢���� �⠭権 �� ������ ��� ______________________________
	I p=2 Q $J(v,5)_raz_$J(r,5)_raz_St1_$J("",l-$L(St1))_"-"_St2_$J("",l-$L(St2))_raz_R
	;_______ �ଠ�஢���� �⠭権 �� 業��� ___________________________________
	I p=3 Q $J(v,5)_raz_$J(r,5)_raz_$J(St1,l)_"-"_St2_$J("",l-$L(St2))_raz_R
	;_______ �ଠ�஢���� �⠭権 �� ������ ��� � ࠧ����⥫�� _______________
	;   (� �������⥫�� �஡���� ᫥�� !)
	I p=4 Q $J(v,5)_raz_$J(r,5)_raz_" "_St1_$J("",l-$L(St1))_raz_" "_St2_$J("",l-$L(St2))_raz_R
	;_______ �ଠ�஢���� �⠭権 �� 業��� � ࠧ����⥫�� ____________________
	I p=5 Q $J(v,5)_raz_$J(r,5)_raz_$J(St1,l)_raz_St2_$J("",l-$L(St2))_raz_R
	;_______ �ଠ�஢���� �⠭権 �� 業��� � �஡����� [ - ] _________________
	I p=6 Q $J(v,5)_raz_$J(r,5)_raz_$J(St1,l)_" - "_St2_$J("",l-$L(St2))_raz_R
	;_______ ���⮩ �뢮� � ࠧ����⥫ﬨ ______________________________________
	I p=7 Q v_raz_r_raz_St1_raz_St2_raz_R
	;_______ ���⮩ �뢮� � ࠧ����⥫ﬨ � � �����_____________________________
	I p=8 Q v_raz_r_raz_St1_raz_St2_raz_R
	;____________________________________________________________________________
	Q ""
	;
	;__�८�ࠧ������ � ॠ��� ३� (��� ᥪ㭤 �� �������稢����)
nVR(VR)	
	Q:$l(VR)>10 VR  ;_�� ��쪮�᪨� ३�
	n o,v
	set o=$S($e(VR)?1N:"",1:$e(VR))
	set v=$e(VR,$s(o="":1,1:2),$l(VR)-4)\60*60
	Q o_$s(o="":v,1:$tr($j(v,5)," ","0"))_$e(VR,$l(VR)-3,$l(VR))
	;
	;__�஢�ઠ �� ॠ��� ३� (��� ᥪ㭤 �� �������稢����). 1-ॠ���
RealVR(VR)
	N t S t=$e(VR,$s($e(VR)?1N:1,1:2),$l(VR)-4) Q (t#60)=0
	;
	;__�����祭�� �६��� �� ������� ����� ३�
VRv(VR)	Q +$s($e(VR)'?1N:$e(VR,2,6),$l(VR)>9:$e(VR,1,5),1:$e(VR,1,$L(VR)-4))
	;
	;__�����祭�� ����� ३� �� ������� ����� ३�
VRr(VR)
	I $l(VR)'>10 S r=$S(VR["O":"O"_$E(VR,7,10),1:$E(VR,$L(VR)-3,$L(VR))) S:r?4N r=+r ;_�����
	I $l(VR)>10 S r=$tr($e(VR,$l(VR)-5,$l(VR))," ") S:$e(VR)'?1N r=$e(VR)_$j(r,4) S:$l(r)>5 r=$e(r,1,5) ;_���쪮�	
	Q r
	;
	;__�८�ࠧ������ ������� ����� � ���� �६�_raz_३�
VRS(VR,raz)
	N v,r
	S:$G(raz)="" raz="�"
	S v=$$VRv(VR)\60,v=v\60_":"_(v#60\10)_(v#10)
	S r=$$VRr(VR)
	Q v_raz_r
	;
tUTL	;;���୨� ࠧ��� ���� �㭪権; ���ਪ���� �.�.(�); ���. 1.0; ����� 2006
	quit
	;__�� �� ������ ��᫥ �襭�� ������ ������⢮ �����⥬
	;__�� ����� ��墠� �������⥫쭮�� ����� �� ���� ��⥬�
	;
	;__��� ��� �㭪権, ����⨥ 
	;_____"������⥬�" �� ���� ���� ��⥬� + ��� �����⥬�, �ᥣ� �� 0 �� 3 ������
	;_____"������짮�" �� ��� ���짮��⥫� ஢�� 3 �����
	;
	;__�஢�ઠ - ��� �� �����⥬�
	;___� Sp ᨤ�� ������ ⨯� "������⥬�" (0-3 �����)
OurSys(Sp,DB)
	if $g(Sp)="" quit 0
	set DB=$g(DB)
	set Sp=$tr($j(Sp,3)," ",0)
	quit Sp=^|DB|tTSYS
	;
	;__�஢�ઠ - ��� �� ���짮��⥫� (1-���)
	;___� User ᨤ�� ������ ⨯� "������⥬�"_"������짮�"
OurUser(User,DB)
	new sp
	if $g(User)="" quit 0
	set sp=$tr($j($e(User,1,$l(User)-3),3)," ",0)
	if sp="" quit 0
	set DB=$g(DB)
	quit sp=^|DB|tTSYS
	;
	;__�஢�ઠ - ��� �� ����� � ����� (1-���)
	;___� User ᨤ�� ������ ⨯� "������⥬�"_"������짮�"_"��᫥���� 5 ������ �����"
OurKas(User,DB)
	new sp
	if $g(User)="" quit 0
	set DB=$g(DB)
	set sp=$tr($j($e(User,1,$l(User)-8),3)," ",0)
	if sp="" quit 0
	quit sp=^|DB|tTSYS
	;
	;__������ ����� ��⥬� (���⪮��) �� ����� ����� (11 ᨬ�����)
SysKas(N)
	if $g(N)="" quit ""
	quit +$e(N,1,$l(N)-8)
	;
	;__��� ३ᮢ � �㪢��� �� ��쪮��
extr(r)	;__��१��� �஡��� ᫥��
	quit $$SL^%WT(r)
	;
	;__��ନ஢���� "��������" ����� ��⨪㫮� ��� ���ᮢ��� ������
MarArtic(Name,Group)
	if $$INFO^%WPRN(4)<3 quit ""
	if $tr($g(Name)," ")="" quit ""
	if $g(Group)="" quit ""
	if $d(^tART(Name,Group))#10 quit $$FormatArticul(^tART(Name,Group))
	set ^tART(Name,Group)=$i(^tART("%CNT"))
	quit $$FormatArticul(^tART(Name,Group))
	;
FormatArticul(art)
	set art=$tr($j(art,4)," ",0)
	quit $tr($e(art),"012345","012345")_$e(art,2,$l(art))
	;
	;
	;__���� �⠭�� � �ਢ離�� � ࠡ�祬� �����
SelfST()
	new id set id=$$ID^%WNET
	quit $g(^tTSYS("S",id),$g(^tTSYS("S")))
