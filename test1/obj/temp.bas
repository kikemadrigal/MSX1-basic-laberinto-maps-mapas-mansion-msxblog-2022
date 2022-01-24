1 '' ******************************
1 '' Program:  Msx mansion
1 '' autor:    MSX Murcia
1 '' ******************************
1 ''ex,ey,ea,ei,ev,ew,eh,es,ec,ep
1 ''bx,by,ba,bi,bv,bl,bw,bh,bs,bc,bp,bt
1 ''90, 1000: tn,ta,tf,gs,st
1 ''5000:x,y,xp,yp,pw,ph,pv,pe,pd,pp,p0,p1,p2,p3,p4,p5,p6,p7
1 ''7000: os:oy,o1,o2,o3,o4,o5
1 ''8000:mw,ms,mp,md,tn,tn$,i,j,sp$,a$
1 ''gs(100),tm(90),td(90),ta(90),time(396)
1 ''
1 ''
5 rem !Inicialización / initialization
10 cls:color 1,15,7:key off
1 ''
1 ''
1 'Inicilizamos el juego'
1 'Inicilizamos dispositivo: 003B, inicilizamos teclado: 003E, inicializamos el psg &h90'
1 'Enlazamos con las rutinas de apagar y encender la pantalla'
20 defusr=&h003B:a=usr(0):defusr1=&h003E:a=usr1(0):defusr2=&H90:a=usr2(0):defusr3=&h41:defusr4=&h44
1 'Color caracteres, fondo, borde'
30 screen 2,0,0
1 'Todas las variables serán enteras'
40 defint a-z
1 'Definimos un canal necesario para poder mostrar texto, habrá que poner en el print o input #1'
50 open "grp:" as #1
1 'Inicializamos el mapa'
1 '51 gosub 8000
1 'Cargamos el buffer con el mapa'
1 '52 gosub 8100
1 ' inicilizamos el personaje'
60 gosub 5000
1 'Cargamos los sprites en VRAM'
70 gosub 9000
1 'Inicializamos las variables del juego
1 'tm=tiempo maximo'
1 'ta=timepo actual'
1 'tf=diferencia entre el timepo actual y el que queda'
90 tm=40:tf=0
1 'Gs=game status, si es 0 mostraremos el menu de bienvenida, si es 1 vamos al main loop, y 2, pantalla ganadora'
100 gs=0
1 'Inicializamos la música
110 gosub 3500
1 'Habilitamos la interrupción del stop
1 'Al pulsar la tecla Stop (mayuscula o shift izquierdo + F8 en openMSX o Mayúscula + suprimir en BlueMSX) se termina el juego'
120 stop on:on stop gosub 140
130 gs=0:goto 200
1 'Rutina reiniciar parida'
    140 gosub 900
    150 gs=0:goto 200
160 return

    180 gs=1:goto 200
190 return

195 rem <<<<<<<<!Bucle o máquina de estados / loop or state machine>>>>>>>>>>>>>
    200 if gs=0 then 300 
    210 if gs=1 then 600
    220 if gs=2 then 500


    1 'Mostramos la pantalla de bienvenida e instrucciones'
    300 screen 2:strig(0) on:on strig gosub 180
    1 'Vamos a pintar la casa'
    1 'b=desplazamos el lapiz de forma absoluta y sin dibujar la trayectoria 40 pixeles eje x y 160 eje y  '
    1 'c= le ponemos el valor negro=1'
    1 'u= arriBa,d= abajo,l izquierda,r= derecha,e= diagonal arriba derecha, f= diagonal abajo derecha,g= diagonal abajo izquierda,h=diagonal arriba izquierda'
    1 'u=up,le decimos que dibuje 100 pixeles hacia arriba'
    1 'Dibujamos el cielo y la tierra'
    310 draw("bm0,50 c9 r14 d11 r219 u11 r23 d20 l256 u20 c7 u50 r260 d27 l260")
    1 'Dibujamos la casa'
    320 draw ("bm20,40 c4 e10 f10 r20 e10 f10 r20 e10 r40 f10 r20 e10 f10 r20 e10 f10 r5 h12 l210 g12 r230 l10 c11 d20 l210 u19 r210")
    1 'Dibujamos las ventanas'
    330 a$="r5d5l5u5":draw("bm30,45xa$;"):draw("bm60,45xa$;"):draw("bm90,45xa$;"):draw("bm120,45xa$;"):draw("bm150,45xa$;"):draw("bm180,45xa$;"):draw("bm210,45xa$;")
    1 'Dibujamos la puerta'
    340 draw("bm120,50r5d10l5u10")
    1 'Paint (coordenada_x, coordenada_y), color_interior, color_borde'
    1 'Pintamos el cielo y la tierra'
    350 paint (2,2),7,7:paint (2,65),9,9
    360 paint (100,35),4,4:paint (23,55),11,11
    370 preset (80,0):print #1,"!MSX mansion"
    380 preset (70,10):print #1,"!MSX Murcia 220"
    385 preset (30,18):print #1,"!Music Gabriel Caffarena"
    390 preset (0,70):print #1,"!Debes de ingeniar como salir de la mansion antes de que se te   acabe el tiempo"
    400 preset (0,100):print #1,"!Utiliza las herramientas que    tienes a tu disposicion, pulsa  espacio para elegir una."
    440 preset (0,130):print #1,"!Solo puedes utilizarlas una vez por mundo."
    450 preset (0,150):print #1,"!Pulsa stop para terminar la     partida."
    455 preset (0,170):print #1,"!Espacio pulsado salta musica."
    460 line (0,180)-(256,188),15,bf: preset (0,180):preset (0,180):print #1,"!Espera a que termine la musica."

    465 re=1:gosub 4000
    1 'Si no ponemos este for la ñultima parte de la música se corta'
    470 for i=0 to 1000: next i:line (0,180)-(256,188),15,bf: preset (0,180):print #1,"!Pulsa espacio para continuar"
    1 'Pasados unos segundos volverá a escucharse la música'
    480 co=co+1:if strig(0)=-1 then gs=1:goto 200 else if co<700 then 480 else co=0:goto 460

    500 screen 2
    510 gosub 900
    520 preset (60,10):print #1,"!Has ganado!!!!"
    530 preset (60,20):print #1,"!MSX Murcia 2022"
    540 preset (0,50):print #1,"!Desarrolador: Kike Madrigal"
    550 preset (0,70):print #1,"!Email: Kikemadrigal@hotmail.com"
    560 preset (0,90):print #1,"!Muchas gracias por probar       nuestro juego     :)"
    570 preset (0,180):print #1,"!Pulsa espacio para continuar"
    580 if strig(0)=-1 then gs=0:goto 200 else goto 580
