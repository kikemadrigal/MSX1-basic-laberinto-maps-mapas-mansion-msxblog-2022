10 rem ******************************
20 rem Program:  Laberinto
30 rem autor:    MSX Murcia
40 rem ******************************
45 print "!Ejecutando instrucciones"
1 'Inicilizamos el juego'
1 'Inicilizamos dispositivo: 003B, inicilizamos teclado: 003E'
1 '46 defusr=&h003B:a=usr(0):defusr1=&h003E:a=usr1(0):defusr2=&H90:a=usr2(0)
50 defint a-z: DEFUSR1=&H41:DEFUSR2=&H44
1 'Cuando se pulse el espacio o el disparo del joystick elegimos una de las herramientas'
60 strig(0) on:on strig gosub 7100
1 'Cuando haya colisión de sprites ir a la subrutina de la linea 1750'
70 'sprite on:ON SPRITE GOSUB 2000
1 'Esto es necesario para escribir en pantalla'
80 screen 2,0,0
85 color 1,15,7:key off
87 open "grp:" as #1:gosub 3000
90 print #1,"!Cargando sprites"
1 ' inicializamos los sprites'
100 gosub 20870
1 'Mostramos la pantalla de bienvenida e instrucciones'
110 cls: preset (0,0):print #1,"!Debes de ingeniar como salir del laberinto con las herramientas que tienes"
125 print #1,"!Pero solo las puedes usar una vez"
1 'Pintamos los objetos'
126 gosub 3100
127 preset (0,21*8):print #1,"!Pulsa una tecla para continuar"
128 if inkey$="" then goto 126 else cls
129 'a=usr1(0)
1 ' Inicializamos los gráficos'
130 print "!Cargando graficos"
145 gosub 30000
1 ' Pintamos el mapa'
200 gosub 9000
201 'a=usr2(0)
1 ' Mostramos el marcador'
205 gosub 3000
1 'Inicializamoz los objetos'
206 gosub 7000
1 'Pintamos los objetos'
207 gosub 3100
1 ' inicilizamos el personaje'
210 gosub 5000
1 ' inicilizamos los eneminos con el manager'
220 gosub 6000
1 'posicionamos al player y enemigos tras cargar el mapa'
230 gosub 8300


1 ' <<<<<< Main loop >>>>>'
    1 'Actualizamos el sistema de input'
    400 gosub 1260
    1 'Actualizamos el sistema de fisicas y colisiones'
    430 gosub 1760
    1 'Actualizamos sistema del render
    440 gosub 1400

    1 'Si el mapa seleccionado es mayor que 5 cambiamos el mundo llamando a la subrrutina 8100'
    1 'Si el mapa cambia volvemos a pintar un nuevo mapa con 8500
    1 'y ponemos al player en su posición del mapa seleccionado'
    460 if ms >5 then mw=mw+1:ms=0:mc=1:'gosub 8100
    570 if mc then gosub 9000
500 goto 400 
1 ' <<<<<< Final del Main loop >>>>>'



1' <<<< INPUT SYSTEM >>>>
    1260 ST=STICK(0) OR STICK(1) OR STICK(2)
    1 'xp= posicion x previa player, yp=posición y previaplayer'
    1 'Conservamos la posición previa para las colisiones'
    1300 xp=x:yp=y
    1 'pv=player velocidad, pp=plano player, pc= layer columna y pf=player fila'
    1'1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
    1310 on st goto 1320,1310,1330,1310,1340,1310,1350
    1315 goto 1370
    1320 y=y-pv:pp=0:re=9:gosub 4000:goto 1370
    1330 x=x+pv:pp=2:re=9:gosub 4000:goto 1370
    1340 y=y+pv:pp=1:re=9:gosub 4000:goto 1370
    1350 x=x-pv:pp=3:re=9:gosub 4000:goto 1370

    1 'Colisones con los extremos de la pantalla'
    1370 if x<=0 then x=xp
    1380 if y<=0 then y=yp
    1385 if y+ph>192 then y=yp
    1390 if x+pw>252 then x=xp
1395 RETURN





