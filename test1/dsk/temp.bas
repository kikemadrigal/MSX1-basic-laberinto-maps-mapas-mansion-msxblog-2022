1 '' ******************************
1 '' Program:  Mansion Madrigal
1 '' autor:    MSX Murcia
1 '' ******************************
1 'Inicilizamos el juego'
1 'Inicilizamos dispositivo: 003B, inicilizamos teclado: 003E, inicializamos el psg &h90'
1 'Enlazamos con las rutinas de apagar y encender la pantalla'
20 defusr=&h003B:a=usr(0):defusr1=&h003E:a=usr1(0):defusr2=&H90:a=usr2(0):defusr3=&h41:defusr4=&h44
1 'Color caracteres, fondo, borde'
30 color 1,15,7:screen 2,0,0
40 defint a-z:open "grp:" as #1
 1 ' inicializamos los sprites'
50 gosub 9000
1 ' inicilizamos el personaje'
70 'gosub 5000
1 ' inicilizamos los enemigos'
80 gosub 6000
1 'Inicializamos las variables del juego
1 'tm=tiempo maximo'
1 'ta=timepo actual'
1 'tn=diferencia entre el timepo actual y el que queda'
100 tm=40:tn=0:time=0
1 'Gs=game status, si es 0 mostraremos el menu de bienvenida, si es 1 vamos al main loop, y 2, pantalla ganadora'
110 gs=0
120 strig(0) on

1 '<<<<<<<<Bucle o máquina de estados>>>>>>>>>>>>>'
    200 if gs=0 then goto 230 
    210 if gs=1 then goto 350
    220 if gs=2 then goto 300

    1 'Mostramos la pantalla de bienvenida e instrucciones'
    230 screen 2
    235 preset (60,10):print #1,"!Mansion Madrigal"
    240 preset (60,20):print #1,"!MSX Murcia 2022"
    250 preset (0,50):print #1,"!Debes de ingeniar como salir del laberinto antes de que se te acabe el tiempo"
    260 preset (0,90):print #1,"!Utiliza las herramientas que tienes a ut disposicion, pulsa espacio para elegir una"
    270 preset (0,130):print #1,"!Solo puedes utilizarlas una cez por mundo"
    280 preset (0,21*8):print #1,"!Pulsa espacio para continuar"
    1 '290 if inkey$="" then goto 290 else gs=1:goto 200
    290 if strig(0)=-1 then gs=1:goto 200 else goto 290

    300 screen 2
    305 preset (60,10):print #1,"!Has ganado!!!!"
    310 preset (60,20):print #1,"!MSX Murcia 2022"
    320 preset (0,50):print #1,"!Desarrolador: Kike Madrigal"
    330 if strig(0)=-1 then gs=1:goto 200 else goto 330
1 '<<<<<<<< FInal del bucle de estados>>>>>>>>>>>>>'


1 ' inicilizamos el personaje'
350 gosub 5000
1 'Apagamos la pantalla'
355 'a=usr3(0)
1 ' Inicializamos los gráficos'
360 gosub 10000
1 'Borramos los gráficos que han salido en la pantalla'
370 for i=0 to 19:vpoke (6144+20)+i*32,3:vpoke (6144+21)+i*32,3:vpoke (6144+22)+i*32,3:vpoke (6144+23)+i*32,3:next i
1 'Encendemos la pantalla'
375 'a=usr4(0)
1 ' Pintamos el mapa'
380 gosub 11000
1 'Inicializamoz los objetos'
385 gosub 7000
1 'Pintamos los objetos'
390 gosub 3100
1 'posicionamos al player y enemigos tras cargar el mapa'
391 gosub 8300
1 'Cada segundo repintamos el tiempo'
392 interval on:on interval=50 gosub 3200
1 'Cuando se pulse el espacio o el disparo del joystick elegimos una de las herramientas'
393 if gs=1 then on strig gosub 7100
1 'Cuando haya colisión de sprites ir a la subrutina de player muere
394 'sprite on:on sprite gosub 5700
1 ' Mostramos el marcador'
395 gosub 3000


1 ' <<<<<< Main loop >>>>>'
    1'Si al player no le quedan vidas
        1 'Tenemos que colocar el punturo del mapa en el world0, level0'
        1 'Desactivamos el repintado y actualización del tiempo'
        1 'Eliminamos a los enemigos (6700)'
        1 'Sacamos al player de la pantalla'
        1 'Volvemos los objetos a su configuración inicial (7000)'
    400 if pe<=0 then restore 10100:interval off:gosub 6700:PUT SPRITE 0,(0,212),1,pp:gosub 7000:gs=0:goto 200
    1 'si no queda tiempo reiniciamos y llamamos a la rutina player muere'
    410 if ta<=0 then tf=0:time=0:gosub 5700 
    1 'Actualizamos el sistema de input'
    420 gosub 1000
    1 'Actualizamos el sistema de fisicas y colisiones'
    430 gosub 1760
    1 'Actualizamos sistema del render
    440 gosub 1400


    1 'Si el mapa cambia:
    1 '     Aumentamos el ms=mapa screen'
    1 '     Pintamos el nuevo mapa (11000)'
    1 '     Pintamos la información (3000) para indicar el nivel'
    1 '     Posicionamos al jugador y enemigos (8300)'
    1 '     Desactivamos la bandera de cambio de mapa'
    480 if mc then ms=ms+1:gosub 11000:gosub 3000:gosub 8300:mc=0
500 goto 400 
1 ' <<<<<< Final del Main loop >>>>>'