1 '<<<<<<<< FInal del bucle de estados>>>>>>>>>>>>>'


600 rem !inicio partida / start game
1 'Apagamos la pantalla'
605 cls:a=usr3(0)
1 'Inicializamos al player, pe=player energia son las vidas'
610 pe=3
1 ' Inicializamos los gráficos'
620 gosub 10000
1 'Borramos los gráficos que han salido en la pantalla'
630 for i=0 to 19:vpoke (6144+20)+i*32,3:vpoke (6144+21)+i*32,3:vpoke (6144+22)+i*32,3:vpoke (6144+23)+i*32,3:next i
1 ' Pintamos el mapa'
640 gosub 11000
1 'Inicializamos los objetos'
650 gosub 7000
1 'Pintamos los objetos'
660 gosub 3100
661 gosub 7100
1 'posicionamos al player y enemigos tras cargar el mapa'
680 gosub 8300
1 'Cada segundo repintamos el tiempo'
690 interval on:on interval=100 gosub 3200
1 'Habilitamos las interrupciones de disparo y le decimos con el 0 que son las de la barra epaciadora'
1 'Cuando se pulse espacio llamremos a la rutina de selección de objetos'
700 strig(0) on:on strig gosub 7100
1 ' Mostramos el marcador'
710 gosub 3000
1 'inicializamos el contador de tiempo'
720 time=0:ta=1
1 'Encendemos la pantalla'
730 a=usr4(0)





800 rem  !<<<<<< Main loop >>>>>'
    1'Si al player no le quedan vidas llamamos a la rutina reiniciar partida (900), esa rutina también es llamada cuando se pulsa stop y cuando se gana'
    805 if pe<=0 then gosub 900:gs=0:goto 200
    1 'si no queda tiempo reiniciamos y llamamos a la rutina player muere'
    810 if ta<=0 then tf=1:gosub 5700 


    1 'Actualizamos el sistema de input'
    820 'gosub 1000
    821 st=stick(0) or stick(1) or stick(2)
    822 if stick(0)>0 then xp=x:yp=y
    823 on st goto 825,826,827,828,829,830,831,832
    824 goto 834
    825 y=y-pv:ps=p(0):swap p(0),p(1):pd=1:goto 833
    826 y=y-pv:x=x+pv:ps=p(0):swap p(0),p(1):pd=1:goto 833
    827 x=x+pv:ps=p(2):swap p(2),p(3):pd=3:goto 833
    828 y=y+pv:x=x+pv:ps=p(4):swap p(4),p(5):pd=5:goto 833
    829 y=y+pv:ps=p(4):swap p(4),p(5):pd=5:goto 833
    830 x=x-pv:y=y+pv:ps=p(4):swap p(4),p(5):pd=5:goto 833
    831 x=x-pv:ps=p(6):swap p(6),p(7):pd=7:goto 833
    832 x=x-pv:y=y-pv:ps=p(0):swap p(0),p(1):pd=1:goto 833
    833 re=10:gosub 4000


    1 'Actualizamos el sistema de fisicas, colisiones y render'
    834 gosub 1760
    1 'Actualizamos sistema del render
    1 '440 gosub 1400
    1 'Si el mapa cambia:
    1 '     Aumentamos el ms=mapa screen'
    1 '     Conservamos el tiempo para después sumarlo'
    1 '     Ponemos la bandera que indica el cambio de mapa bien'
    1 '     Sacamos al player de la pantalla'
    1 '     Hacemos un sonido'
    1 'Si llegamos pasamos la pantalla final mostramos la pantalla ganadora'
    1 '     hacemos un sonido (re,4000)'
    1 '     Pintamos el nuevo mapa (11000)'
    1 '     Pintamos la información (3000) para indicar el nivel'
    1 '     Posicionamos al jugador y enemigos (8300)'
    1 '     Desactivamos la bandera de cambio de mapa'
    1 '     Reinicamos el contador de tiempo'
    1 '     Si el ms es igual a 3'
    1 ''             aumentamos el mundo y ponemos a 0 el screen'
    1 ''             Reiniciaos los objetos para porder volver a utilizarlos (7000)'
    1 '              Pintamos la información del nivel, mundo,etc (3000)'
    1 '              Repintamos los objetos (3100)'
    1 '480 if mc then ms=ms+1:tf=ta:time=0:gosub 11000:mc=0:if ms=3 then mw=mw+1:ms=0:gosub 7000:gosub 3000:gosub 3100:gosub 8300 else gosub 3000:gosub 8300
    840 if mc then ms=ms+1:tf=ta:time=0:mc=0:put sprite 0,(0,212),0,0:re=2:gosub 4000:if mw=2 and ms=3 then gs=2:goto 200 else gosub 11000 :if ms=3 then mw=mw+1:ms=0:gosub 7000:gosub 3000:gosub 3100:gosub 8300 else gosub 3000:gosub 8300
    1 'debug'
    1 '850 gosub 3400
890 goto 800 
1 ' <<<<<< Final del Main loop >>>>>'


1 'Game over'
1 'Rutina terminar partida, llamada cuando no quedan vidas, con la tecla stop o cuando se ha ganado el juego'
1 'Tenemos que colocar el punturo del mapa en el world0, level0'
1 'Desactivamos el repintado y actualización del tiempo'
1 'Eliminamos a los enemigos (6600)'
1 'Sacamos al player de la pantalla'
1 'sacamos el sprite de selección de objetos'
1 'Volvemos los objetos a su configuración inicial (7000)'
1 'Ponemos el mundo y el nivel a 0'
    900 restore 10100:interval off:gosub 6600:PUT SPRITE 0,(0,212),1,0:PUT SPRITE 20,(0,212),1,0:gosub 7000:mw=0:ms=0
    910 screen2: re=3: gosub 4000:preset(100,100):print #1,"!Game over"
    920 for i=0 to 4000:next i
930 return