1 '' <<< RENDER SYSTEM >>>>
    1 'Pintamos de nuevo el player con la posición, el color y el plano(dibujitos de izquierda, derecha..)'
    1400 PUT SPRITE 0,(x,y),15,pp
    1410 if en=0 then return
    1 'dibujamos los enemigos, sin el for ser ve más claro'
    1430 for i=1 to en
        1 'Esto es para animar los muñegotes'
        1440 ec(i)=ec(i)+1:if ec(i)>1 then ec(i)=0
        1450 if et(i)=0 then if ec(i)=0 then es(i)=5 else es(i)=6
        1460 if et(i)=1 then if ec(i)=0 then es(i)=7 else es(i)=8
        1 'Nuestros enemigos son el sprite 5 en adelante'
        1490 PUT SPRITE 4+i,(ex(i),ey(i)),,es(i)
    1495 next i
1520 return




1' '' <<< PHYSICS & COLLISION SYSTEM >>>>
    1 'Colisiones del player con el mapa'
    1 'Para detectar la colisión vemos el valor que hay en la tabla de nombres de la VRAM
    1 'En la posición x e y de nuestro player con la formula: '
    1 'Si hay una colision le dejamos la posicion que guardamos antes de cambiarla por pulsar una tecla'
    1760 hl=base(5)+(y/8)*32+(x/8):a=vpeek(hl)
    1 'Si es un tile sólido volvemos a la posición que estábamos
    1770 if a>0 and a<8 then x=xp: y=yp
    1 'Si el valor es un 2, es nuestro punto de fuga lo mandamos a otro sitio '
    1780 'if a=2 then x=8*16: y=8*18:beep
    1 ' Si el valor es un 3 (el tiled de la meta) cambiamos de mapa'
    1790 if a=8 then mc=1:ms=ms+1
    1 'Colisiones del player con sprites de los enemigos (mirar línea 70 y 2000)'
    1800 if pc=1 then pc=0:sprite on

    1 'Fisica y Colisiones de ememigos con el mapa'
    1810 for i=1 to en
        1820 if et(i)=0 then ex(i)=ex(i)+ev(i)
        1830 if et(i)=1 then ey(i)=ey(i)+el(i)
        1840 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1 'ev es la vlocidad eje x y el es la velocidad eje y'
        1 'Si es una pared le invertimos la velocidad del eje x y del eje y'
        1 'y le volvemos a poner las coordenadas antiuas '
        1 'ev=velocidad x y el velocidad eje y '
        1 'ep coordenada previa x , ei=coordenada previa y'
        1850 if a>0 and a<8 then if et(i)=0 then ev(i)=-ev(i):ex(i)=ep(i):ey(i)=ei(i) else if et(i)=1 then el(i)=-el(i):ex(i)=ep(i):ey(i)=ei(i)
        1 'Conservamos los datos de las posiciones antes de cambiarlos'
        1860 ep(i)=ex(i):ei(i)=ey(i)   
    1870 next i
1890 return



1 'Cuando 2 sprites colisionan...'
1 'Si no tiene vidas salimos del juego'
    2000 if pe=0 then gosub 5000
    1 'Por ultimo volvemos a poner nuestro personaje en la posición del mapa inicial'
    1 'Actualizamos la variable player colision que nos ayuda a activar la colisiones (linea 1800)'
    2010 sprite off:pe=pe-1:gosub 3000:beep:pc=1
2090 return

1 'informacion del juego que aparece en l aparte superior'
    3000 line (21*8,0)-(23*8,20*8),14,bf
    3010 line (24*8,0)-(247,20*8),14,bf
    3020 preset (25*8,3*8): print #1,"World"
    3030 preset (26*8,5*8): print #1,mw
    3040 preset (25*8,7*8): print #1,"Level"
    3050 preset (26*8,9*8): print #1,ms
    3060 preset (25*8,11*8): print #1,"Live"
    3070 preset (26*8,13*8): print #1,pe
    3075 preset (24*8,15*8): print #1,en
    3080 preset (24*8,17*8): print #1,fre(0)
3090 return

1 'pintar objetos
    3100 PUT SPRITE 11,((22*8)-4,5*8),6,10
    3120 PUT SPRITE 12,((22*8)-4,7*8),6,11
    3130 PUT SPRITE 13,((22*8)-4,9*8),6,12
    3140 PUT SPRITE 14,((22*8)-4,11*8),6,13
3190 return