1' <<<< INPUT SYSTEM >>>>
    1000 ST=STICK(0) OR STICK(1) OR STICK(2)
    1 'xp= posicion x previa player, yp=posición y previaplayer'
    1 'Conservamos la posición previa para las colisiones'
    1010 xp=x:yp=y
    1 'pv=player velocidad
    1020 on st gosub 1110,1120,1130,1140,1150,1160,1170
    1 'Colisones con los extremos de la pantalla'
    1 'xp, yp posición x previa, posición y previa'
    1030 if x<=0 then x=xp
    1040 if y<=0 then y=yp
    1050 if y+ph>192 then y=yp
    1060 if x+pw>252 then x=xp
1090 RETURN
1 'ps=plyer sprite'
1 '1 arriba'
1110 y=y-pv:ps=p0:swap p0,p1:pd=1:re=10:gosub 4000:return
1 '2'
1120 return
1 '3 derecha'
1130 x=x+pv:ps=p2:swap p2,p3:pd=3:re=10:gosub 4000:return
1 '4'
1140 return
1 '5 abajo'
1150 y=y+pv:ps=p4:swap p4, p5:pd=5:re=10:gosub 4000:return
1 '6 abajo derecha'
1160 return
1 '7 izquierda'
1170 x=x-pv:ps=p6:swap p6,p7:pd=7:re=10:gosub 4000:return


















1 '' <<< RENDER SYSTEM >>>>
    1 'Pintamos de nuevo el player con la posición, el color y el plano(dibujitos de izquierda, derecha..)'
    1400 PUT SPRITE 0,(x,y),1,ps
    1410 if en=0 then return
    1 'dibujamos los enemigos, sin el for ser ve más claro'
    1430 for i=1 to en
        1 'Esto es para animar los muñegotes'
        1440 ec(i)=ec(i)+1:if ec(i)>1 then ec(i)=0
        1450 if et(i)=0 then if ec(i)=0 then es(i)=8 else es(i)=9
        1460 if et(i)=1 then if ec(i)=0 then es(i)=10 else es(i)=11
        1490 PUT SPRITE ep(i),(ex(i),ey(i)),1,es(i)
    1495 next i
1520 return

















1' '' <<< PHYSICS & COLLISION SYSTEM >>>>
    1 'Colisiones del player con el mapa'
    1 'Para detectar la colisión vemos el valor que hay en la tabla de nombres de la VRAM
    1 'En la posición x e y de nuestro player con la formula: '
    1 'Si hay una colision le dejamos la posicion que guardamos antes de cambiarla por pulsar una tecla'
    1760 hl=6144+(y/8)*32+(x/8):a=vpeek(hl)
    1 'Si es un tile sólido o un bloque empujable
    1 'Si está activa la herramienta de romper bloque'
    1 '     Rompemos el bloque piendo vpoke en esa dirección'
    1 '     deshabilitamos para que no se vuelva a utilizar'
    1 '     Repintamos los objetos para que aparezca de color blando el seleccionado (3100)'
    1 '     Hacemos un sonido (re,4000)'
    1 'Si no está activa la herramienta de romper bloque'
    1'      volvemos a la posición que estábamos
    1 '1770 if a>3 and a<16 then if os=3 and o3=1 then vpoke hl,0:o3=0:gosub 3100:re=10:gosub 3000 else x=xp: y=yp
    1770 if a>3 and a<16 then if os=3 and o3=1 then vpoke hl,0:o3=0:gosub 3100:re=10:gosub 4000 else if os=4 and o4=1 then o4=0:gosub 3100:re=2:gosub 3000 else x=xp: y=yp
    1 'Si ha tocado un objeto empujable'
    1 '     Desactivamos para que no se pueda elegir
    1 '     repintamos los objetos para que salga en blanco el selecionado (3100)''
    1 '     Hacemnos un música (re, 4000)'
    1 '     Le ponemos un 0 para borrarlo'
    1 '1780 if a=22 and os=5 and o5=1 then o5=0:gosub 3100:re=8:gosub 4000:vpoke hl, 0:if pd=1 then vpoke 6144+((y/8)-1)*32+(x/8), 22 else if pd=3 then vpoke 6144+((y/8)*32)+1+(x/8),22 else if pd=5 then vpoke 6144+(((y/8)+1)*32)+(x/8),22 else if pd=7 then vpoke 6144+((y/8)*32)+(x/8)-1,22
    
    1775 if a=22 and os=5 and o5=1 then o5=0:gosub 3100:re=8:gosub 4000:vpoke hl, 0:if pd=1 then vpoke 6144+((y/8)-1)*32+(x/8), 22 else if pd=3 then vpoke 6144+((y/8)*32)+1+(x/8),22 else if pd=5 then vpoke 6144+(((y/8)+1)*32)+(x/8),22 else if pd=7 then vpoke 6144+((y/8)*32)+(x/8)-1,22
    1780 if a=22 then x=xp: y=yp
    1 'Si ha tocado monedas o dolares le sumamos 10puntos'
    1 '     Lo borramos on vpoke dirección,0'
    1 '     Sumamos 10 puntos al pp=player points'    
    1 '     Repitamos el marcador para que se vean los puntos (3000)'
    1781 if a=21 then re=11:gosub 4000:vpoke hl,0:pp=pp+10:gosub 3100:gosub 3000
    1 'Si hemos llegado a la casa cambiamos de nivel'
    1785 if a=19 then re=2:gosub 4000:mc=1
    1 'Si tocado un reloj le sumamos al tiempo el aumento o el maximo'
        1 'Obtenmos lo que falta de tiempo y lo metemos en tf para después sumarlo en el contador de tiempo'
        1 'Hacemo una música de cogido'
        1' hacemos que desapaezca el reloj
    1790 if a=20 then tf=ta:time=0:re=5:gosub 4000:vpoke hl,0


    1 'Fisica y Colisiones de ememigos con el mapa'
    1900 for i=1 to en
        1910 if et(i)=0 then ex(i)=ex(i)+ev(i)
        1920 if et(i)=1 then ey(i)=ey(i)+el(i)
        1930 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1 'Si es una pared o un bloque empujable 
            1 'le invertimos la velocidad del eje x y del eje y'
            1 'y le volvemos a poner las coordenadas antiuas '
            1 'ev=velocidad x y el velocidad eje y '
            1 'ep coordenada previa x , ei=coordenada previa y'
        1940 if a>3 and a<16 or a=22 then if et(i)=0 then ev(i)=-ev(i):ex(i)=ea(i):ey(i)=ei(i) else if et(i)=1 then el(i)=-el(i):ex(i)=ea(i):ey(i)=ei(i)
        1 'Conservamos los datos de las posiciones antes de cambiarlos'
        1950 ea(i)=ex(i):ei(i)=ey(i)   

        1 'Si hat Colisión del player con el enemigo'
        1 '     Si está acitvado el objeto 2 de matar enemigos y habilitado'
        1 '         hacemos un sonido (re=6:4000)'
        1 '         Eliminamos al enemigo (ed=i:6600)'
        1 '         Repintamos los objetos
        1 '     Si no está activado o habilitado el objeto 1'
        1 '         Matamos al player'
        1960 if x < ex(i) + ew(i) and x + pw > ex(i) and y < ey(i) + eh(i) and y + ph > ey(i) then if os=2 and o2=1 then re=3:gosub 4000:o2=0:ed=i:gosub 6600:gosub 3100 else beep:gosub 5700
    1970 next i