1 '1' <<<< INPUT SYSTEM con gosub>>>>
1 '    1000 st=stick(0) or stick(1) or stick(2)
1 '    1 'xp= posicion x previa player, yp=posición y previaplayer'
1 '    1 'Conservamos la posición previa para las colisiones'
1 '    1010 xp=x:yp=y
1 '    1020 on st gosub 1110,1120,1130,1140,1150,1160,1170,1180
1 '1090 RETURN
1 '1 'ps=plyer sprite'
1 '1 'pv=player velocidad
1 '1 'pd=player dirección'
1 '1 '1 arriba'
1 '1110 y=y-pv:ps=p(0):swap p(0),p(1):pd=1:re=10:gosub 4000:return
1 '1 '2 arriba derecha'
1 '1120 y=y-pv:x=x+pv:ps=p(0):swap p(0),p(1):pd=1:re=10:gosub 4000:return
1 '1 '3 derecha'
1 '1130 x=x+pv:ps=p(2):swap p(2),p(3):pd=3:re=10:gosub 4000:return
1 '1 '4 abajo derecha'
1 '1140 y=y+pv:x=x+pv:ps=p(4):swap p(4),p(5):pd=5:re=10:gosub 4000:return
1 '1 '5 abajo'
1 '1150 y=y+pv:ps=p(4):swap p(4),p(5):pd=5:re=10:gosub 4000:return
1 '1 '6 abajo izquierda'
1 '1160 x=x-pv:y=y+pv:ps=p(4):swap p(4),p(5):pd=5:re=10:gosub 4000:return
1 '1 '7 izquierda'
1 '1170 x=x-pv:ps=p(6):swap p(6),p(7):pd=7:re=10:gosub 4000:return
1 '1 '8 arriba izquierda'
1 '1180 x=x-pv:y=y-pv:ps=p(0):swap p(0),p(1):pd=1:re=10:gosub 4000:return




1 '1' <<<< INPUT SYSTEM cn goto >>>>
1 '    1000 st=stick(0) or stick(1) or stick(2)
1 '    1005 if stick(0)>0 then xp=x:yp=y
1 '    1010 on st goto 1110,1120,1130,1140,1150,1160,1170,1180
1 '    1030 goto 1290
1 '    1110 y=y-pv:ps=p(0):swap p(0),p(1):pd=1:goto 1280
1 '    1120 y=y-pv:x=x+pv:ps=p(0):swap p(0),p(1):pd=1:goto 1280
1 '    1130 x=x+pv:ps=p(2):swap p(2),p(3):pd=3:goto 1280
1 '    1140 y=y+pv:x=x+pv:ps=p(4):swap p(4),p(5):pd=5:goto 1280
1 '    1150 y=y+pv:ps=p(4):swap p(4),p(5):pd=5:goto 1280
1 '    1160 x=x-pv:y=y+pv:ps=p(4):swap p(4),p(5):pd=5:goto 1280
1 '    1170 x=x-pv:ps=p(6):swap p(6),p(7):pd=7:goto 1280
1 '    1180 x=x-pv:y=y-pv:ps=p(0):swap p(0),p(1):pd=1:goto 1280
1 '    1280 re=10:gosub 4000
1 '1290 return












1 '1 '' <<< RENDER SYSTEM >>>>
1 '    1 'Pintamos de nuevo el player con la posición, el color y el plano(dibujitos de izquierda, derecha..)'
1 '    1400 PUT SPRITE 0,(x,y),1,ps
1 '    1410 if en=0 then return
1 '    1 'dibujamos los enemigos, sin el for ser ve más claro'
1 '    1430 for i=1 to en
1 '        1 'Esto es para animar los muñegotes'
1 '        1440 ec(i)=ec(i)+1:if ec(i)>1 then ec(i)=0
1 '        1450 if et(i)=0 then if ec(i)=0 then es(i)=8 else es(i)=9
1 '        1460 if et(i)=1 then if ec(i)=0 then es(i)=10 else es(i)=11
1 '        1490 PUT SPRITE ep(i),(ex(i),ey(i)),eo(i),es(i)
1 '    1495 next i
1 '1520 return
