1 'Reproductor de efectos d sonido'
    1 'play, c=do, d=re, e=mi, f=fa, g=sol, a=la, b=si
    1 'xvariable$, ejecuta el string que contiene variable$'
    1 'nx, número nota musical del do al si,siendo x un número entre 0-96, de la 0 octava (0-12) a la 8 octava (80-92), por defecto está la 4 octava (36-47) '
    1 'on, siedo n la octava entre 0-8'
    1 'ln, siendo n la duración de 0-64, 64 la más corta'
    1 'rn, siendo n la pausa entre 1-64, 64 las más corta'
    1 'tn, siendo n la velocidad de ejecución entre 32-255 (ni caso)'
    1 'Vn, siendo v el volumen entre 0-15'
    1 'Mn, sindo n la modulación de la envolvente entre 0-6535 (ni caso)'
    1 'Sn, siendo n la forma de la enfolvente de 0-15, sirve para que vaya desapareciendo el sonido
    1 'Melodía completa'
    1 '2300 if re=1 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A D E F G E F D C D G R8 O5 A2 A2 A8"
    4000 if re=1 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A r60 G E F D C D G R8 A2 A2 A8","o1 v4 c r8 o2 c r8 o1 v6 c r8 o2 v4 c r8 o1 c r8 o2 v6 c r8"
    1 'Tirando el paquete'
    4010 if re=5 then play "l10 o4 v4 g c"
    1 'Paquete cogido'
    4020 if re=6 then play"t250 o5 v12 d v9 e" 
    1 'Pitido normal'
    4030 if re=7 then play "O5 L8 V4 M8000 A A D F G2 A A A A"
    1 'Toque fino'
    4040 if re=8 then PLAY"S1M2000T150O7C32"
   
    1 'Pasos'
    4050 if re=9 then PLAY"o2 l64 t255 v4 m6500 c"
    1 'Sound puerto, valor, para ver las notas ir a https://www.msx.org/wiki/SOUND, recuerda que el d5dh=3421 es el 34 para el tono canal a puerto 1 y en puerto 0 21'
    1 '0=Tono canal a bit menos significativo,2=tono canal b menos significativo, 4=tono canal c menos significativo de 0-255
    1 '1=Tono canal a bit mas significativo, 3=tono canal b bit mas significativo, 5=tono canal c bit mas significativo de 0 a 15 
    1 '6 ruido de 0-31
    1' 7 mezlador 0-191
    1 '8 volumen canal a, 9 volumen canal b, 10 volumen canal c de 0-16'
    1 '12 velocidad envolvente de 0-255
    1 '13 forma envolmente para que desaparezca en el tiempo la nota de 0-15'
    1 'En este ejemplo trabajamos solo con el ruido, el 6, el 8 =16 significa que vamos a variar el volumen con el 12 y el 13 para que desaparezca'
    1 'Paquete ha explotado'
    4060 if re=10 then sound 6,5:sound 8,16:sound 12,6:sound 13,9
    1 'Volvemos a dejar el psg como estaba'
    4070 'for i=0 to 100: next i: a=usr2(0)
4090 return






























1 '---------------------------------------------------------'
1 '------------------------PLAYER---------------------------'
1 '---------------------------------------------------------'

1 ' Inicializando el personaje'
    1 ' x=pisicon x previa, utilizada en el sistema de input'
    1 ' y= posicion y previa, utilizada en el sistema de input'
    1 ' pe=player energy o vida
    1 'Player colision, se utiliza para habilitar el sprite on cuando hay una colision'
    5000 x=0:y=0:xp=0:yp=0:pw=8:ph=8:pv=8:pe=10:pc=0
5020 return



1 '---------------------------------------------------------'
1 '------------------------ENEMIES MANAGAER------------------'
1 '---------------------------------------------------------'
1 'Init'


1 'et=turno de enemigo'
1 'en=numero de enemigo'
1 'Componente de posicion'
    1 'ex=coordenada x, ey=coordenada y', ep=coordenada previa x, ei=coordenada previa y
1 'Componente de fisica'
    1 'ev=velocidad enemigo eje x, el=velocidad eje y'
1 'Componente de render'
    1 'ew=ancho enemigo, eh= alto enemigo, es=enemigo sprite, ec=enemigo contador, utlizado para hacer la animación'
