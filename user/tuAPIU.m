tuAPIU	; API UTILS

StName(code,lang)
	new StName,fldn
	if $g(code)="" quit ""
	set lang=$$LA^%WT($g(lang))
	set fldn=$s(lang="en":5,lang="ru":10,1:2)
	set StName=$p($g(^tSTGEN(code)),"þ",fldn)
	if StName="" set StName=$g(^tST(code))
	quit StName

StAddr(code,lang)
	new StName,fldn
	if $g(code)="" quit ""
	set lang=$$LA^%WT($g(lang))
	set fldn=$s(lang="en":8,lang="ru":7,1:6)
	set StName=$p($g(^tSTGEN(code)),"þ",fldn)
	quit StName

CarrierName(code,lang)
	new Name,fldn
	if $g(code)="" quit ""
	set lang=$$LA^%WT($g(lang))
	set fldn=$s(lang="en":2,lang="ru":2,1:2)
	set Name=$p($g(^tAP(code)),"þ",fldn)
	quit Name

InsurName(code,lang)
	new Name,fldn
	if $g(code)="" quit ""
	set lang=$$LA^%WT($g(lang))
	set fldn=$s(lang="en":2,lang="ru":2,1:2)
	set Name=$p($g(^tSK(code)),"þ",fldn)
	quit Name

XMLDT2H(dt)
	new y,m,d,h,n,s
	set y=$p($p(dt," ",1),"-",1)
	set m=$p($p(dt," ",1),"-",2)
	set d=$p($p(dt," ",1),"-",3)
	set h=$p($p(dt," ",2),":",1)
	set n=$p($p(dt," ",2),":",2)
	set s=$p($p(dt," ",2),":",3)
	set res=$$IN^%WH(m_"/"_d_"/"_y)
	set res=res_","_((h*3600)+(m*60)+s)
	quit res

XMLDT2Sec(dt)
	new y,m,d,h,n,s
	set y=$p($p(dt," ",1),"-",1)
	set m=$p($p(dt," ",1),"-",2)
	set d=$p($p(dt," ",1),"-",3)
	set h=$p($p(dt," ",2),":",1)
	set n=$p($p(dt," ",2),":",2)
	set s=$p($p(dt," ",2),":",3)
	set res=($$IN^%WH(m_"/"_d_"/"_y)*86400)+(h*3600)+(m*60)+s
	quit res
