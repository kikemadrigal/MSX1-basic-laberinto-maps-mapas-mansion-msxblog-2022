10 rem ******************************
20 rem Program:  Mansion Madrigal
30 rem autor:    MSX Murcia
40 rem ******************************
50 print "!Ejecutando instrucciones"
1 'Inicilizamos el juego'
1 'Inicilizamos dispositivo: 003B, inicilizamos teclado: 003E, inicializamos el psg &h90'
1 'Enlazamos con las rutinas de apagar y encender la pantalla'
60 defusr=&h003B:a=usr(0):defusr1=&h003E:a=usr1(0):defusr2=&H90:a=usr2(0):defusr3=&h41:defusr4=&h44
1 'Esto es necesario para escribir en pantalla'
80 screen 2,0,0
90 color 1,15,7:key off
100 defint a-z:open "grp:" as #1:gosub 3000
110 print #1,"!Cargando sprites"
1 ' inicializamos los sprites'
130 gosub 9000
1 'Mostramos la pantalla de bienvenida e instrucciones'
140 cls: preset (60,10):print #1,"!Mansion Madrigal"
150 preset (60,20):print #1,"!MSX Murcia 2022"
160 preset (0,50):print #1,"!Debes de ingeniar como salir del laberinto antes de que se te acabe el tiempo"
170 preset (0,90):print #1,"!Utiliza las herramientas que tienes a ut disposicion, pulsa espacio para elegir una"
180 preset (0,130):print #1,"!Solo puedes utilizarlas una cez por mundo"
1 'Pintamos los objetos'
190 gosub 3100
200 preset (0,21*8):print #1,"!Pulsa una tecla para continuar"
210 if inkey$="" then goto 180 else cls
220 'a=usr3(0)
1 ' Inicializamos los gráficos'
230 print "!Cargando graficos"
240 gosub 10000
1 ' Pintamos el mapa'
250 gosub 11000
260 'a=usr4(0)
1 ' Mostramos el marcador'
270 gosub 3000
1 'Inicializamoz los objetos'
280 gosub 7000
1 'Pintamos los objetos'
290 gosub 3100
1 ' inicilizamos el personaje'
300 gosub 5000
1 ' inicilizamos los enemigos'
310 gosub 6000
1 'posicionamos al player y enemigos tras cargar el mapa'
320 gosub 8300
1 'Inicializamos las variables del juego
1 'tm=tiempo maximo'
1 'ta=timepo actual'
330 tm=40:time=0:interval on:on interval=50 gosub 3200
1 'Cuando se pulse el espacio o el disparo del joystick elegimos una de las herramientas'
340 strig(0) on:on strig gosub 7100
1 'Cuando haya colisión de sprites ir a la subrutina de player muere
350 'sprite on:on sprite gosub 5700

1 ' <<<<<< Main loop >>>>>'
    1 'Actualizamos el timepo'
    400 ta=tm-time/50
    1 'si no queda tiempo reiniciamos y llamamos a la rutina player muere'
    410 if ta<=0 then ta=20:time=0:gosub 5700 
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
    1 'pv=player velocidad, pp=plano player
    1020 on st gosub 1110,1120,1130,1140,1150,1160,1170
    1 'Colisones con los extremos de la pantalla'
    1030 if x<=0 then x=xp
    1040 if y<=0 then y=yp
    1050 if y+ph>192 then y=yp
    1060 if x+pw>252 then x=xp
1090 RETURN
1 '1 arriba'
1110 y=y-pv:pp=0:re=10:gosub 4000:return
1 '2'
1120 return
1 '3 derecha'
1130 x=x+pv:pp=2:re=10:gosub 4000:return
1 '4'
1140 return
1 '5 abajo'
1150 y=y+pv:pp=1:re=10:gosub 4000:return
1 '6 abajo derecha'
1160 return
1 '7 izquierda'
1170 x=x-pv:pp=3:re=10:gosub 4000:return


















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
        1490 PUT SPRITE ep(i),(ex(i),ey(i)),,es(i)
    1495 next i
1520 return

















