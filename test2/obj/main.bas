10 rem ******************************
20 rem Program:  Laberinto
30 rem autor:    MSX Murcia
40 rem ******************************
45 print "Ejecutando instrucciones"
50 defint a-z: DEFUSR1=&H41:DEFUSR2=&H44
60 'ON STRIG GOSUB 1530
70 'sprite on:ON SPRITE GOSUB 2000
80 gosub 8000
90 gosub 8100
100 gosub 8500
120 gosub 5000
130 gosub 6000
140 gosub 6100:ex(1)=8*12:ey(1)=6*20:ev(1)=8:es(1)=4
150 gosub 6100:ex(2)=8*18:ey(2)=8*6:ev(2)=8:es(2)=4
160 gosub 6100:ex(3)=8*14:ey(3)=8*8:ev(3)=8:es(3)=6
170 'gosub 6100:ex(4)=8*30:ey(4)=8*10:el(4)=8:es(3)=6
    400 gosub 1260
    430 gosub 1760
    440 gosub 1400
    450 gosub 1900
500 goto 400 
1260 '' <<<< INPUT SYSTEM >>>>
    1265 'nada'
    1270 ST=STICK(0) OR STICK(1) OR STICK(2)
    1280 'TG=STRIG(0) OR STRIG(1) OR STRIG(2)
    1300 xp=x:yp=y
    1320 IF ST=7 THEN x=x-pv:pp=3
    1330 IF ST=3 THEN x=x+pv:pp=2
    1340 IF ST=1 THEN y=y-pv:pp=0
    1350 IF ST=5 THEN y=y+pv:pp=1
    1370 if x<=0 then x=xp
    1380 if y<=0 then y=yp
    1385 if y+ph>192 then y=yp
    1390 if x+pw>252 then x=xp
1395 RETURN
1400 '' <<< RENDER SYSTEM >>>>
    1420 PUT SPRITE 0,(x,y),1,pp
    1430 for i=1 to en-1
        1440 es(i)=es(i)+1 
        1450 if es(i)>5 and i=1 then es(i)=4
        1460 if es(i)>5 and i=2 then es(i)=4
        1470 if es(i)>7 and i=3 then es(i)=6
        1480 if es(i)>7 and i=4 then es(i)=6
        1490 PUT SPRITE 4+i,(ex(i),ey(i)),10,es(i)
    1495 next i
    1500 if ms >5 then mw=mw+1:ms=0:mc=1:gosub 8100
    1510 if mc then gosub 8500
1520 return
    1760 hl=base(5)+(y/8)*32+(x/8):a=vpeek(hl)
    1770 if a=224 then x=xp: y=yp
    1780 if a=204 then x=8*16: y=8*18:beep
    1790 if a=215 then mc=1:ms=ms+1
    1800 if pc=1 then pc=0:sprite on
    1810 for i=0 to en-1
        1820 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1830 if a=224 then ev(i)=-ev(i):el(i)=-el(i):ex(i)=ep(i):ey(i)=ei(i)
        1840 ep(i)=ex(i):ei(i)=ey(i)   
    1860 next i
1870 return
    1900 for i=0 to en-1
        1910 ex(i)=ex(i)+ev(i):ey(i)=ey(i)+el(i)
    1920 next i
1930 return
    2000 'if pe=0 then gosub 5000
    2010 sprite off:pe=pe-1:gosub 3000:beep:gosub 5100:pc=1
2090 return
    3000 locate 0,0: print "Level "mw"-"ms" v: "pe" "ti
    3010 'locate 0,23: print "MEMSIZ: "peek(&hF672)", free:"fre(0)
    3020 'locate 0,21: print "x "x" y"y
3030 return
    5000 x=8:y=16:xp=0:yp=0:pw=8:ph=8:pv=8:pe=10:pc=0
5020 return
    5100 if ms=0 then x=8:y=16
    5110 if ms=1 then x=21:y=16
5190 return
    6000 en=1
    6020 ex(0)=0:ey(0)=0:ep(0)=0:ei(0)=0
    6030 ev(0)=0:el(0)=0
    6040 ew(0)=8:eh(0)=8:es(0)=5
    6050 ee(0)=100
6060 return
    6100 ex(en)=ex(0):ey(en)=ey(0):ep(en)=ep(0):ei(0)=ei(0)
    6120 ev(en)=ev(0):el(en)=el(0)
    6130 ew(en)=ew(0):eh(en)=eh(0):es(en)=es(0)
    6140 ee(en)=ee(0)
    6150 en=en+1
6160 return
    5100 if ms=0 then x=8:y=16
    5110 if ms=1 then x=21:y=16
5190 return
    8000 mw=0:ms=0:mm=6:mc=0:tn=0
    8010 dim m(23,31,mm-1)
8020 return
    8100 md=&hc001:locate 0,0:print "Cargando mundo...          "
    8110 if mw=0 then bload"word0.bin",r
    8120 if mw=1 then bload"word1.bin",r
    8130 for i=0 to mm-1
        8140 for f=0 to 21
            8150 for c=0 to 31
                8160 m(f,c,i)=peek(md):md=md+1
            8170 next c
        8180 next f
    8190 next i
8200 return
    8500 cls:mc=0
    8505 a=usr1(0)
    8510 locate 0,0:print "Cargando nivel              "
    8520 _TURBO ON (tn,m(),ms,mm)
    8530 for i=0 to mm-1 
        8540 for f=0 to 21
            8550 for c=0 to 31
                8560 'ms=0
                8560 tn= m(f,c,ms)
                8565 'print tn;
                8570 if tn=1 then locate c, f:print chr$(224)
                8580 if tn=2 then locate c, f:print chr$(204)
                8590 if tn=3 then locate c, f:print chr$(215)
            8600 next c
        8610 next f
    8620 next i
    8630 _TURBO off
    8635 a=usr2(0)
    8640 gosub 3000
8650 return