1 'Componente RPG'
    1 'ee=enemigo energia,et=enemigo tipo, determina su comportamiento '
    6000 em=5
    1 ' Component position'
    6010 DIM ex(em),ey(em),ep(em),ei(em)
    1 ' Compenent phisics'
    6020 DIM ev(em),el(em)
    1 ' Component render'
    6030 DIM ew(em),eh(em),es(em),ec(em)
    1 ' Component RPG'
    6040 DIM ee(em)
    6050 en=0
6099 return

1 ' Crear enemigo'
    1 'Como el espacio en la memoria lo creamos en el loader, ahora rellenamos, 
    1 'el dibujado lo hacemos en el render '
    1 'Aqui le asignamos el sprite que será el definido en el lodaer '
    1 'En lugar de ponerles valores le copiamos los valores de la entidad creada en el init'
    1 'la siguiente vez que llamemos a crear enemigo se creará en la siguiente posición del array'
        1 'Al sumarle un enemigo cuando volvamos a llamar a esta subrrutina
    1 'Creará el enemigo en la siguiente posición, pero antes fíjate en las dimensiones 
    1 'Que le reservaste en el loader.bas'
    6100 en=en+1
    6105 ex(en)=0:ey(en)=0:ep(en)=0:ei(en)=0
    6110 ev(en)=8:el(en)=8
    6130 ew(en)=8:eh(en)=8:es(en)=5
    6140 ee(en)=100
    6150 et(en)=0
    6160 ec(en)=0
6190 return



1 '---------------------------------------------------------'
1 '------------------------Objetos------------------'
1 '---------------------------------------------------------'
1 'Init'
1 'os=objeto seleccionado'
7000 os=0
7010 ox=0:oy=0
7090 return

1 'Rutina seleccion al pulsar espacio'
    7100 beep:os=os+1:if os>4 then os=1
    7110 line (0,21*8)-(247,24*8),15,bf
    7120 if os=1 then ox=5*8: preset (0,21*8):print #1,"!Seleccionada la espada: ":preset (0,22*8):print #1,"Puedes matar enemigos"
    7130 if os=2 then ox=7*8: preset (0,21*8):print #1,"!Seleccionada el rayo:":preset (0,22*8):print #1,"Puedes romper los muros"
    7140 if os=3 then ox=9*8: preset (0,21*8):print #1,"!Seleccionada la pala: ":preset (0,22*8):print #1,"Puedes dar palazos"             
    7150 if os=4 then ox=11*8: preset (0,21*8):print #1,"!Seleccionada la fuerza: " :preset (0,22*8):print #1,"Puedes mover los bloques amarillos"
    7160 PUT SPRITE 10,((22*8)-4,ox),1,9
7190 return


































1 '---------------------------------------------------------'
1 '------------------------MAPA---------------------------'
1 '---------------------------------------------------------'


1 ' inicializar_mapa
    1 'mw=mapa world, mundo'
    1 'ms=mapa seleccioando, lo hiremos cambiando    
    1 'md=mapa dirección en VRAM, utilizado para meter los datas de tiles
    1 'mc= mapa cambia, lo utilizaremos para cambiar los copys y así cambiar la pantalla
    8000 mw=0:ms=0:mc=0:tn=0
8020 return





1'Rutina posicionar player y enemigos según el mapa
    1 ' Creamos el 1 enemigo, la ev y la el es para que se mueva hacia arriba o hacia abajo'
    8300 if ms=0 then x=1*8:y=3*8:gosub 6100:ex(en)=15*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=12*8:ey(en)=16*8:et(en)=1
    1 'Mostramos la información'
    8380 gosub 3000
8390 return