1990 return














1 'informacion del juego que aparece en l aparte superior'
    3000 'line (21*8,4*8)-(23*8,5*8),14,bf
    3010 line (24*8,0)-(256,20*8),14,bf
    3020 preset (26*8,1*8): print #1,"World"
    3030 preset (27*8,3*8): print #1,mw
    3040 preset (26*8,5*8): print #1,"Level"
    3050 preset (27*8,7*8): print #1,ms
    3060 preset (26*8,9*8): print #1,"Live"
    3070 preset (27*8,11*8): print #1,pe
    3075 preset (26*8,13*8): print #1,"Score"
    3080 preset (27*8,15*8): print #1,pp
    3085 preset (26*8,17*8): print #1,"Time"
    3090 preset (24*8,21*8): print #1,fre(0)
3099 return




1 'pintar objetos
    1 'el plano 20 es el marco de selección'
    1 'el plano 21 la cruz'
    3100 if o1 then PUT SPRITE 21,((22*8)-4,5*8),6,13 else PUT SPRITE 21,((22*8)-4,5*8),15,13
    1 '2 La espada'
    3110 if o2 then PUT SPRITE 22,((22*8)-4,7*8),6,14 else PUT SPRITE 22,((22*8)-4,7*8),15,14
    1 'El rayo rompe muros'
    3120 if o3 then PUT SPRITE 23,((22*8)-4,9*8),6,15 else PUT SPRITE 23,((22*8)-4,9*8),15,15
    1 'La escalera'
    3140 if o4 then PUT SPRITE 24,((22*8)-4,11*8),6,16 else PUT SPRITE 24,((22*8)-4,11*8),15,16
    1 'Emupjar bloque'
    3150 if o5 then PUT SPRITE 26,((22*8)-4,13*8),6,17 else PUT SPRITE 26,((22*8)-4,13*8),15,17
3190 return

1 'Pintar el tiempo'
    3200 line (27*8,18*8)-(30*8,20*8),14,bf
    3210 tu=time/50
    3220 ta=(tm+tf)-tu
    3230 preset (26*8,(19*8)-4): print #1,ta
    1 '3240 preset (24*8,16*8): print #1,os" "oy
3290 return
1'debug
    1 '3300 preset (0,23*8): print #1,"o1 "o1" o2 "o2" o3 "o3" o4 "o4" oy "oy" os "os
    3300 preset (0,23*8): print #1,en" ex0 "ex(1)" ey0 "ey(1)" ex1 "ex(2)" ey1 "ey(2)
3390 return


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
    1 'Comienzo juego'
    4000 if re=1 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A r60 G E F D C D G R8 A2 A2 A8","o1 v4 c r8 o2 c r8 o1 v6 c r8 o2 v4 c r8 o1 c r8 o2 v6 c r8"
    1 'Level pasado'
    4020 if re=2 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A r60 G E F D C D G R8 A2 A2 A8"
    1 'Emupjando bloque'
    4030 if re=5 then play "l10 o4 v4 g c"
    1 'Paquete cogido'
    4040 if re=6 then play"t250 o5 v12 d v9 e" 
    1 'Pitido normal'
    4050 if re=7 then play "O5 L8 V4 M8000 A A D F G2 A A A A"
    1 'Cogidos puntos'
    1 '4060 if re=8 then PLAY"S1M2000T150O7C32"
    4060 if re=8 then sound 3,2:sound 8,16:sound 12,5:sound 13,9
    1 'Pasos'
    4070 if re=9 then PLAY"o2 l64 t255 v4 m6500 c"
    1 'Sound puerto, valor, para ver las notas ir a https://www.msx.org/wiki/SOUND, recuerda que el d5dh=3421 es el 34 para el tono canal a puerto 1 y en puerto 0 21'
    1 '0=Tono canal a bit menos significativo,2=tono canal b menos significativo, 4=tono canal c menos significativo de 0-255
    1 '1=Tono canal a bit mas significativo, 3=tono canal b bit mas significativo, 5=tono canal c bit mas significativo de 0 a 15 
    1 '6 ruido de 0-31
    1' 7 mezlador 0-191
    1 '8 volumen canal a, 9 volumen canal b, 10 volumen canal c de 0-16'
    1 '12 velocidad envolvente de 0-255, 0 la más veloz
    1 '13 forma envolmente para que desaparezca en el tiempo la nota de 0-15'
    1 'En este ejemplo trabajamos solo con el ruido, el 6, el 8 =16 significa que vamos a variar el volumen con el 12 y el 13 para que desaparezca'
    1 'Pasos'
    4060 if re=10 then sound 1,2:sound 6,25:sound 8,16:sound 12,1:sound 13,9
    4070 if re=11 then sound 1,0:sound 6,25:sound 8,16:sound 12,4:sound 13,9
    1 'Inicializamos el psg para que no se quede con el úlyimo sonido'
    4080 'a=usr2(0)