1' '' <<< PHYSICS & COLLISION SYSTEM >>>>
    1 'Colisiones del player con el mapa'
    1 'Para detectar la colisión vemos el valor que hay en la tabla de nombres de la VRAM
    1 'En la posición x e y de nuestro player con la formula: '
    1 'Si hay una colision le dejamos la posicion que guardamos antes de cambiarla por pulsar una tecla'
    1760 hl=base(5)+(y/8)*32+(x/8):a=vpeek(hl)
    1 'Si es un tile sólido 
    1 'Si está activa la herramienta de romper bloque'
    1 '     Rompemos el bloque piendo vpoke en esa dirección'
    1 '     deshabilitamos para que no se vuelva a utilizar'
    1 '     Repintamos los objetos'
    1 '     re=10:gosub 3000 hacemos un sonido'
    1 'Si no está activa la herramienta de romper bloque'
    1'      volvemos a la posición que estábamos
    1770 if a>0 and a<8 then if os=2 and o2=1 then vpoke hl,0:o2=0:gosub 3100:re=10:gosub 3000 else x=xp: y=yp
    1 'Si el valor es un 2, es nuestro punto de fuga lo mandamos a otro sitio '
    1780 'if a=2 then x=8*16: y=8*18:beep
    1 'Si hemos llegado a la casa cambiamos de nivel'
    1790 if a=8 then re=2:gosub 4000:mc=1
    1 ' Si tocado un reloj le sumamos al tiempo el aumento o el maximo'
    1 'Hacemo una música de cogido'
    1' hacemos que desaparzca el reloj
    1800 if a=9 then tm=ta+tm:time=0:re=5:gosub 4000:vpoke hl,0
    1 'Colisiones del player con sprites de los enemigos (mirar línea 70 y 2000)'
    1810 if pc=1 then pc=0:sprite on

    1 'Fisica y Colisiones de ememigos con el mapa'
    1900 for i=1 to en
        1910 if et(i)=0 then ex(i)=ex(i)+ev(i)
        1920 if et(i)=1 then ey(i)=ey(i)+el(i)
        1930 hl=base(5)+(ey(i)/8)*32+(ex(i)/8):a=vpeek(hl)
        1 'Si es una pared le invertimos la velocidad del eje x y del eje y'
        1 'y le volvemos a poner las coordenadas antiuas '
        1 'ev=velocidad x y el velocidad eje y '
        1 'ep coordenada previa x , ei=coordenada previa y'
        1940 if a>0 and a<8 then if et(i)=0 then ev(i)=-ev(i):ex(i)=ea(i):ey(i)=ei(i) else if et(i)=1 then el(i)=-el(i):ex(i)=ea(i):ey(i)=ei(i)
        
        1 'Conservamos los datos de las posiciones antes de cambiarlos'
        1950 ea(i)=ex(i):ei(i)=ey(i)   

        1 'Si hat Colisión del player con el enemigo'
        1 '     Si está acitvado el objto 1 y habilitado'
        1 '         hacemos un sonido (re=6:4000)'
        1 '         Eliminamos al enemigo (ed=i:6600)'
        1 '         Repintamos los objetos
        1 '     Si no está activado o habilitado el objeto 1'
        1 '         Matamos al player'
        1960 if x < ex(i) + ew(i) and x + pw > ex(i) and y < ey(i) + eh(i) and y + ph > ey(i) then if os=1 and o1=1 then re=3:gosub 4000:o1=0:ed=i:gosub 6600:gosub 3100 else beep:gosub 5700
    1970 next i
1990 return















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
    3080 preset (24*8,17*8): print #1,fre(0)
3090 return




1 'pintar objetos
    3100 if o1 then PUT SPRITE 11,((22*8)-4,5*8),6,10 else PUT SPRITE 11,((22*8)-4,5*8),15,10
    3120 if o2 then PUT SPRITE 12,((22*8)-4,7*8),6,11 else PUT SPRITE 12,((22*8)-4,7*8),15,11
    3130 if o3 then PUT SPRITE 13,((22*8)-4,9*8),6,12 else PUT SPRITE 13,((22*8)-4,9*8),15,12
    3140 if o4 then PUT SPRITE 14,((22*8)-4,11*8),6,13 else PUT SPRITE 14,((22*8)-4,11*8),15,13
3190 return