1 'Render map, pintar mapa
    1 'la pantalla en screen 2:
    1 'El mapa se encuentra en la dirección 6144 / &h1800 - 6912 /1b00'
    9000 restore 10000
    1 'Borramos la fila superior'
    9010 for i=6144 to 6144+31:VPOKE i,255:next i
    1 'El +32 es paa bajar el mapa un poco abajo'
    9020 md=6144
        1 'El mapa lo he dibujado con tilemap con 20x20 tiles de 8 pixeles'
        9030 for f=0 to 19
            9035 READ D$
            1 ' ahora leemos las columnas c
            9040 for c=0 to 19
                9060 tn$=mid$(D$,c+1,1)
                1 'Si lo que hay en el mapa es un ladrillo (un 1) pintamos el tiled 244'
                9070 if tn$="0" then VPOKE md+c,&H0
                9080 if tn$="1" then VPOKE md+c,&H1
                1 '1 'Si el tile es un 2 es un punto de fuga'
                9090 if tn$="2" then VPOKE md+c,&H2
                1 '1 'Es un lugar para pasar al siguiente nivel,el 215 es un tiled prediseñado'
                9100 if tn$="3" then VPOKE md+c,&H3 
                9110 if tn$="4" then VPOKE md+c,&H4
                9120 if tn$="5" then VPOKE md+c,&H5
                9130 if tn$="6" then VPOKE md+c,&H6
                9140 if tn$="7" then VPOKE md+c,&H7
                9150 if tn$="8" then VPOKE md+c,&H8
                9160 if tn$="9" then VPOKE md+c,&H9
            9900 next c
            1 'Bajamos la fila'
            9910 md=md+32
        9920 next f
9990 return



1 'level 0'



10000 data 04444444444444444440
10010 data 60300000000000000007
10020 data 60301222210001122107
10030 data 60303000030000390307
10040 data 60383000032200300307
10050 data 60121000030000300307
10060 data 60000000030222100307
10070 data 62222221030000000307
10080 data 69000003012222222107
10090 data 60000003000000000007
10100 data 60000003002222222227
10110 data 60122003000000000007
10120 data 60300003022222102227
10130 data 60301221000000300007
10140 data 60303000022100300007
10150 data 60301222000300122107
10160 data 60300000000300000307
10170 data 60122222222100000307
10180 data 60000000000000000397
10190 data 05555555555555555550