1760 rem !<<< PHYSICS, COLLISION SYSTEM & RENDER>>>>
    1 '<<<<<<<<< Player >>>>>>>>>>>'
    1 'Collision screen'
    1 '---------------'

    1761 if x<=0 then x=xp:if y<=0 then y=yp
    1762 if y+ph>160 then y=yp
    1763 if x+pw>160 then x=xp

    1 'Colisiones del player con el mapa'
    1 '----------------------------------'
    1 'Para detectar la colisión vemos el valor que hay en la tabla de nombres de la VRAM
    1 'En la posición x e y de nuestro player con la formula: '
    1 'Si hay una colision le dejamos la posicion que guardamos antes de cambiarla por pulsar una tecla'
    1 'Colisones con los extremos o bordes de la pantalla'
    1 'xp, yp posición x previa, posición y previa'
    1764 md=6144+(y/8)*32+(x/8):a=vpeek(md)
    1 'Si es un tile sólido
    1 'Si está activa la herramienta de romper bloque'
    1 '     Rompemos el bloque piendo vpoke en esa dirección'
    1 '     deshabilitamos para que no se vuelva a utilizar'
    1 '     Repintamos los objetos para que aparezca de color blando el seleccionado (3100)'
    1 '     Hacemos un sonido (re,4000)'
    1 'Si no está activa la herramienta de romper bloque'
    1'      volvemos a la posición que estábamos
    1 '1770 if a>3 and a<17 then if os=3 and o3=1 then vpoke md,0:o3=0:gosub 3100:re=10:gosub 3000 else x=xp: y=yp
    1770 if a>3 and a<17 then if os=3 and o3=1 then vpoke md,0:o3=0:gosub 3100:re=10:gosub 4000 else if os=4 and o4=1 then o4=0:gosub 3100:re=2:gosub 3000 else x=xp: y=yp
    1 'Si ha tocado un objeto empujable'
    1 '     Desactivamos para que no se pueda elegir
    1 '     repintamos los objetos para que salga en blanco el selecionado (3100)''
    1 '     Hacemnos un música (re, 4000)'
    1 '     Le ponemos un 0 para borrarlo'
    1 '1780 if a=22 and os=5 and o5=1 then o5=0:gosub 3100:re=8:gosub 4000:vpoke md, 0:if pd=1 then vpoke 6144+((y/8)-1)*32+(x/8), 22 else if pd=3 then vpoke 6144+((y/8)*32)+1+(x/8),22 else if pd=5 then vpoke 6144+(((y/8)+1)*32)+(x/8),22 else if pd=7 then vpoke 6144+((y/8)*32)+(x/8)-1,22
    1775 if a=22 and os=5 and o5=1 then o5=0:gosub 3100:re=8:gosub 4000:vpoke md, 0:if pd=1 then vpoke 6144+((y/8)-1)*32+(x/8), 22 else if pd=3 then vpoke 6144+((y/8)*32)+1+(x/8),22 else if pd=5 then vpoke 6144+(((y/8)+1)*32)+(x/8),22 else if pd=7 then vpoke 6144+((y/8)*32)+(x/8)-1,22
    1 'Si es un tile empujable yno estaba activado el 05 volvemos atrás'
    1780 if a=22 then x=xp: y=yp
    1 'Si ha tocado monedas o dolares le sumamos 10 puntos'
    1 '     Lo borramos on vpoke dirección,0'
    1 '     Sumamos 10 puntos al pp=player points'    
    1 '     repintamos los objetos para que salga en blanco el selecionado (3100)''
    1 '     Repitamos solo los puntos (3300)'
    1781 if a=21 then re=11:gosub 4000:vpoke md,0:pp=pp+10:gosub 3100:gosub 3300
    1 'Si hemos llegado a la casa cambiamos de nivel'
    1785 if a=18 or a=19 then mc=1
    1 'Si tocado un reloj le sumamos al tiempo el aumento o el maximo'
        1 'Obtenmos lo que falta de tiempo y lo metemos en tf para después sumarlo en el contador de tiempo'
        1 'Hacemo una música de cogido'
        1' hacemos que desapaezca el reloj
    1790 if a=20 then tf=ta:time=0:re=5:gosub 4000:vpoke md,0
    1 'Si ha tocado un tile de muerte
        1 'Eliminamos al player
    1795 if a=24 then gosub 5700
    1 '' Render system player
    1 ' ---------------------'
    1 '1800 put sprite 0,(x,y),1,ps
    1 'posición player eje y, posición player eje x, número de sprite, color'
    1800 vpoke 6912,y:vpoke 6913,x:vpoke 6914,ps:vpoke 6915,1

    

    1 '<<<<<<<<< Enemies >>>>>>>>>>>'
        1 'Physics enemies'
        1 '---------------'
        1910 ex=ex+ev
        1 'si bt=0 es que el enemigo 2 se mueve horizontalmentee'
        1920 if bt=0 then by=by+bl else bx=bx+bv
        1 ' Collisions enemies with the map'
        1 '-------------------------------'
        1 'Enemigo 1'
        1930 md=base(5)+(ey/8)*32+(ex/8):a=vpeek(md)
        1 'Si es una pared o un bloque empujable 
            1 'le invertimos la velocidad del eje x y del eje y'
            1 'y le volvemos a poner las coordenadas antiguas '
            1 'ev=velocidad x y el velocidad eje y '
            1 'ep coordenada previa x , ei=coordenada previa y'
        1940 if a>3 and a<17 or a=22 then ev=-ev:ex=ea:ey=ei
        1 'Si el enemigo ha salido de la pantalla lo eliminamos'
        1945 if ex>160 or ex<=0 or ey>160 or ey<=0 then gosub 6600
        1 'Conservamos los datos de las posiciones antes de cambiarlos'
        1950 ea=ex:ei=ey
        
        1 'Enemigo 2'
        1951 md=base(5)+(by/8)*32+(bx/8):a=vpeek(md)
        1952 if a>3 and a<17 or a=22 then bl=-bl:bv=-bv:bx=ba:by=bi
        1953 if ex>160 or ex<=0 or ey>160 or ey<=0 then gosub 6600
        1954 ba=bx:bi=by

        1 'collisions enemies with the player'
        1 '-----------------------------------'
        1 'Si hay colisión del player con el enemigo'
        1 '     Hacemos un sonido'
        1 '     Si está acitvado el objeto 2 de matar enemigos y habilitado'
        1 '         hacemos un sonido (re=6:4000)'
        1 '         Eliminamos al enemigo (ed=i:6600)'
        1 '         Repintamos los objetos
        1 '     Si no está activado o habilitado el objeto 1'
        1 '         Matamos al player'
        1 'Colisión con enemigo 1'
        1 ' Si hay una colisión ponemo em=0 para que no se muestre el enemigo 1'
        1960 if x < ex + ew and x + pw > ex and y < ey + eh and y + ph > ey then em=0:gosub 2000:return
        1 'Colisión con enemigo 2'
        1961 if x < bx + bw and x + pw > bx and y < by + bh and y + ph > by then bm=0:gosub 2000:return
        
    
        1 ' Render enemies'
        1 '------------------'
        1 'Esto es para animar los muñegotes,ec=enemigo contador'
        1965 ec=ec+1:if ec>1 then ec=0
        1966 bc=bc+1:if bc>1 then bc=0
        1970 if ec=0 then es=8 else es=9
        1980 if bc=0 then bs=10 else bs=11
        1 '1990 if em=1 then PUT SPRITE ep,(ex,ey),eo,es
        1 'posición player eje y, posición player eje x, número de sprite, color'
        1990 if em=1 then vpoke 6952,ey:vpoke 6953,ex:vpoke 6954,es:vpoke 6955,eo
        1 '1995 if bm=1 then PUT SPRITE bp,(bx,by),bo,bs
        1995 if bm=1 then vpoke 6956,by:vpoke 6957,bx:vpoke 6958,bs:vpoke 6959,bo
1999 return



1 'collisions enemies with the player'
1 '-----------------------------------'
1 'Si hay colisión del player con el enemigo'
1 '     Si está acitvado el objeto 2 de matar enemigos y habilitado'
1 '         Hacemos un sonido (re=6:4000)'
1 '         Actualizamos la bandera de ese objeto para que no se pueda volver a utilizar'
1 '         Repintamos los objetos (3100)
1 '         Eliminamos al enemigo (6600)'
1 '     Si no está activado o habilitado el objeto 1'
1 '         Matamos al player (5700)'
1 '         Volvemos a pintar al player'
    2000 if os=2 and o2=1 then re=6:gosub 4000:o2=0:gosub 3100:gosub 6600:return else gosub 5700:put sprite 0,(x,y),1,ps
2090 return











1 'informacion del juego que aparece en l aparte superior'
    3000 line (25*8,0)-(256,20*8),14,bf
    3020 preset (26*8,1*8): print #1,"World"
    3030 preset (27*8,3*8): print #1,mw
    3040 preset (26*8,5*8): print #1,"Level"
    3050 preset (27*8,7*8): print #1,ms
    3060 preset (26*8,9*8): print #1,"Live"
    3070 preset (26*8,11*8): print #1,pe
    3075 preset (26*8,13*8): print #1,"Score"
    3080 preset (26*8,15*8): print #1,pp
    3085 preset (26*8,17*8): print #1,"Time"
    1 '3090 preset (24*8,21*8): print #1,fre(0)
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

1 'Pintar el tiempo y actualizar tile muerte'
    3200 line (26*8,18*8)-(30*8,20*8),14,bf
    1 '3200 line (25*8,18*8)-(30*8,23*8),14,bf
    3210 tu=time/100
    3220 ta=(tm+tf)-tu
    3230 preset (26*8,(19*8)-4): print #1,ta
    1 '3240 preset (24*8,20*8): print #1,ta
    3240 if ta mod 2=0 then vpoke 6144+(ty*32)+tx, 0 else vpoke 6144+(ty*32)+tx, 24