4090 return






























1 '---------------------------------------------------------'
1 '------------------------PLAYER---------------------------'
1 '---------------------------------------------------------'

1 ' Inicializando el personaje'
    1 ' x=pisicon x previa, utilizada en el sistema de input'
    1 ' y= posicion y previa, utilizada en el sistema de input'
    1 ' pe=player energy o vida
    1 'Player colision, se utiliza para habilitar el sprite on cuando hay una colision'
    1 'pa=player time actual'
    1 'pd=player direccion'
    1 'pp=player puntos'
    5000 x=0:y=0:xp=0:yp=0:pw=8:ph=8:pv=8:pe=3:pd=0:pp=0
    1 'p0 y p1=sprites arriba: contedrá 0 o 1 intercambiados con swap que son los sprites de la animación de arriba'
    1 'p2 y p3=sprite derecha: determina si está el sprite 2 o 3''
    1 'p4 y p5=sprites abajo 
    1 'p6 y p7=sprites izquierda: 6 o 7'
    5010 p0=0:p1=1:p2=2:p3=3:p4=4:p5=5:p6=6:p7=7
5020 return
1' Player muere
    1 'Le kitamos 1 vida'
    1 'Actializamos el tiempo'
    5700 pe=pe-1:pa=pa-pm:time=0
    1 'inicializamos objetos
    5720 'gosub 7000
    1 ' llamamos a la tutina reposicionar player y enemigos según el mapa'
    5740 gosub 8300
    1 'Pintamos el marcador'
    5750 gosub 3000

5790 return



1 '---------------------------------------------------------'
1 '------------------------ENEMIES MANAGAER------------------'
1 '---------------------------------------------------------'
1 'Init'


1 'et=turno de enemigo'
1 'en=numero de enemigo'
1 'Componente de posicion'
    1 'ex=coordenada x, ey=coordenada y', ea=coordenada previa x, ei=coordenada previa y
1 'Componente de fisica'
    1 'ev=velocidad enemigo eje x, el=velocidad eje y'
1 'Componente de render'
    1 'ew=ancho enemigo, eh= alto enemigo, es=enemigo sprite, ec=enemigo contador, utlizado para hacer la animación'
1 'Componente RPG'
    1 'ee=enemigo energia,et=enemigo tipo, determina su comportamiento '
    6000 em=5
    1 ' Component position'
    6010 DIM ex(em),ey(em),ea(em),ei(em)
    1 ' Compenent phisics'
    6020 DIM ev(em),el(em)
    1 ' Component render'
    6030 DIM ew(em),eh(em),es(em),ec(em),ep(em)
    1 ' Component RPG'
    6040 DIM ee(em)
    6050 en=0
6099 return

1 ' Crear enemigo'
    6100 en=en+1
    6105 ex(en)=0:ey(en)=0:ea(en)=0:ei(en)=0
    6110 ev(en)=8:el(en)=8
    1 'los planos del enemigo serán de 10 en adelante'
    6130 ew(en)=8:eh(en)=8:es(en)=8:ep(en)=10+en
    6140 ee(en)=100
    6150 et(en)=0
    6160 ec(en)=0
6190 return

1 ' Rutina eliminar enemigo'
    6600 if en<=0 then return
    6610 ex(ed)=ex(en):ey(ed)=ey(en):ev(ed)=ev(en):el(ed)=el(en):ec(ed)=ec(en):ee(ed)=ee(en):ep(ed)=ep(en):et(ed)=et(en)
    6620 put sprite ep(ed),(0,212),,es(ed)
    6630 en=en-1
6640 return

1 'Eliminar enemigos'
    1 'quitamos todos los sprites d ela pantalla'
    6700 for i=0 to 10
        6710 PUT SPRITE i,(0,212),,0
    6720 next i
    6780 en=0
6790 return



1 '---------------------------------------------------------'
1 '------------------------Objetos------------------'
1 '---------------------------------------------------------'
1 'Init'
    1 'os=objeto seleccionado'
    7000 os=0:oy=3*8
    1 'Habilitamos los objetos, ponemos su valor a 1'
    1 'Objeto 1: la cruz de eliminar selección'
    1 'Objeto 2: la espada para matar enemigos'
    1 'Objeto 3: el rayo para romper muros'
    1 'Obejto 4: la escalera, para subir muros'
    1 'Objeto 5: la fuerza para empujar muros'
    7020 o1=1:o2=1:o3=1:o4=1:o5=1
7090 return