1 'Pintar el tiempo'
    3200 line (25*8,15*8)-(30*8,15*9),14,bf
    3230 preset (24*8,15*8): print #1,ta
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
    1 'Inicializamos el psg para que no se quede con el úlyimo sonido'
    4000 a=usr2(0)
    4010 if re=1 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A r60 G E F D C D G R8 A2 A2 A8","o1 v4 c r8 o2 c r8 o1 v6 c r8 o2 v4 c r8 o1 c r8 o2 v6 c r8"
    4020 if re=2 then PLAY"O5 L8 V4 M8000 A A D F G2 A A A A r60 G E F D C D G R8 A2 A2 A8"
    1 'Tirando el paquete'
    4030 if re=5 then play "l10 o4 v4 g c"
    1 'Paquete cogido'
    4040 if re=6 then play"t250 o5 v12 d v9 e" 
    1 'Pitido normal'
    4050 if re=7 then play "O5 L8 V4 M8000 A A D F G2 A A A A"
    1 'Toque fino'
    4060 if re=8 then PLAY"S1M2000T150O7C32"
   
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
    1 'pm=time maximo'
    5000 x=0:y=0:xp=0:yp=0:pw=8:ph=8:pv=8:pe=3:pc=0
5020 return
1' Player muere
    1 'Le kitamos 1 vida'
    1 'Actializamos el tiempo'
    5700 pe=pe-1:pa=pa-pm:time=0
    5710 'if pe<=0 then restore 12000:close:goto 60
    1 'inicializamos objetos
    5720 'gosub 7000
    1 ' llamamos a la tutina reposicionar player y enemigos según el mapa'
    5740 gosub 8300
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
    1 'Como el espacio en la memoria lo creamos en el loader, ahora rellenamos, 
    1 'el dibujado lo hacemos en el render '
    1 'Aqui le asignamos el sprite que será el definido en el lodaer '
    1 'En lugar de ponerles valores le copiamos los valores de la entidad creada en el init'
    1 'la siguiente vez que llamemos a crear enemigo se creará en la siguiente posición del array'
    1 'Al sumarle un enemigo cuando volvamos a llamar a esta subrrutina
    1 'Creará el enemigo en la siguiente posición, pero antes fíjate en las dimensiones 
    1 'Que le reservaste en el loader.bas'

    6100 en=en+1
    6105 ex(en)=0:ey(en)=0:ea(en)=0:ei(en)=0
    6110 ev(en)=8:el(en)=8
    6130 ew(en)=8:eh(en)=8:es(en)=5:ep(en)=4+en
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
7000 os=0
7010 ox=0:oy=24
7020 o1=1:o2=1:o3=1:o4=1
7090 return

1 'Rutina seleccion al pulsar espacio'
    7100 beep:os=os+1:if os>4 then os=1
    1 'Borramos el mensaje anterior'
    7110 line (0,21*8)-(247,24*8),15,bf
    7120 oy=oy+16:if oy>88 then oy=5*8 
    7130 if os=1 and o1=1 then  preset (0,21*8):print #1,"!Seleccionada la espada: ":preset (0,22*8):print #1,"Puedes matar enemigos"
    7140 if os=2 and o2=1 then  preset (0,21*8):print #1,"!Seleccionada el rayo:":preset (0,22*8):print #1,"Puedes romper los muros"
    7150 if os=3 and o3=1 then  preset (0,21*8):print #1,"!Seleccionada la pala: ":preset (0,22*8):print #1,"Puedes dar palazos"             
    7160 if os=4 and o4=1 then  preset (0,21*8):print #1,"!Seleccionada la fuerza: " :preset (0,22*8):print #1,"Puedes mover los bloques amarillos"
    7170 PUT SPRITE 10,((22*8)-4,oy),1,9
    1 'debug'
    7180 gosub 3300
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
    1 'Eliminamos todos los enemigos si los hay'
    8300 gosub 6700
    8310 if ms=0 then x=5*8:y=8*8:gosub 6100:ex(en)=15*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=12*8:ey(en)=16*8:et(en)=1
    8320 if ms=1 then x=2*8:y=12*8:gosub 6100:ex(en)=10*8:ey(en)=10*8:et(en)=0:gosub 6100:ex(en)=7*8:ey(en)=4*8:et(en)=0
    8330 if ms=2 then x=7*8:y=9*8:gosub 6100:ex(en)=10*8:ey(en)=1*8:et(en)=0:gosub 6100:ex(en)=10*8:ey(en)=10*8:et(en)=1
    8340 if ms=3 then x=18*8:y=1*8:gosub 6100:ex(en)=10*8:ey(en)=4*8:et(en)=0:gosub 6100:ex(en)=10*8:ey(en)=13*8:et(en)=0
    8350 if ms=4 then x=2*8:y=12*8:gosub 6100:ex(en)=1*8:ey(en)=11*8:et(en)=1:gosub 6100:ex(en)=16*8:ey(en)=12*8:et(en)=0
    1 'Mostramos la información'
    8380 gosub 3000