1 'level 1'
10200 data 11111111111111111111
10210 data 10100000000000000001
10220 data 10100111110011111101
10230 data 10100100010010000101
10240 data 10100100010010000101
10250 data 10100100010010000101
10260 data 10100100010011110101
10270 data 10111100010000000101
10280 data 10000000011111111101
10290 data 10000111000000000101
10300 data 10000101001111111111
10310 data 11111101001000100001
10320 data 10000001001000100001
10330 data 10111001001000000001
10340 data 10100000001011111001
10350 data 10100111111010001001
10360 data 10100000000010011001
10370 data 10111111111110000001
10380 data 10000000000000000001
10390 data 11111111111111111111
1 'level 2'
10400 data 11111111111111111111
10410 data 10100000000000000001
10420 data 10100111110011111101
10430 data 10100100010010000101
10440 data 10100100010010000101
10450 data 10100100010010000101
10460 data 10100100010011110101
10470 data 10111100010000000101
10480 data 10000000011111111101
10490 data 10000111000000000101
10500 data 10000101001111111111
10510 data 11111101001000100001
10520 data 10000001001000100001
10530 data 10111001001000000001
10540 data 10100000001011111001
10550 data 10100111111010001001
10560 data 10100000000010011001
10570 data 10111111111110000001
10580 data 10000000000000000001
10590 data 11111111111111111111
1 'level 3'
10600 data 11111111111111111111
10610 data 10100000000000000001
10620 data 10100111110011111101
10630 data 10100100010010000101
10640 data 10100100010010000101
10650 data 10100100010010000101
10660 data 10100100010011110101
10670 data 10111100010000000101
10680 data 10000000011111111101
10690 data 10000111000000000101
10700 data 10000101001111111111
10710 data 11111101001000100001
10720 data 10000001001000100001
10730 data 10111001001000000001
10740 data 10100000001011111001
10750 data 10100111111010001001
10760 data 10100000000010011001
10770 data 10111111111110000001
10780 data 10000000000000000001
10790 data 11111111111111111111
1 'level 4'
10800 data 11111111111111111111
10810 data 10100000000000000001
10820 data 10100111110011111101
10830 data 10100100010010000101
10840 data 10100100010010000101
10850 data 10100100010010000101
10860 data 10100100010011110101
10870 data 10111100010000000101
10880 data 10000000011111111101
10890 data 10000111000000000101
10900 data 10000101001111111111
10910 data 11111101001000100001
10920 data 10000001001000100001
10930 data 10111001001000000001
10940 data 10100000001011111001
10950 data 10100111111010001001
10960 data 10100000000010011001
10970 data 10111111111110000001
10980 data 10000000000000000001
10990 data 11111111111111111111
1 'level 5'
11000 data 11111111111111111111
11010 data 10100000000000000001
11020 data 10100111110011111101
11030 data 10100100010010000101
11040 data 10100100010010000101
11050 data 10100100010010000101
11060 data 10100100010011110101
11070 data 10111100010000000101
11080 data 10000000011111111101
11090 data 10000111000000000101
11100 data 10000101001111111111
11110 data 11111101001000100001
11120 data 10000001001000100001
11130 data 10111001001000000001
11140 data 10100000001011111001
11150 data 10100111111010001001
11160 data 10100000000010011001
11170 data 10111111111110000001
11180 data 10000000000000000001
11190 data 11111111111111111111
1 'level 6'
11200 data 11111111111111111111
11210 data 10100000000000000001
11220 data 10100111110011111101
11230 data 10100100010010000101
11240 data 10100100010010000101
11250 data 10100100010010000101
11260 data 10100100010011110101
11270 data 10111100010000000101
11280 data 10000000011111111101
11290 data 10000111000000000101
11300 data 10000101001111111111
11310 data 11111101001000100001
11320 data 10000001001000100001
11330 data 10111001001000000001
11340 data 10100000001011111001
11350 data 10100111111010001001
11360 data 10100000000010011001
11370 data 10111111111110000001
11380 data 10000000000000000001
11390 data 11111111111111111111
1 'level '
11400 data 11111111111111111111
11410 data 10100000000000000001
11420 data 10100111110011111101
11430 data 10100100010010000101
11440 data 10100100010010000101
11450 data 10100100010010000101
11460 data 10100100010011110101
11470 data 10111100010000000101
11480 data 10000000011111111101
11490 data 10000111000000000101
11500 data 10000101001111111111
11510 data 11111101001000100001
11520 data 10000001001000100001
11530 data 10111001001000000001
11540 data 10100000001011111001
11550 data 10100111111010001001
11560 data 10100000000010011001
11570 data 10111111111110000001
11580 data 10000000000000000001
11590 data 11111111111111111111
1 'level 8'
11600 data 11111111111111111111
11610 data 10100000000000000001
11620 data 10100111110011111101
11630 data 10100100010010000101
11640 data 10100100010010000101
11650 data 10100100010010000101
11660 data 10100100010011110101
11670 data 10111100010000000101
11680 data 10000000011111111101
11690 data 10000111000000000101
11700 data 10000101001111111111
11710 data 11111101001000100001
11720 data 10000001001000100001
11730 data 10111001001000000001
11740 data 10100000001011111001
11750 data 10100111111010001001
11760 data 10100000000010011001
11770 data 10111111111110000001
11780 data 10000000000000000001
11790 data 11111111111111111111
1 'level 9'
11800 data 11111111111111111111
11810 data 10100000000000000001
11820 data 10100111110011111101
11830 data 10100100010010000101
11840 data 10100100010010000101
11850 data 10100100010010000101
11860 data 10100100010011110101
11870 data 10111100010000000101
11880 data 10000000011111111101
11890 data 10000111000000000101
11900 data 10000101001111111111
11910 data 11111101001000100001
11920 data 10000001001000100001
11930 data 10111001001000000001
11940 data 10100000001011111001
11950 data 10100111111010001001
11960 data 10100000000010011001
11970 data 10111111111110000001
11980 data 10000000000000000001
11990 data 11111111111111111111





1 'Rutina cargar sprites con datas basic'
    20870 RESTORE 20950
    1 ' vamos a meter 5 definiciones de sprites nuevos que serán 4 para el personaje y uno para la bola'
    20880 FOR I=0 TO 13:SP$=""
        20890 FOR J=1 TO 8:READ A$
            20900 SP$=SP$+CHR$(VAL("&H"+A$))
        20901 NEXT J
        20910 SPRITE$(I)=SP$
    20911 NEXT I
    20950 DATA 18,18,66,5A,5A,24,24,66
    20960 DATA 18,18,24,3C,3C,18,18,3C
    20970 DATA 18,18,10,18,1C,18,18,1C
    20980 DATA 18,18,08,18,38,18,18,38
    20990 DATA E3,E3,E3,3E,3E,3E,F9,F9
    21000 DATA 18,3C,66,42,C3,C3,C3,FF
    21010 DATA 00,00,00,3C,42,FF,FF,FF
    21020 DATA 81,DB,3C,18,18,66,42,C3
    21030 DATA 00,18,7E,5A,18,24,24,66
    21040 DATA FF,81,81,81,81,81,81,FF
    21050 DATA 01,02,04,88,50,20,D0,C8
    21060 DATA 07,0E,38,70,0E,1C,70,E0
    21070 DATA 0C,0C,0C,0C,0C,06,0F,0F
    21080 DATA 00,23,33,FB,FB,33,23,00