1 'Rutina seleccion al pulsar espacio'
    7100 beep:os=os+1:if os>5 then os=1 
    7105 oy=oy+16:if oy>13*8 then oy=5*8 
    1 'Borramos el mensaje anterior'
    7110 line (0,21*8)-(256,24*8),15,bf
    7120 if os=1 and o1=1 then  preset (0,21*8):print #1,"!Seleccion eliminada":preset (0,22*8)
    7130 if os=2 and o2=1 then  preset (0,21*8):print #1,"!Seleccionada la espada: ":preset (0,22*8):print #1,"Puedes matar enemigos"
    7140 if os=3 and o3=1 then  preset (0,21*8):print #1,"!Seleccionada el rayo:":preset (0,22*8):print #1,"Puedes romper los muros"
    7160 if os=4 and o4=1 then  preset (0,21*8):print #1,"!Seleccionada la escalera: ":preset (0,22*8):print #1,"Puedes pasar por encima de los muros"             
    7170 if os=5 and o5=1 then  preset (0,21*8):print #1,"!Seleccionada la fuerza: " :preset (0,22*8):print #1,"Puedes mover los bloques amarillos"
    1 'Este es el marco que sale junto al objeto para decir que está seleccionado'
    7175 PUT SPRITE 20,((22*8)-4,oy),1,12

7190 return


































1 '---------------------------------------------------------'
1 '------------------------MAPA---------------------------'
1 '---------------------------------------------------------'


1 ' inicializar_mapa
    1 'mw=mapa world, mundo'
    1 'ms=mapa seleccioando, lo hiremos cambiando    
    1 'md=mapa dirección en VRAM, utilizado para meter los datas de tiles
    1 'mp=mapa posición, utilizada para recorrer los caracteres'
    1 'mc= mapa cambia, lo utilizaremos para cambiar los copys y así cambiar la pantalla
    8000 mw=0:ms=0:mc=0:tn=0
8020 return





1'Rutina posicionar player y enemigos según el mapa
    1 'Eliminamos todos los enemigos si los hay'
    8300 gosub 6700
    1 'Debug'
    1 '8310 if ms=0 then x=15*8:y=5*8:gosub 6100:ex(en)=13*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=12*8:ey(en)=16*8:et(en)=1
    8310 if ms=0 then x=5*8:y=10*8:gosub 6100:ex(en)=15*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=12*8:ey(en)=16*8:et(en)=1
    8320 if ms=1 then x=2*8:y=12*8:gosub 6100:ex(en)=10*8:ey(en)=10*8:et(en)=0:gosub 6100:ex(en)=7*8:ey(en)=4*8:et(en)=0
    8330 if ms=2 then x=7*8:y=9*8:gosub 6100:ex(en)=10*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=10*8:ey(en)=10*8:et(en)=1
    8340 if ms=3 then x=18*8:y=1*8:gosub 6100:ex(en)=10*8:ey(en)=4*8:et(en)=0:gosub 6100:ex(en)=10*8:ey(en)=13*8:et(en)=0
    8350 if ms=4 then x=2*8:y=12*8:gosub 6100:ex(en)=1*8:ey(en)=11*8:et(en)=1:gosub 6100:ex(en)=16*8:ey(en)=12*8:et(en)=0
    1 'Mostramos la información'
    8380 'gosub 3000
8390 return





1 'Rutina cargar sprites con datas basic'
    1 ' vamos a meter 5 definiciones de sprites nuevos que serán 4 para el personaje y uno para la bola'
    9000 FOR I=0 TO 17:SP$=""
        9020 FOR J=1 TO 8:READ A$
            9030 SP$=SP$+CHR$(VAL("&H"+A$))
        9040 NEXT J
        9050 SPRITE$(I)=SP$
    9060 NEXT I
    9090 DATA 03,C3,D8,3C,BD,DB,E7,7E
    9100 DATA C0,C3,1B,3C,BD,DB,E7,7E
    9110 DATA 76,E6,D8,BC,BC,D8,E3,73
    9120 DATA 73,E3,D8,BC,BC,D8,E6,76
    9130 DATA 7E,E7,DB,BD,3C,1B,C3,C0
    9140 DATA 7E,E7,DB,BD,3C,D8,C3,03
    9150 DATA CE,C7,1B,3D,3D,1B,67,6E
    9160 DATA 6E,67,1B,3D,3D,1B,C7,CE
    9170 DATA 18,3C,66,C3,C3,66,3C,18
    9180 DATA 3C,7E,FF,E7,E7,FF,7E,3C
    9190 DATA 81,C3,24,3C,3C,24,42,C3
    9200 DATA 00,42,66,3C,3C,24,66,00
    9210 DATA FF,81,81,81,81,81,81,FF
    9220 DATA 81,42,24,18,18,24,42,81
    9230 DATA 01,02,04,88,50,20,D0,C8
    9240 DATA 07,0E,38,70,0E,1C,70,E0
    9250 DATA 24,24,3C,24,24,3C,24,24
    9260 DATA 00,23,33,FB,FB,33,23,00



    

9990 return 

