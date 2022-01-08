
1 ' Cragamos el main'
180 load "game.bas",r





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