8390 return

1 'Rutina cargar sprites con datas basic'
    1 ' vamos a meter 5 definiciones de sprites nuevos que serán 4 para el personaje y uno para la bola'
    9000 FOR I=0 TO 13:SP$=""
        9020 FOR J=1 TO 8:READ A$
            9030 SP$=SP$+CHR$(VAL("&H"+A$))
        9040 NEXT J
        9050 SPRITE$(I)=SP$
    9060 NEXT I
    9070 DATA 18,18,66,5A,5A,24,24,66
    9080 DATA 18,18,24,3C,3C,18,18,3C
    9090 DATA 18,18,10,18,1C,18,18,1C
    9100 DATA 18,18,08,18,38,18,18,38
    9110 DATA E3,E3,E3,3E,3E,3E,F9,F9
    9120 DATA 18,3C,66,42,C3,C3,C3,FF
    9130 DATA 00,00,00,3C,42,FF,FF,FF
    9140 DATA 81,DB,3C,18,18,66,42,C3
    9150 DATA 00,18,7E,5A,18,24,24,66
    9160 DATA FF,81,81,81,81,81,81,FF
    9170 DATA 01,02,04,88,50,20,D0,C8
    9180 DATA 07,0E,38,70,0E,1C,70,E0
    9190 DATA 0C,0C,0C,0C,0C,06,0F,0F
    9200 DATA 00,23,33,FB,FB,33,23,00

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

    1 'Definiremos a partir de la posición 0 de la VRAM 18 tiles de 8 bytes'
        10000 FOR I=0 TO (10*8)-1
        10020 READ A$
        10030 VPOKE I,VAL("&H"+A$)
        10040 VPOKE 2048+I,VAL("&H"+A$)
        10050 VPOKE 4096+I,VAL("&H"+A$)
    10060 NEXT I


    10070 DATA 00,00,00,00,00,00,00,00
    10080 DATA FF,FF,FF,FF,FF,FF,FF,FF
    10090 DATA FF,FF,FF,00,00,FF,FF,FF
    10100 DATA E7,E7,E7,E7,E7,E7,E7,E7
    10110 DATA 00,F7,F7,F7,00,7F,7F,7F
    10120 DATA FB,FB,FB,00,BF,BF,BF,00
    10130 DATA 77,07,77,77,77,70,77,77
    10140 DATA EE,EE,0E,EE,EE,EE,E0,EE
    10150 DATA 18,3C,7E,7E,24,7E,7E,7E
    10160 DATA 18,3C,7E,81,1C,7E,3C,18

    1 'Definición de colores, los colores se definen a partir de la dirección 8192/&h2000'
    1 'Como la memoria se divide en 3 bancos, la parte de arriba en medio y la de abajo hay que ponerlos en 3 partes'
    10500 FOR I=0 TO (10*8)-1
        10520 READ A$
        10530 VPOKE 8192+I,VAL("&H"+A$): '&h2000'
        10540 VPOKE 10240+I,VAL("&H"+A$): '&h2800'
        10550 VPOKE 12288+I,VAL("&H"+A$): ' &h3000'
    10560 NEXT I

    10570 DATA 11,11,11,11,11,11,11,11
    10580 DATA A1,A1,A1,A1,A1,A1,A1,A1
    10590 DATA A1,A1,E1,E1,E1,E1,A1,A1
    10600 DATA A1,A1,A1,A1,A1,A1,A1,A1
    10610 DATA A1,81,81,81,81,81,81,81
    10620 DATA 81,81,81,81,81,81,81,81
    10630 DATA 81,81,81,81,81,81,81,81
    10640 DATA 81,81,81,81,81,81,81,81
    10650 DATA 41,41,41,91,79,91,91,91
    10660 DATA 71,51,51,75,85,51,51,71