20999 return 


1' Rutina cargar gráficos
    1 'En screen 1'
    1 '1' En screen 1 la memoria VRAM es rellenada por el sistema
    1 '1' Definicición de tiles
    1 '1 ' En el caracter 224*8=1792
    1 '30000 FOR I=1792 TO 1792+7
    1 '   30010 READ A$
    1 '   30020 VPOKE I,VAL("&H"+A$)
    1 '30030 NEXT I
    1 '1 'Definición de colores, en la dirección 8192 empieza la tabla de colores (base(6))
    1 '1 'Le damos el color rojo y transparente 6 0 a nuesto tile
    1 '30210 vpoke 8220,&h60
    1 '1 'Como vamos a utilizar un tile ya prediseñado de los que vienen incuidos (el 204, rayitas diagonales )'
    1 '1 'Vamos a ponerle el color amarillo y transparente'
    1 '30220 vpoke 8214,&hb0
    1 '1 'Vamos a poner un color rojo y blanco al tiled de cambio de nivel (el 215, una especie de meta) '
    1 '30225 vpoke 8215,&h6f
    1 '1 'Definicion del caracter 224, ladrillo
    1 '30230 DATA E3,E3,E3,3E,3E,3E,F9,F9

    1 'En screen 2'
    1' Hay que recordar la estructura de la VRAM, en la VRAM están los datos que se reprentan en pantalla

    1 'Definiremos a partir de la posición 0 de la VRAM 18 tiles de 8 bytes'
    30000 restore 30060
        30005 FOR I=0 TO (10*8)-1
        30010 READ A$
        30020 VPOKE I,VAL("&H"+A$)
        30030 VPOKE 2048+I,VAL("&H"+A$)
        30040 VPOKE 4096+I,VAL("&H"+A$)
    30050 NEXT I


    30060 DATA 00,00,00,00,00,00,00,00
    30070 DATA FF,FF,FF,FF,FF,FF,FF,FF
    30080 DATA FF,FF,FF,00,00,FF,FF,FF
    30090 DATA E7,E7,E7,E7,E7,E7,E7,E7
    30100 DATA 00,F7,F7,F7,00,7F,7F,7F
    30110 DATA FB,FB,FB,00,BF,BF,BF,00
    30120 DATA 77,07,77,77,77,70,77,77
    30130 DATA EE,EE,0E,EE,EE,EE,E0,EE
    30140 DATA 18,3C,7E,7E,24,7E,7E,7E
    30150 DATA 18,3C,7E,81,1C,7E,3C,18

    1 'Definición de colores, los colores se definen a partir de la dirección 8192/&h2000'
    1 'Como la memoria se divide en 3 bancos, la parte de arriba en medio y la de abajo hay que ponerlos en 3 partes'
    31000 RESTORE 31060
    31005 FOR I=0 TO (10*8)-1
        31010 READ A$
        31020 VPOKE 8192+I,VAL("&H"+A$): '&h2000'
        31030 VPOKE 10240+I,VAL("&H"+A$): '&h2800'
        31040 VPOKE 12288+I,VAL("&H"+A$): ' &h3000'
    31050 NEXT I

    31060 DATA 11,11,11,11,11,11,11,11
    31070 DATA A1,A1,A1,A1,A1,A1,A1,A1
    31080 DATA A1,A1,E1,E1,E1,E1,A1,A1
    31090 DATA A1,A1,A1,A1,A1,A1,A1,A1
    31100 DATA A1,81,81,81,81,81,81,81
    31110 DATA 81,81,81,81,81,81,81,81
    31120 DATA 81,81,81,81,81,81,81,81
    31130 DATA 81,81,81,81,81,81,81,81
    31140 DATA 41,41,41,91,79,91,91,91
    31150 DATA 71,51,51,75,85,51,51,71

31990 return