1' Rutina cargar gráficos
    1 'En screen 1'
    1 '1' En screen 1 la memoria VRAM es rellenada por el sistema
    1 '1' Definicición de tiles
    1 '1 ' En el caracter 224*8=1792
    1 '10000 FOR I=1792 TO 1792+7
    1 '   10010 READ A$
    1 '   10020 VPOKE I,VAL("&H"+A$)
    1 '10030 NEXT I
    1 '1 'Definición de colores, en la dirección 8192 empieza la tabla de colores (base(6))
    1 '1 'Le damos el color rojo y transparente 6 0 a nuesto tile
    1 '10210 vpoke 8220,&h60
    1 '1 'Como vamos a utilizar un tile ya prediseñado de los que vienen incuidos (el 204, rayitas diagonales )'
    1 '1 'Vamos a ponerle el color amarillo y transparente'
    1 '10220 vpoke 8214,&hb0
    1 '1 'Vamos a poner un color rojo y blanco al tiled de cambio de nivel (el 215, una especie de meta) '
    1 '10225 vpoke 8215,&h6f
    1 '1 'Definicion del caracter 224, ladrillo
    1 '10230 DATA E3,E3,E3,3E,3E,3E,F9,F9

    1 'En screen 2'
    1' Hay que recordar la estructura de la VRAM, en la VRAM están los datos que se reprentan en pantalla
    1 'Nuestro tileset son 24 tiles o de 0 hasta el 23'
    1 'Definiremos a partir de la posición 0 de la VRAM 18 tiles de 8 bytes'
        10000 FOR I=0 TO (24*8)-1
        10020 READ A$
        10030 VPOKE I,VAL("&H"+A$)
        10040 VPOKE 2048+I,VAL("&H"+A$)
        10050 VPOKE 4096+I,VAL("&H"+A$)
    10060 NEXT I


    10100 DATA FF,66,66,00,00,66,66,00
    10101 DATA FF,66,66,00,00,66,66,00
    10102 DATA FF,99,99,FF,FF,99,99,FF
    10103 DATA FF,FF,FF,FF,FF,FF,FF,FF
    10104 DATA 7E,7E,7E,7E,7E,7E,7E,7E
    10105 DATA 00,7E,7E,7E,7E,7E,7E,7E
    10106 DATA 7E,7E,7E,7E,7E,7E,7E,00
    10107 DATA 00,FF,FF,FF,FF,FF,FF,00
    10108 DATA 00,FE,FE,FE,FE,FE,FE,00
    10109 DATA 00,7F,7F,7F,7F,7F,7F,00
    10110 DATA 7F,7F,7F,7F,7F,7F,7F,00
    10111 DATA FE,FE,FE,FE,FE,FE,FE,00
    10112 DATA 00,FE,FE,FE,FE,FE,FE,FE
    10113 DATA 00,7F,7F,7F,7F,7F,7F,7F
    10114 DATA 00,F7,F7,F7,00,7F,7F,7F
    10115 DATA 00,F7,F7,F7,00,7F,7F,7F
    10116 DATA 00,F7,F7,F7,00,7F,7F,7F
    10117 DATA FF,18,18,7E,7E,18,18,00
    10118 DATA 00,7E,7E,7E,7E,7E,7E,7E
    10119 DATA 5E,5E,7E,7E,7E,7E,7E,00
    10120 DATA 18,3C,C3,81,1C,C3,3C,18
    10121 DATA 14,3F,54,3E,15,15,7E,14
    10122 DATA FF,A5,FF,A5,A5,FF,A5,FF
    10123 DATA FF,5A,00,5A,5A,00,5A,00



    1 'Definición de colores, los colores se definen a partir de la dirección 8192/&h2000'
    1 'Como la memoria se divide en 3 bancos, la parte de arriba en medio y la de abajo hay que ponerlos en 3 partes'
    10500 FOR I=0 TO (24*8)-1
        10520 READ A$
        10530 VPOKE 8192+I,VAL("&H"+A$): '&h2000'
        10540 VPOKE 10240+I,VAL("&H"+A$): '&h2800'
        10550 VPOKE 12288+I,VAL("&H"+A$): ' &h3000'
    10560 NEXT I


    10600 DATA E1,FE,FE,FE,FE,FE,FE,FE
    10601 DATA A1,EA,EA,EA,EA,EA,EA,EA
    10602 DATA F1,FE,FE,FE,FE,FE,FE,FE
    10603 DATA A1,A1,A1,A1,A1,A1,A1,A1
    10604 DATA A1,A1,A1,A1,A1,A1,A1,A1
    10605 DATA A1,E1,A1,A1,A1,A1,A1,A1
    10606 DATA A1,A1,A1,A1,A1,A1,E1,E1
    10607 DATA E1,E1,A1,A1,A1,A1,E1,E1
    10608 DATA E1,E1,A1,A1,A1,A1,E1,E1
    10609 DATA E1,E1,A1,A1,A1,A1,E1,E1
    10610 DATA A1,A1,A1,A1,A1,A1,E1,E1
    10611 DATA A1,A1,A1,A1,A1,A1,E1,E1
    10612 DATA E1,E1,A1,A1,A1,A1,A1,A1
    10613 DATA A1,E1,A1,A1,A1,A1,A1,A1
    10614 DATA A1,81,81,81,81,81,81,81
    10615 DATA 81,51,51,51,51,51,51,51
    10616 DATA 51,31,31,31,31,31,31,31
    10617 DATA F1,BF,BF,BF,BF,BF,BF,BF
    10618 DATA 11,91,71,71,71,71,91,91
    10619 DATA 91,91,91,91,91,91,91,91
    10620 DATA 7F,7F,75,75,85,75,7F,7F
    10621 DATA A1,A1,A1,A1,A1,A1,A1,A1
    10622 DATA D1,D9,D9,D9,D9,D9,D9,D9
    10623 DATA 61,D6,D6,D6,D6,D6,D6,D6

10690 return






1 'Render map, pintar mapa
    1 'la pantalla en screen 2:
    1 'El mapa se encuentra en la dirección 6144 / &h1800 - 6912 /1b00'
    1 'Eliminamos los enemigos si quedan'
    11000 gosub 6700
    11010 md=6144
    1 'Lectora de mapa con un dígito'
    1 '11020 for f=0 to 19
    1 '    11030 READ D$
    1 '    11040 for c=0 to 19
    1 '        11050 tn$=mid$(D$,c+1,1)
    1 '        11060 tn=val(tn$)
    1 '        11070 VPOKE md+c,tn
    1 '    11160 next c
    1 '    11170 md=md+32
    1 '11180 next f
    1 'Lectura de mapa con 2 dígitos'
    1 'El mapa lo he dibujado con tilemap con 20x20 tiles de 8 pixeles'
    11020 for f=0 to 19
        11030 READ mp$
        1 ' ahora leemos las columnas c
        11040 for c=0 to 39 step 2
            11050 tn$=mid$(mp$,c+1,2)
            11060 tn=val("&h"+tn$)
            11070 VPOKE md,tn:md=md+1
        11160 next c
        1 'Bajamos la fila'
        11170 md=md+12
    11180 next f