3290 return
1 'Pintar la puntuación'
    3300 line (27*8,15*8)-(31*8,16*8),14,bf
    3310 preset (26*8,15*8): print #1,pp
3390 return
1'debug
    3400 preset (0,23*8): print #1,en
3490 return


3500 rem música
    3510 s1$="V13O1L4aaaV10aV13bbbV10bV13L2O2cdeg+"
    3520 s2$="V14O4L8aV15O6cO5bO6cO4V14L8aaaV12aV14g+V15O6dcdO4V14L8g+g+g+V12g+V15O5aO6cO5babO6dcO5bO6cedcO5bebe"
    3530 s3$="V13O4L2ecdeL8 aO5cO4bO5cO3L8aaaV10aV13g+O5dcdO3L8g+g+g+v10g+"
    3540 s4$="V13L8O1aaaaV12bbbbV11ccccV10bbbbV8aaaaV5aaaaV4aaaaV1aaaa"
    3550 s5$="V13L8O2aaaaV12bbbbV11ccccV10eeeeV8aaaaV5aaaaV4aaaaV1aaaa"
    3560 s6$="V13L8O3eeeeV12eeeeV11eeeeV10eeeeV8eeeeV5eeeeV4eeeeV1eeee"
    3570 s7$="V15O2L8cccV11cV15cccV11cV13cccV9cV11cccV7cV9cccV5cV7cccV3cV5cccV2c"
    3580 S8$="V15O4L8cgegV12cgegV10cgegV7cgegV5cgegV3cgeg"
    3590 S9$="R8R8R8V10O5L8cgegV12cgegV10cgegV7cgegV5cgegV3cgeg"
3599 return
4000 rem reproductor de música
    4000 a=usr2(0)
    4010 PLAY"T150","T150","T150"
    1 ' Intro'
    4020 if re=1 then play s1$,s1$,s6$:play s1$,s2$,s6$:play s1$,s2$,s3$:play s2$,s3$,S6$:play s1$,s1$,s6$:play s4$,s5$,s6$
    1 ' Nivel terminado'
    4030 if re=2 then PLAY s7$,s8$,s9$
    1 ' Game over
    4040 if re=3 then PLAY s4$,s5$,s6$
    4050 if re=5 then play "l10 o3 v4 g c"
    1 'Paquete cogido  / muerte'
    4060 if re=6 then play"t250 o4 v12 d v9 e" 
    1 'Pitido normal'
    4070 if re=7 then play "O3 L8 V4 M8000 A A D F G2 A A A A"
    1 'Cogidos puntos'
    4080 if re=8 then sound 1,2:sound 8,16:sound 12,5:sound 13,9
    1 'Pasos'
    4090 if re=9 then PLAY"o3 l64 t255 v4 m6500 c"
    1 'Pasos'
    4100 if re=10 then sound 1,2:sound 6,25:sound 8,16:sound 12,1:sound 13,9
    4110 if re=11 then sound 1,0:sound 6,25:sound 8,16:sound 12,4:sound 13,9
4990 return






























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
    1 'pc=player colision'
    5000 x=0:y=0:xp=0:yp=0:pw=8:ph=8:pv=8:pe=3:pd=0:pp=0:pc=0
    1 'p0 y p1=sprites arriba: contedrá 0 o 1 intercambiados con swap que son los sprites de la animación de arriba'
    1 'p2 y p3=sprite derecha: determina si está el sprite 2 o 3''
    1 'p4 y p5=sprites abajo 
    1 'p6 y p7=sprites izquierda: 6 o 7'
    1 '5010 p0=0:p1=1:p2=2:p3=3:p4=4:p5=5:p6=6:p7=7
    5010 dim p(7):p(0)=0:p(1)=1:p(2)=2:p(3)=3:p(4)=4:p(5)=5:p(6)=6:p(7)=7
5020 return
1' Player muere
    1 'Le kitamos 1 vida'
    1 'Actualizamos el tiempo'
    5700 pe=pe-1:time=1:ta=1
    1 'Hacemos un sonido '
    5710 re=6:gosub 4000
    1 ' llamamos a la tutina reposicionar player y enemigos según el mapa'
    5740 gosub 8300
    1 'Pintamos el marcador'
    5750 gosub 3000
5790 return



1 '---------------------------------------------------------'
1 '------------------------ENEMIES MANAGAER------------------'
1 '---------------------------------------------------------'
1 'Init'

1 'Componente de posicion'
    1 'ex/bx:  ex=coordenada x enemigo 1, bx=coordenada x enemigo 2'
    1 'ey/by:  ey=coordenada y enemigo 1, by=coordenada y enemigo 2'
    1 'ea/ba:  ea=coordenada previa x ebemigo 1, ba= coordenada previa x enemigo 2'
    1 'ei/bi:  ei=coordenada previa y enemigo 1, bi=coordenada previa y enemigo 2'

1 'Componente de fisica'
    1 'ev/bv:  ev=velocidad enemigo 1 eje x, bv=velocidad enemigo 2 eje x 
    1 'bl=velocidad enemigo 2 eje y'
    1 'bt=si s 0 el enemigo 2 se morverá horizontalmente si es 1 se moverá verticalmente'
1 'Componente de render'
    1 'es/bs: es=enemigo 1 sprite, bs=enemigo 2 sprite
    1 'ec/bc: ec=enemigo 1 contador, bc=enemigo 2 contador, utlizado para hacer la animación'
    1 'eo/bo: eo=enemigo 1 color, bo=enemigo 2 color'
    1 'em/bm: em=determina si el sprite del enemigo 1 está eliminado (0) o no (1), bm=determina si el sprite del enemigo 2 está eliminado'
1 'Componente RPG'



1 ' Crear enemigo 1'
       6100 ew=8:eh=8:es=8:ep=10
       6105 ex=0:ey=0:ea=0:ei=0
       6110 ev=8
       6160 ec=0
       6170 eo=rnd(1)*(6-4)+4
       6186 em=1
6190 return
1 'Crear enemigo 2'
        6200 bw=8:bh=8:bs=10:bp=11
        6205 bx=0:by=0:ba=0:bi=0
        6210 bv=8:bl=8
        6260 bc=0
        6270 bo=rnd(1)*(6-4)+4
        6275 bt=0
        6281 bm=1
6290 return
1 ' Rutina eliminar enemigos'
    1 'la eliminación del enemigo es tan solo sacarlo de la pantalla'
    6600 if em=0 then ex=0:ey=212:put sprite ep,(ex,ey),,es
    6610 if bm=0 then bx=0:by=212:put sprite bp,(bx,by),,bs
