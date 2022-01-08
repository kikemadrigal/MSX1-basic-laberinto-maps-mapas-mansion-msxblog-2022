



1 ' si no le ponemos width 32 nos pone 28*8=224px caracteres de ancho por 21*8=168 de alto'
80 screen 1,0,0:key off:width 32
90 print "Cargando sprites"
1 ' inicializamos los sprites'
100 gosub 20870
1 ' Inicializacion de las dimensiones de los arrays de nuestras entidades'
110 print "Reservando espacio de arrays"
120 gosub 10000
1 ' Inicializamos los gráficos'
130 print "Cargando graficos"
140 gosub 30000
1 ' Cargamos el xbasic'
150 print "Cargando xbasic"
160 bload"xbasic.bin",r
170 print "Escribiendo main.bas en RAM"
1 ' Cragamos el main'
180 load "main.bas",r

    1 'Definiendo el espacio para los arrays con los valores de los enemigos'
    1 'creamos el espacio en la memoria para 3 enemigos'
    1 'Con em le decimos el espacio con en el enemigo actual que será actualizado o dibujado'
    1 'Para saber lo que es cada variable ir a la inicialización del enemigo'   
    1 'em=enemigos maximos'
    10000 em=5
    1 ' Component position'
    10010 DIM ex(em),ey(em),ep(em),ei(em)
    1 ' Compenent phisics'
    10020 DIM ev(em),el(em)
    1 ' Component render'
    10030 DIM ew(em),eh(em),es(em)
    1 ' Component RPG'
    10040 DIM ee(em)

    1 'Definiendo el espacio de arrays con los valores de los mapas'
    1 'mm=mapas maximos'
    10050 'mm=6:dim m(23,31,mm-1)
10060 return


1 'Rutina cargar sprites con datas basic'
    20870 RESTORE
    1 ' vamos a meter 5 definiciones de sprites nuevos que serán 4 para el personaje y uno para la bola'
    20880 FOR I=0 TO 7:SP$=""
        20890 FOR J=1 TO 8:READ A$
            20900 SP$=SP$+CHR$(VAL("&H"+A$))
        20901 NEXT J
        20910 SPRITE$(I)=SP$
    20911 NEXT I
20920 return 
20930 DATA 18,18,66,5A,5A,24,24,66
20940 DATA 18,18,24,3C,3C,18,18,3C
20950 DATA 18,18,10,18,1C,18,18,1C
20960 DATA 18,18,08,18,38,18,18,38
1 'definiendo los malotes'
20970 DATA 18,3C,66,42,C3,C3,C3,FF
20980 DATA 00,00,00,3C,42,FF,FF,FF
20990 DATA 81,DB,3C,18,18,66,42,C3
20995 DATA 00,18,7E,5A,18,24,24,66

1 ' El color al sprite se lo mondremos más adelante con put sprite (aunque tambien sepuede escribir con vpoke)'





1' Rutina cargar gráficos
    1' Definicición de tiles
    1 ' En el caracter 224*8=1792
    30000 FOR I=1792 TO 1792+7
       30010 READ A$
       30020 VPOKE I,VAL("&H"+A$)
    30030 NEXT I

    1 'En el 233*8=1864 (8 tiles despues, ya que el color es cada 8 tiles)'
    30040 'FOR I=1864 TO 1864+7
       30050 'READ A$
       30060 'VPOKE I,VAL("&H"+A$)
    30070 'NEXT I


    1 'Definición de colores, en la dirección 8192 empieza la tabla de colores (base(6))
    1 'Le damos el color rojo y transparente 6 0 a nuesto tile
    30210 vpoke 8220,&h60
    1 'Como vamos a utilizar un tile ya prediseñado de los que vienen incuidos (el 204, rayitas diagonales )'
    1 'Vamos a ponerle el color amarillo y transparente'
    30220 vpoke 8214,&hb0
    1 'Vamos a poner un color rojo y blanco al tiled de cambio de nivel (el 215, una especie de meta) '
    30230 vpoke 8215,&h6f
30270 return


1 'Definicion del caracter 224, ladrillo
30230 DATA E3,E3,E3,3E,3E,3E,F9,F9
1 'Definicion del caracter 225, picho'
30240 'DATA 18,3C,66,42,C3,C3,C3,FF