10690 return






1 'Render map, pintar mapa
    1 'la pantalla en screen 2:
    1 'El mapa se encuentra en la dirección 6144 / &h1800 - 6912 /1b00'
    1 'Eliminamos los enemigos si quedan'
    11000 gosub 6700
    1 'El +32 es paa bajar el mapa un poco abajo'
    11010 md=6144
        1 'El mapa lo he dibujado con tilemap con 20x20 tiles de 8 pixeles'
        11020 for f=0 to 19
            11030 READ D$
            1 ' ahora leemos las columnas c
            11040 for c=0 to 19
                11050 tn$=mid$(D$,c+1,1)
                11060 tn=val(tn$)
                11070 VPOKE md+c,tn
            11160 next c
            1 'Bajamos la fila'
            11170 md=md+32
        11180 next f
11190 return



1 'level 0'

12000 data 04444444444444444440
12010 data 69300000000000000007
12020 data 60301222210001122107
12030 data 60303000030000380307
12040 data 60303000032200300307
12050 data 60121000030000300307
12060 data 60000000030222100307
12070 data 62222221030000000307
12080 data 60000003012222222107
12090 data 60000003000000000007
12100 data 60000003012222222207
12110 data 60122003030000000007
12120 data 60300003012222102227
12130 data 60301221000000300007
12140 data 60303900022100300007
12150 data 60301221000300122107
12160 data 60300003000300000307
12170 data 60122221222100000307
12180 data 60000000000000000397
12190 data 05555555555555555550

1 'level 1'

12200 data 04444444444444444440
12210 data 60000000022200000007
12220 data 69122221000000122107
12230 data 62100001222210000307
12240 data 60000000000030000307
12250 data 60012222210030000307
12260 data 63030000030032210307
12270 data 63030000030000930307
12280 data 63030121030012230307
12290 data 63030303030038000307
12300 data 63030303030012221107
12310 data 63030303030000003007
12320 data 63030303030122203037
12330 data 63030303030300003007
12340 data 63030303012222222107
12350 data 63030003000000000007
12360 data 60012101222222210307
12370 data 60000300000000030307
12380 data 61000000222222012197
12390 data 05555555555555555550


1 'level 2'

12400 data 44444444444444444444
12410 data 60000000000000000007
12420 data 60322222300032222307
12430 data 60300000000000000307
12440 data 60300000000000009307
12450 data 60222222222222222207
12460 data 60300000000000000307
12470 data 60300009300030000007
12480 data 60322222200022222327
12490 data 60000000300038000007
12500 data 60000000300030000007
12510 data 60322222200022222307
12520 data 60300000300030000307
12530 data 60300000000000000307
12540 data 60222222222222220207
12550 data 62300000000000000307
12560 data 60000000300390000307
12570 data 60322222200222222307
12580 data 60000000000000000007
12590 data 55555555555555555555



1 'level 3'

12600 data 04444444444444444440
12610 data 60000009300030000007
12620 data 60221222122212201227
12630 data 60003000300000003007
12640 data 60000000000030003007
12650 data 60221222122212221227
12660 data 60003000300000093007
12670 data 60000000300030000007
12680 data 62201202122012201227
12690 data 60003000300030003007
12700 data 60003000300030003007
12710 data 60221222102212221227
12720 data 60000000300030003007
12730 data 60003000000000000007
12740 data 62221220122212221207
12750 data 60003000300030003007
12760 data 60000000300000003007
12770 data 62201222122212221027
12780 data 60000009300038000007
12790 data 05555555555555555550



1 'level 4'


12800 data 44444444444444444444
12810 data 62000200022900000027
12820 data 60200300022002300207
12830 data 60020302000020002007
12840 data 60002300200200300007
12850 data 60222220222222222207
12860 data 60200320000002300207
12870 data 60020302000029302007
12880 data 60002300280200320007
12890 data 62200300022000300227
12900 data 62200000022000300227
12910 data 60000300200200320007
12920 data 60020302000020300007
12930 data 60200320000000002207
12940 data 60222220222222222207
12950 data 60002300200200320007
12960 data 60000002000020002007
12970 data 60200320022002300297
12980 data 62000000022000300027
12990 data 55555555555555555555


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