6640 return





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
    7110 line (0,20*8)-(256,24*8),15,bf
    1 '7120 if os=1 and o1=1 then  preset (0,21*8):print #1,"!Seleccion eliminada":preset (0,22*8)
    7130 if os=2 and o2=1 then  preset (0,21*8):print #1,"!Seleccionada la espada: ":preset (0,22*8):print #1,"Puedes matar enemigos"
    7140 if os=3 and o3=1 then  preset (0,21*8):print #1,"!Seleccionada el rayo:":preset (0,22*8):print #1,"Puedes romper los muros"
    7160 if os=4 and o4=1 then  preset (0,21*8):print #1,"!Seleccionada la escalera: ":preset (0,22*8):print #1,"Puedes pasar por encima de los muros"             
    7170 if os=5 and o5=1 then  preset (0,21*8):print #1,"!Seleccionada la fuerza: " :preset (0,22*8):print #1,"Puedes mover los bloques rosas  pero solo 1 posicion."
    1 'Este es el marco que sale junto al objeto para decir que está seleccionado'
    7175 if gs=1 then PUT SPRITE 20,((20*8),oy),1,12
7190 return



































1 '---------------------------------------------------------'
1 '------------------------MAPA---------------------------'
1 '---------------------------------------------------------'


1 ' inicializar_mapa
    1 'mw=mapa world, mundo'
    1 'ms=mapa seleccioando, lo iremos cambiando    
    1 'md=mapa dirección en VRAM, utilizado para meter los datas de tiles
    1 'mp=mapa posición, utilizada para recorrer los caracteres'
    1 'mc= mapa cambia, lo utilizaremos para cambiar los copys y así cambiar la pantalla
    8000 mw=1:ms=0:mc=0:md=0:mp=0:tn=0
8020 return





1'Rutina posicionar player y enemigos según el mapa
    1 'Eliminamos todos los enemigos si los hay'
    8300 gosub 6600
    1 'Eliminamos el tile de muerte'
    8305 vpoke 6144+(ty*32)+tx, 0
    1 'Debug'
    1 '8310 if mw=0 and ms=0 then x=15*8:y=5*8:tx=12:ty=13:gosub 6100:ex=8*8:ey=2*8:gosub 6200:bx=12*8:by=16*8:bt=0
    8310 if mw=0 and ms=0 then x=5*8:y=10*8:tx=12:ty=13:gosub 6100:ex=8*8:ey=2*8:gosub 6200:bx=12*8:by=16*8:bt=0
    1' Debug
    1 '8320 if mw=0 and ms=1 then x=13*8:y=9*8:tx=10:ty=15:gosub 6100:ex=10*8:ey=15*8:gosub 6200:bx=7*8:by=4*8:bt=1
    8320 if mw=0 and ms=1 then x=1*8:y=18*8:tx=10:ty=15:gosub 6100:ex=10*8:ey=15*8:gosub 6200:bx=7*8:by=4*8:bt=1
    1 'Debug'
    1 '8330 if mw=0 and ms=2 then x=13*8:y=10*8:tx=10:ty=7:gosub 6100:ex=10*8:ey=1*8:gosub 6200:bx=10*8:by=10*8:bt=0
    8330 if mw=0 and ms=2 then x=1*8:y=14*8:tx=10:ty=7:gosub 6100:ex=10*8:ey=1*8:gosub 6200:bx=10*8:by=10*8:bt=0
    
    
    1 'LEVEL 3 O 1-0' 
    1 'Debug'
    1 '8340 if mw=1 and ms=0 then x=1*8:y=18*8:tx=10:ty=4:gosub 6100:ex=10*8:ey=4*8:gosub 6200:bx=17*8:by=13*8:bt=1
    8340 if mw=1 and ms=0 then x=14*8:y=7*8:tx=10:ty=4:gosub 6100:ex=10*8:ey=4*8:gosub 6200:bx=17*8:by=13*8:bt=1
    1 'LEVEL 4 O 1-1'
    1 'Debug'
    1 '8350 if mw=1 and ms=1 then x=11*8:y=7*8:tx=16:ty=11:gosub 6100:ex=15*8:ey=12*8:gosub 6200:bx=1*8:by=11*8:bt=0
    8350 if mw=1 and ms=1 then x=4*8:y=13*8:tx=16:ty=11:gosub 6100:ex=15*8:ey=12*8:gosub 6200:bx=1*8:by=11*8:bt=0
    1 'LEVEL 5 O 1-2'
    1 'Debug'
    1 '8360 if mw=1 and ms=2 then x=10*8:y=9*8:tx=3:ty=12:gosub 6100:ex=7*8:ey=15*8:gosub 6200:bx=16*8:by=12*8:bt=0
    8360 if mw=1 and ms=2 then x=1*8:y=1*8:tx=3:ty=12:gosub 6100:ex=7*8:ey=15*8:gosub 6200:bx=16*8:by=12*8:bt=0
    
           
    1 'LEVEL 6 O 2-0'
    1 'Debug'
    1 '8370 if mw=2 and ms=0 then x=14*8:y=17*8:tx=18:ty=7:gosub 6100:ex=16*8:ey=12*8:gosub 6200:bx=1*8:by=11*8:bt=0
    8370 if mw=2 and ms=0 then x=12*8:y=6*8:tx=18:ty=7:gosub 6100:ex=16*8:ey=12*8:gosub 6200:bx=1*8:by=11*8:bt=0
    1 'debug'
    1 '8380 if mw=2 and ms=1 then x=16*8:y=12*8:tx=13:ty=11:gosub 6100:ex=7*8:ey=15*8:gosub 6200:bx=16*8:by=7*8:bt=1
    8380 if mw=2 and ms=1 then x=1*8:y=1*8:tx=13:ty=11:gosub 6100:ex=7*8:ey=15*8:gosub 6200:bx=16*8:by=7*8:bt=1
    1 'debug'    
    1 '8390 if mw=2 and ms=2 then x=10*8:y=10*8:tx=5:ty=11:gosub 6100:ex=1*8:ey=10*8:gosub 6200:bx=5*8:by=8*8:bt=0
    8390 if mw=2 and ms=2 then x=5*8:y=1*8:tx=5:ty=11:gosub 6100:ex=1*8:ey=10*8:gosub 6200:bx=5*8:by=8*8:bt=0
8399 return