11190 return

1 'level 0'



12000 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
12010 data 0e1404000000000000000000000000000000000e
12020 data 0e0004000d070707070c000000160d07070c000e
12030 data 0e0004000400000000040000000004120004000e
12040 data 0e0004000400001500030708000004130004000e
12050 data 0e000a070b00000000040000000004000004000e
12060 data 0e000000000000000004000907070b000004000e
12070 data 0e0707070707070c00040000000000000004000e
12080 data 0e00000000000004000a070707070707070b000e
12090 data 0e0015000016000400000000000000000000000e
12100 data 0e00000000000004000d0707070707070708000e
12110 data 0e000d070800000400040000000000000000000e
12120 data 0e00040000000004000a070707070c000907070e
12130 data 0e0004000d07070b00000000000004000000000e
12140 data 0e000400041400000009070c000004000000000e
12150 data 0e0004000a07070c0000000400000a07070c000e
12160 data 0e0004000000000400000004000000000004000e
12170 data 0e000a07070707030707070b001600000004000e
12180 data 0e0000000000000000000000000000000004140e
12190 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00



1 'level 1'





12200 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
12210 data 0e0000000000000000090708000000000000000e
12220 data 0e1409070707070c0000000000000d070708000e
12230 data 0e0708000000000907070707080004000004000e
12240 data 0e0000000000000000000000040004000004000e
12250 data 0e00000907070707070c0000060004000004000e
12260 data 0e0500040000000000040000001404000004000e
12270 data 0e04000400000000000400000d0706000004000e
12280 data 0e0400040005000500040000041200000004000e
12290 data 0e0400040004000400040000041300000004000e
12300 data 0e0400040004000400040000090707070706000e
12310 data 0e0400040004000400040000000000000400000e
12320 data 0e0400040004000400040009070708000400090e
12330 data 0e0400040004000400040004000000000400000e
12340 data 0e0400040006000400060707070707070708000e
12350 data 0e0600040000000400000000000000000000000e
12360 data 0e0000060205000907070707070707080000000e
12370 data 0e0000000004000000000000000000040000000e
12380 data 0e0000000009070707070707070814040000140e
12390 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00


1 'level 2'
12400 data 0004040404040404040404040404040404040400
12410 data 0600000000000000000000000000000000000007
12420 data 0600010202020202010000000102020202010007
12430 data 0600030000000000000000000000000000030007
12440 data 0600030000000000000000000000000009030007
12450 data 0600010202020202020202020202020202010007
12460 data 0600030000000000000000000000000000030007
12470 data 0600030000000009010000000100000000000007
12480 data 0600010202020202010000000102020202020207
12490 data 0600000000000000030000000308000000000007
12500 data 0600000000000000030000000300000000000007
12510 data 0600010202020202010000000102020202010007
12520 data 0600030000000000010000000100000000030007
12530 data 0600030000000000000000000000000000030007
12540 data 0600020202020202020202020202020200020007
12550 data 0602010000000000000000000000000000030007
12560 data 0600000000000000010000010900000000030007
12570 data 0600010202020202010000010202020202010007
12580 data 0600000000000000000000000000000000000007
12590 data 0005050505050505050505050505050505050500

1 '12400 data 44444444444444444444
1 '12410 data 60000000000000000007
1 '12420 data 60322222300032222307
1 '12430 data 60300000000000000307
1 '12440 data 60300000000000009307
1 '12450 data 60222222222222222207
1 '12460 data 60300000000000000307
1 '12470 data 60300009300030000007
1 '12480 data 60322222200022222327
1 '12490 data 60000000300038000007
1 '12500 data 60000000300030000007
1 '12510 data 60322222200022222307
1 '12520 data 60300000300030000307
1 '12530 data 60300000000000000307
1 '12540 data 60222222222222220207
1 '12550 data 62300000000000000307
1 '12560 data 60000000300390000307
1 '12570 data 60322222200222222307
1 '12580 data 60000000000000000007
1 '12590 data 55555555555555555555



1 'level 3'

12600 data 0004040404040404040404040404040404040400
12610 data 0600000000000009030000000300000000000007
12620 data 0600020201020202010202020102020001020207
12630 data 0600000003000000030000000000000003000007
12640 data 0600000000000000000000000300000003000007
12650 data 0600020201020202010202020102020201020207
12660 data 0600000003000000030000000000000903000007
12670 data 0600000000000000030000000300000000000007
12680 data 0602020001020002010202000102020001020207
12690 data 0600000003000000030000000300000003000007
12700 data 0600000003000000030000000300000003000007
12710 data 0600020201020202010002020102020201020207
12720 data 0600000000000000030000000300000003000007
12730 data 0600000003000000000000000000000000000007
12740 data 0602020201020200010202020102020201020007
12750 data 0600000003000000030000000300000003000007
12760 data 0600000000000000030000000000000003000007
12770 data 0602020001020202010202020102020201000207
12780 data 0600000000000009030000000308000000000007
12790 data 0005050505050505050505050505050505050500