1 'Rutina cargar sprites con datas basic'
    1 ' vamos a meter 5 definiciones de sprites nuevos que serán 4 para el personaje y uno para la bola'
    1 'El player será el plano 0, los sprites serán del 0 al 7
    1 'como tenemos 2 tipos de enemigos serán el plano 1 y el 2, los sprites serán para el tipo 1 el 8 y el 9, para el tipo 2 el 10 y el 11'
    1 'Los '
    9000 FOR I=0 TO 17:SP$=""
        9020 FOR J=1 TO 8:READ A$
            9030 SP$=SP$+CHR$(VAL("&H"+A$))
        9040 NEXT J
        9050 SPRITE$(I)=SP$
    9060 NEXT I
    9110 DATA 03,C3,D8,3C,BD,DB,E7,7E
    9120 DATA C0,C3,1B,3C,BD,DB,E7,7E
    9130 DATA 76,E6,D8,BC,BC,D8,E3,73
    9140 DATA 73,E3,D8,BC,BC,D8,E6,76
    9150 DATA 7E,E7,DB,BD,3C,1B,C3,C0
    9160 DATA 7E,E7,DB,BD,3C,D8,C3,03
    9170 DATA CE,C7,1B,3D,3D,1B,67,6E
    9180 DATA 6E,67,1B,3D,3D,1B,C7,CE
    9190 DATA 18,3C,66,C3,C3,66,3C,18
    9200 DATA 3C,7E,FF,E7,E7,FF,7E,3C
    9210 DATA 81,C3,24,3C,3C,24,42,C3
    9220 DATA 00,42,66,3C,3C,24,66,00
    9230 DATA 00,04,06,FF,FF,06,04,00
    9240 DATA 81,42,24,18,18,24,42,81
    9250 DATA 01,02,04,88,50,20,D0,C8
    9260 DATA 07,0E,38,70,0E,1C,70,E0
    9270 DATA 24,24,3C,24,24,3C,24,24
    9280 DATA 00,23,33,FB,FB,33,23,00
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
        10000 FOR I=0 TO (26*8)-1
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
    10124 DATA FF,C3,BD,5A,66,3C,81,D5
    10125 DATA 7E,BD,DB,E7,E7,DB,BD,7E





    1 'Definición de colores, los colores se definen a partir de la dirección 8192/&h2000'
    1 'Como la memoria se divide en 3 bancos, la parte de arriba en medio y la de abajo hay que ponerlos en 3 partes'
    10500 FOR I=0 TO (26*8)-1
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
    10624 DATA A1,A6,A6,A6,A6,A6,A6,A6
    10625 DATA A6,A6,A6,A6,A6,A6,A6,A6

10690 return






1 'Render map, pintar mapa
    1 'la pantalla en screen 2:
    1 'El mapa se encuentra en la dirección 6144 / &h1800 - 6912 /1b00'
    1 'Eliminamos los enemigos si quedan'
    11000 gosub 6600
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



1 '--------------------------------------------------------------------------------------'
1 '-------------------------------------Mundo 1------------------------------------------'
1 '--------------------------------------------------------------------------------------'

1 'level 0'
12000 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
12010 data 0e1404000d07070708000000090307070707080e
12020 data 0e0004000415000000000016000400000000000e
12030 data 0e00040004000d0707030800000a0707070c000e
12040 data 0e0004000400040000040000000000120004000e
12050 data 0e000a070b000a0707030707070c00130004000e
12060 data 0e0000000000000000040000000400000004000e
12070 data 0e0707070707070c00040000000400000004000e
12080 data 0e00000000000004000a070707030707070b000e
12090 data 0e0015000016000400000000000000000000000e
12100 data 0e00000000000004000d0707070707070708000e
12110 data 0e000d070800000400040000000000000000000e
12120 data 0e00040000000004000a070707070c000907070e
12130 data 0e0004000d07070b00000000180004000000000e
12140 data 0e000400041400000009070c000004000000000e
12150 data 0e0004000a07070c0000000400000a07070c000e
12160 data 0e0004000000000400000004000000000004000e
12170 data 0e000a07070707030707070b001600000004000e
12180 data 0e0000000000000000000000000000000004140e
12190 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
1 'level 1'
12200 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
12210 data 0e0907070707070707070708000000000000000e
12220 data 0e140000000000000000150000000d070707160e
12230 data 0e090707070716070716070c000004000000000e
12240 data 0e0000000000000000000004000004000005000e
12250 data 0e00090307070707070c0006000004000004000e
12260 data 0e0000040000000000041500000004000004000e
12270 data 0e05000400001600000400000d070b000004000e
12280 data 0e0400040005000500040000041200000004000e
12290 data 0e0400040004000400040000041300000004000e
12300 data 0e04000400040004000400000a070716030b000e
12310 data 0e0400040004000400040000000000000400000e
12320 data 0e040004000400040004000d070708000400090e
12330 data 0e0400040004000400040004000000000400000e
12340 data 0e04000400060004000a0703070707070308000e
12350 data 0e0600041500000400000000000000000000000e
12360 data 0e0000060005000a07070707070707070c16000e
12370 data 0e0000000004000000000000000000000400000e
12380 data 0e000000000a070707070707070708140415140e
12390 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
1 'level 2'
12400 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
12410 data 0e0000000000000000000000000000000000000e
12420 data 0e000d07070707070708160009070707070c000e
12430 data 0e0004000000000000000000000000000004000e
12440 data 0e0004150000000000000000000000001404000e
12450 data 0e000307070707070707070707070707070b000e
12460 data 0e0004000000000000000000000000000000000e
12470 data 0e000415000000140516000e0e0e0e0e0e0e0e0e
12480 data 0e000a07070707070300000e0e0e0e0e0e0e0e0e
12490 data 0e000000000000000400000e0e1200000000000e
12500 data 0e000000000000150400000e0e1300000000000e
12510 data 0e000d07070707070300000e0e0e0e0e0e0e000e
12520 data 0e0004000000000006000016000000000005000e
12530 data 0e000400000000000000000e000000000004000e
12540 data 0e0003070707070707070707070707080004000e
12550 data 0e070b000000000000000000000000000004000e
12560 data 0e0000000000000005000005140000000004000e
12570 data 0e000907070707070b00000a07070707070b000e
12580 data 0e1500000000001600000000000000000000000e
12590 data 000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00
















1 '--------------------------------------------------------------------------------------'
1 '-------------------------------------Mundo 1------------------------------------------'
1 '--------------------------------------------------------------------------------------'
1 '1-0 o level 3'
12600 data 0d0707070707070707070707070707070707070c
12610 data 04020202020202140f1502020202020202021504
12620 data 04020f0f0f0f020f0f0f020f0f020f020f0f0f04
12630 data 04020f020f0f0f0f0f0f0f0f0f0f0f020f020f04
12640 data 0402020202020202020202020202020202020204
12650 data 04020f0f0f0f0f0f0f0f0f0f0f0f0f0f0f020f04
12660 data 04020f020f020f020f020f150f020f020f020204
12670 data 0402020202020202020202020f02020202020204
12680 data 040f0f0f0f020f0f0f0f0f020f0f0f0f0f0f0f04
12690 data 04020f020202020202020f020f020f020f021504
12700 data 040202020f0f160f0f020f020f020f0202020204
12710 data 04020f0f0f020f150f020f02020202020f0f0f04
12720 data 04020f020f020f020f020f0f0f0f0f020f020f04
12730 data 0402020202020f020f02020202140f0202020204
12740 data 040f0f0f0f0f0f020f0f0f0f0f0f0f0f0f0f0204
12750 data 04020f020f020f020f020f020f020f020f021604
12760 data 0402020216020202020202020202020202020204
12770 data 04120202020f0f0f0f020f0f0f0f0f0f0f0f0f04
12780 data 0413020200150202020202020202020202021404
12790 data 0a0707070707070707070707070707070707070b
1 '1-1 o level 4'
12800 data 0d0707070707070707070707070707070707070c
12810 data 040f02140f0f0202020f0f1402020202020f0f04
12820 data 040202020f0f1502020f0f02020f02020f0f0204
12830 data 0402020f0f0f020f020202020f02020f16020204
12840 data 040202150f0f02020f02020f02020f0202020204
12850 data 04020f0f0f0f0f020f0f0f0f0f0f0f0f0f0f1504
12860 data 04020f02020f0f0202020212020f0f02020f0204
12870 data 04020202020f0216020202130f0f0f0202020204
12880 data 040202020f0f02020f02020f0f140f0f02020204
12890 data 040f0f02020f0202020f0f0f02020f02020f0f04
12900 data 04020f0202160202020f0f0202020f02020f0204
12910 data 04020202020f02020f02020f02020f0f02020204
12920 data 04020f0f020f150f020202020f020f02020f0204
12930 data 04020f15020f0f020202020202020202020f0204
12940 data 04020f0f0f0f0f020f0f0f0f0f0f0f0f0f0f0204
12950 data 040202020f0f02020f02020f0202150f02020204
12960 data 040202020202020f020202020f0202020f020204
12970 data 04020f0f02160f02020f0f02020f0f02020f0204
12980 data 040f0f0202020202020f0f0202150f0202021504
12990 data 0a0707070707070707070707070707070707070b

1 '1-2 o level 5'
13000 data 0d0707070707070707070707070707070707070c
13010 data 040202020f0f0f0f0f0f0202020f0f0202021404
13020 data 04150f020f021602020f020f020f0202160f1504
13030 data 040f0f020f020f02020f020f020f0202020f0f04
13040 data 040202020f0215020202150f020f020f020f0204
13050 data 040f0f020f020f0f0f0f0f0f020f020f020f0f04
13060 data 04020f020f020f1502020202020f020f020f0204
13070 data 040f0f0216020f0f0f0f0f0f0202020f020f0f04
13080 data 04020f020f0215020f02120f0f0f160f020f0204
13090 data 040f0f020f020f020f02130f150f020f020f0f04
13100 data 040202020f020f020f02020f020f020f020f0204
13110 data 040f0f020f020f020f02020f020f020f020f0204
13120 data 04020f020f020f02020202020202020f020f0204
13130 data 04150f020f0f0f0f0f0f0f0f0f0f0f0f020f1504
13140 data 040f0f02020f0f0f0f0f0f0f0f0f0f02020f0204
13150 data 0402020202020202020202020202020202020204
13160 data 0402160f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f04
13170 data 0402020202020202020202020202020202020f04
13180 data 040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f021404
13190 data 0a0707070707070707070707070707070707070b





















1 '--------------------------------------------------------------------------------------'
1 '-------------------------------------Mundo 2------------------------------------------'
1 '--------------------------------------------------------------------------------------'
1 'level 6'
13200 data 0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f
13210 data 0f1010101010101010101010101010101010100f
13220 data 0f0000001500000000000000001600150000000f
13230 data 0f0010100510101010100010101000051010000f
13240 data 0f0000000415100000000000001000040000000f
13250 data 0f1010000400101000101010101000040010100f
13260 data 0f0000000400100000000000001000040000000f
13270 data 0f0000100400101610101010101000041010000f
13280 data 0f1000000400000000000000000000040000000f
13290 data 0f0000000400101010101010101000041510100f
13300 data 0f0000000400000500000000150500040000000f
13310 data 0f0010100416150400000010100400041010000f
13320 data 0f0000000400000400000000000400041400000f
13330 data 0f1010140600000410101010000416061010100f
13340 data 0f0000000000000400000000000400000000000f
13350 data 0f0016101010100400000000160410101010000f
13360 data 0f0000000000000600101010100412000000000f
13370 data 0f0000000000000000000000150613000000000f
13380 data 0f1010101010101010101010101010101010100f
13390 data 0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f
1 'level 7'
13400 data 1010101010101010101010101010101010101010
13410 data 1000000000000000001000001000000000000010
13420 data 1010151010101015101010101010151010101510
13430 data 1000000000001600000000000000001000000010
13440 data 1010101010151010101010151015101010151010
13450 data 1000000000000000000000001000001000000010
13460 data 1010171010151010171010101015101015101010
13470 data 1000001000000000001000000000001000000010
13480 data 1015101010101010151010151010101015101010
13490 data 1014000000000000001000001000000000160010
13500 data 1010151017101010101010151015101010101010
13510 data 1000000000000000000000001000001012000010
13520 data 1010101010101010171010101015101013000010
13530 data 1000000000000000001010101000141000000010
13540 data 1010151010151010151015101015101010101510
13550 data 1000001000001000000000000000001000000010
13560 data 1010151010101010151010101010101015101010
13570 data 1000000000001000160000000000001000000010
13580 data 1000001000001000001000001000000000000010
13590 data 1010101010101010101010101010101010101010
1 'level 8'
13600 data 1010101010101010101010101010101010101010
13610 data 1000000000001000000000001410000016000010
13620 data 1000101010101015101010101010101510100010
13630 data 1000100000001600160000100000000000100010
13640 data 1000100000001000000000101010101000100010
13650 data 1000100010101010101015100000001000100010
13660 data 1000100010000000000000160000001000160010
13670 data 1000100010001010101010101000001010101510
13680 data 1000100010001000000000001010101000000010
13690 data 1000171010001000001012001000001500101010
13700 data 1000150010001016001013001000161000101410
13710 data 1000100010001500001010001000001000100010
13720 data 1000100010101010150000001000001000100010
13730 data 1000100010000010101010101000001000100010
13740 data 1000100010000000000000000000001000100010
13750 data 1000100010101010101010101010101000150010
13760 data 1000100010000000000010000000000000100010
13770 data 1000101010101010101710101010101010100010
13780 data 1000000000000000000000000000000000000010
13790 data 1010101010101010101010101010101010101010