1 '12600 data 04444444444444444440
1 '12610 data 60000009300030000007
1 '12620 data 60221222122212201227
1 '12630 data 60003000300000003007
1 '12640 data 60000000000030003007
1 '12650 data 60221222122212221227
1 '12660 data 60003000300000093007
1 '12670 data 60000000300030000007
1 '12680 data 62201202122012201227
1 '12690 data 60003000300030003007
1 '12700 data 60003000300030003007
1 '12710 data 60221222102212221227
1 '12720 data 60000000300030003007
1 '12730 data 60003000000000000007
1 '12740 data 62221220122212221207
1 '12750 data 60003000300030003007
1 '12760 data 60000000300000003007
1 '12770 data 62201222122212221027
1 '12780 data 60000009300038000007
1 '12790 data 05555555555555555550



1 'level 4'
12800 data 0404040404040404040404040404040404040404
12810 data 0602000000020000000202090000000000000207
12820 data 0600020000030000000202000002030000020007
12830 data 0600000200030002000000000200000002000007
12840 data 0600000002030000020000020000030000000007
12850 data 0600020202020200020202020202020202020007
12860 data 0600020000030200000000000002030000020007
12870 data 0600000200030002000000000209030002000007
12880 data 0600000002030000020800020000030200000007
12890 data 0602020000030000000202000000030000020207
12900 data 0602020000000000000202000000030000020207
12910 data 0600000000030000020000020000030200000007
12920 data 0600000200030002000000000200030000000007
12930 data 0600020000030200000000000000000002020007
12940 data 0600020202020200020202020202020202020007
12950 data 0600000002030000020000020000030200000007
12960 data 0600000000000002000000000200000002000007
12970 data 0600020000030200000202000002030000020907
12980 data 0602000000000000000202000000030000000207
12990 data 0505050505050505050505050505050505050505

1 '12800 data 44444444444444444444
1 '12810 data 62000200022900000027
1 '12820 data 60200300022002300207
1 '12830 data 60020302000020002007
1 '12840 data 60002300200200300007
1 '12850 data 60222220222222222207
1 '12860 data 60200320000002300207
1 '12870 data 60020302000029302007
1 '12880 data 60002300280200320007
1 '12890 data 62200300022000300227
1 '12900 data 62200000022000300227
1 '12910 data 60000300200200320007
1 '12920 data 60020302000020300007
1 '12930 data 60200320000000002207
1 '12940 data 60222220222222222207
1 '12950 data 60002300200200320007
1 '12960 data 60000002000020002007
1 '12970 data 60200320022002300297
1 '12980 data 62000000022000300027
1 '12990 data 55555555555555555555


1 'world 1'
1 'level 5'
13000 data 11111111111111111111
13010 data 10100000000000000001
13020 data 10100111110011111101
13030 data 10100100010010000101
13040 data 10100100010010000101
13050 data 10100100010010000101
13060 data 10100100010011110101
13070 data 10111100010000000101
13080 data 10000000011111111101
13090 data 10000111000000000101
13100 data 10000101001111111111
13110 data 11111101001000100001
13120 data 10000001001000100001
13130 data 10111001001000000001
13140 data 10100000001011111001
13150 data 10100111111010001001
13160 data 10100000000010011001
13170 data 10111111111110000001
13180 data 10000000000000000001
13190 data 11111111111111111111
1 'level 6'
13200 data 11111111111111111111
13210 data 10100000000000000001
13220 data 10100111110011111101
13230 data 10100100010010000101
13240 data 10100100010010000101
13250 data 10100100010010000101
13260 data 10100100010011110101
13270 data 10111100010000000101
13280 data 10000000011111111101
13290 data 10000111000000000101
13300 data 10000101001111111111
13310 data 11111101001000100001
13320 data 10000001001000100001
13330 data 10111001001000000001
13340 data 10100000001011111001
13350 data 10100111111010001001
13360 data 10100000000010011001
13370 data 10111111111110000001
13380 data 10000000000000000001
13390 data 11111111111111111111
1 'level '
13400 data 11111111111111111111
13410 data 10100000000000000001
13420 data 10100111110011111101
13430 data 10100100010010000101
13440 data 10100100010010000101
13450 data 10100100010010000101
13460 data 10100100010011110101
13470 data 10111100010000000101
13480 data 10000000011111111101
13490 data 10000111000000000101
13500 data 10000101001111111111
13510 data 11111101001000100001
13520 data 10000001001000100001
13530 data 10111001001000000001
13540 data 10100000001011111001
13550 data 10100111111010001001
13560 data 10100000000010011001
13570 data 10111111111110000001
13580 data 10000000000000000001
13590 data 11111111111111111111
1 'level 8'
13600 data 11111111111111111111
13610 data 10100000000000000001
13620 data 10100111110011111101
13630 data 10100100010010000101
13640 data 10100100010010000101
13650 data 10100100010010000101
13660 data 10100100010011110101
13670 data 10111100010000000101
13680 data 10000000011111111101
13690 data 10000111000000000101
13700 data 10000101001111111111
13710 data 11111101001000100001
13720 data 10000001001000100001
13730 data 10111001001000000001
13740 data 10100000001011111001
13750 data 10100111111010001001
13760 data 10100000000010011001
13770 data 10111111111110000001
13780 data 10000000000000000001
13790 data 11111111111111111111
1 'level 9'
13800 data 11111111111111111111
13810 data 10100000000000000001
13820 data 10100111110011111101
13830 data 10100100010010000101
13840 data 10100100010010000101
13850 data 10100100010010000101
13860 data 10100100010011110101
13870 data 10111100010000000101
13880 data 10000000011111111101
13890 data 10000111000000000101
13900 data 10000101001111111111
13910 data 11111101001000100001
13920 data 10000001001000100001
13930 data 10111001001000000001
13940 data 10100000001011111001
13950 data 10100111111010001001
13960 data 10100000000010011001
13970 data 10111111111110000001
13980 data 10000000000000000001
13990 data 11111111111111111111











