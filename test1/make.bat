@echo off
rem Intrucciones
rem por defecto:
rem utiliza el modo DirAsDisk, no dsk ni cas, etc
rem emulador openmsx
rem Disk-Manager-v0.17 para la creación de .dsk 
rem 
rem Abre una terminal y escribe:
rem     make create
rem     make createall: para trabajar en modoDirAsDisk t crear todos los archivos
rem     make 
rem     make 
rem     make 
rem     make 
rem dependences
    rem java JRE >=1.8
    rem python>3.5 for tokenizer
    rem disk-manager
    rem deletecomments
    rem disk2rom
    rem mkcas
    rem mcp
    rem Emulators: bluemsx, openmsx, fuse

rem Varibles de configuración
OPENMSX=openmsx.exe
OPENMSX_PATH=tools\emulators\openmsx-16.0\
set TARGET_CAS=juego.cas
set TARGET_WAV=juego.wav
set TARGET_DSK=juego.dsk
set TARGET_ROM=juego.rom

rem Con esta línea le estamos diciendo que tiene que empezar por la función main
rem With this line we are telling you that you have to start with the main function
@echo off&cls&call:main %1&goto:EOF

:main
    rem Ckequeando parámetros
    if [%1]==[] (call :create)
    if [%1]==[all] (call :create_all)
    if [%1]==[dsk] (call :create_dsk)
    if [%1]==[rom] (call :create_rom)
    if [%1]==[cas] (call :create_cas)
    if [%1]==[clean] (call :clean)
    rem Si el argumento no está vacío, ni es dsk, ni es cas, etc
    rem If the argument is not empty, neither is it dsk, nor is it cas, etc.
    if [%1] NEQ [] (
        if [%1] NEQ [all] (
            if [%1] NEQ [rom] (
                if [%1] NEQ [dsk] (
                    if [%1] NEQ [cas] ( 
                        if [%1] NEQ [tsx] ( 
                            if [%1] NEQ [cleanall] (
                                if [%1] NEQ [clean] (call :help) 
                            }
                        }
                    )
                )
            )
        }
    )    
goto:eof

:create
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :abrir_emulador_con_dir_as_disk
goto:eof

:create_all
    call :crear_dsk
    call :crear_rom
    call :crear_cas
    call :crear_wav
    call :abrir_emulador_con_dsk
goto:eof

:create_dsk
    echo Escogiste crear dsk
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_dsk
    call :abrir_emulador_con_dsk
goto:eof


:create_rom
    echo Escogiste crear rom
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_dsk
    call :crear_rom
    call :abrir_emulador_con_rom
goto:eof



:create_cas
    echo Escogiste crear cas
    call :preparar_archivos_fuente
    call :convertir_imagenes
    call :crear_cas
    call :crear_wav
    call :abrir_emulador_con_wav
goto:eof

:clean
    echo escogiste borrar objetos y dsk
    del /F /Q obj\*.*
    del /F /Q dsk\*.*
goto:eof
:clean_disk
    echo escogiste borrar ddirAsDisk
    del /F /Q dsk\*.*
goto:eof

:help
     echo No reconozco la sintaxis, pon:
     echo .
     echo make [] [dsk] [rom] [cas] [clean] [cleanall]
goto:eof
















rem ----------------------------------------------------------------
rem                     Preparar archivos
rem ----------------------------------------------------------------
rem Esta función prepará los archivos fuente pata incluirlos en un dsk, cas 

:preparar_archivos_fuente
    call clean
    rem creamos la carpeta obj (objects) si no existe, si existe borramos su contenido
    If not exist .\obj (md .\obj) else (call :clean)

    rem necesitamos el nextorbasic
    rem copy bin\nbasic.bin obj

    rem necesitamos todos los mapas
    rem start /wait tools\sjasm42c\sjasm.exe asm\word0.asm
    rem start /wait tools\sjasm42c\sjasm.exe asm\word1.asm
    rem move /Y word0.bin ./bin
    rem move /Y word1.bin ./bin
    rem java -jar tools/csv2bin/CSVFenris.jar assets/tilemap0.csv bin/tilemap0.bin
    rem java -jar tools/csv2bin/CSVFenris.jar assets/tilemap1.csv bin/tilemap1.bin
    rem java -jar tools/csv2bin/CSVFenris.jar assets/tilemap2.csv bin/tilemap2.bin
    cd
    start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level0.tmx assets\worlds\level0.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level1.tmx assets\worlds\level1.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level2.tmx assets\worlds\level2.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level3.tmx assets\worlds\level3.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level4.tmx assets\worlds\level4.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level5.tmx assets\worlds\level5.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level6.tmx assets\worlds\level6.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level7.tmx assets\worlds\level7.txt
    rem start /wait java -jar tools\csv2hex\csv2hex.jar assets\worlds\level8.tmx assets\worlds\level8.txt



    rem necesitamos el .bin de la pantalla de carga y del reproductor de música
    rem sjasm (http://www.xl2s.tk/) es un compilador de ensamblador z80 que puedo convertir tu código ensamblador en los archivos binarios.rom y .bin
    rem start /wait tools\sjasm42c\sjasm.exe src\asm\scloader.asm
    rem start /wait tools\sjasm42c\sjasm.exe src\asm\rutinas.asm
    rem start /wait tools\sjasm\sjasm.exe src\music.asm
    rem move /Y scloader.bin obj
    rem move /Y scloader.lst obj
    rem move /Y rutinas.bin obj
    rem move /Y rutinas.lst obj


    rem Copiamos todos los archivos.bas de la carpeta de src(fuentes)/game a la carpeta obj
    for /R src/game %%a in (*.bas) do (
        copy "%%a" obj)
    rem Copiamos el autoexec del juego para que se inicie solo y el cargador
    copy src\autoexec.bas obj
    copy src\loader.bas obj


    rem Unimos los temporales a unico archivo llamado game.bad y borramos los temporales
    rem Creamos el archivo temporal que después quitaremos los comentarios
    rem type null > obj\temp.bas
    copy "obj\main.bas" "obj\temp.bas"
    del /F /Q obj\main.bas 
    
    rem Le quitamos los comentarios a temp.bas
    if not exist tools\deletecomments1.4 GOTO :not_exist_deletecomments
    java -jar tools\deletecomments1.4\deletecomments1.4.jar obj\temp.bas obj\game.bas

    rem lo tokenizamos
    rem if not exist tools\tokenizer\msxbatoken.py GOTO :not_exist_tokenizer
    rem start /wait tools\tokenizer\msxbatoken.py obj\game.bad
    rem escribe tyoe /? y find /? paa más ayuda
    rem type obj\temp.bas | find /V  "1 '"  > obj\game.bas
    echo Comentarios eliminados y creado game.bas tokenizado

    rem creamos la carpeta obj (objects) si no existe, si existe borramos su contenido
    If exist .\dsk (call :clean_disk) else (md .\dsk)
    rem copiamos todos los archivos de obj a dsk
    for /R obj %%a in (*.*) do (
    copy "%%a" dsk)
    for /R bin %%a in (*.bin) do (
    copy "%%a" dsk)
goto:eof





:convertir_imagenes
    rem Todos los formatos ir a: http://msx.jannone.org/conv/
    rem MSX1
    rem tools\Sc2GraphXConv\MSX1-Graphic-Converter\binaries\windows\GraphxConv.exe assets\loader.bmp bin\loader.sc2 -i=0
    rem del /F /Q gmon.out
goto:eof




























rem ----------------------------------------------------------------
rem                    Crear DSK
rem ----------------------------------------------------------------
rem Creará un nuevo archivo .dsk con los archivos .bin y .bas especificados
:crear_dsk
    rem comprobamos que existe el disk manager
    if not exist tools\Disk-Manager-v0.17 GOTO :not_exist_disk_manager
    rem Crear nuevo dsk
    rem como diskmanager no puede crear dsk vacíos desde el cmd copiamos y pegamos uno vacío
    if exist %TARGET_DSK% del /f /Q %TARGET_DSK%
    copy tools\Disk-Manager-v0.17\main.dsk .\%TARGET_DSK%
    rem añadimos todos los .bas de la carpeta obj al disco
    rem por favor mirar for /?
    for /R obj/ %%a in (*.bas) do (
        start /wait tools/Disk-Manager-v0.17/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   

    rem añadimos todos los arhivos binarios de la carpeta bin al disco
    rem recuerda que un sc2, sc5, sc8 es también un archivo binario, renombralo
    rem por favor mirar for /?
    for /R bin/ %%a in (*.*) do (
        start /wait tools/Disk-Manager-v0.17/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   
goto:eof


rem ----------------------------------------------------------------
rem                    Crear ROM
rem ----------------------------------------------------------------
:crear_rom
    rem esto generará una rom de 32kb
    if not exist tools\dsk2rom-0.80 GOTO :not_exist_disk2rom
    start /wait tools\dsk2rom-0.80\dsk2rom.exe -c 2 -f %TARGET_DSK% %TARGET_ROM% 
goto:eof

rem ----------------------------------------------------------------
rem                    Crear CAS
rem ----------------------------------------------------------------
:crear_cas
    if not exist tools\mkcas GOTO :not_exist_mkcas
    rem set TYPE=$1
    rem set TAPENAME=$2
    rem set PATHFILE=$3
    rem start /wait tools\mkcas\mkcas.py %TAPENAME% %TYPE% %PATHFILE%
    rem por favor, visita https://github.com/reidrac/mkcas
    if exist %TARGET_CAS% del /f /Q %TARGET_CAS%
    rem start /wait tools\mkcas\mkcas.py %TARGET_CAS% ascii obj\game.bas
    start /wait tools\mkcas\mkcas.py %TARGET_CAS% --add --addr 0x8000 --exec 0x8000  ascii obj\game.bas
    start /wait tools\mkcas\mkcas.py %TARGET_CAS% --add --addr 0x9000 --exec 0x9000  binary bin\sc5-01.bin
goto:eof
rem ----------------------------------------------------------------
rem                    Crear WAV
rem ----------------------------------------------------------------
:crear_wav:
    if not exist tools\mcp GOTO :not_exist_mcp
    start /wait tools\mcp\mcp.exe -e %TARGET_CAS% %TARGET_WAV%
goto:eof
rem ----------------------------------------------------------------
rem                    Crear TSX
rem ----------------------------------------------------------------
































rem ----------------------------------------------------------------
rem                     Abrir Emulador
rem ----------------------------------------------------------------
rem sobre openmsx:https://openmsx.org/manual/commands.html

if not exist tools/emulators GOTO :not_exist_emulators
rem BlueMSX: http://www.msxblue.com/manual/commandlineargs_c.htm
rem openMSX poner "tools\emulators\openmsx-16.0\openmsx.exe -h" en el cmd
rem Machines:
    rem MSX 1
    rem start /wait tools/emulators/openmsx/openmsx.exe  -ext Sony_HBD-50 -ext ram32k -diska %TARGET_DSK% 
    rem start /wait tools/emulators/openmsx/openmsx.exe -script tools/emulators/openmsx/emul_start_config.txt
    rem MSX2
    rem start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska %TARGET_DSK%
    rem MSX2+
    rem start /wait tools/emulators/openmsx/openmsx.exe -machine Sony_HB-F1XV -diska %TARGET_DSK%
rem FMSX: FMSX https://fms.komkon.org/fMSX/fMSX.html
rem para utilizar dir as disk tendrás que crear un directorio dsk/
:abrir_emulador_con_dir_as_disk
    echo "Escogiste crear dirASdsk"
    rem copy main.dsk tools\emulators\BlueMSX
    rem start /wait tools/emulators/BlueMSX/blueMSX.exe -diska dsk/
    rem start /wait emulators/fMSX/fMSX.exe -diska dsk/
    rem (
    rem     echo "<command>set power on</command>";
    rem     echo "<command>set machine Philips_NMS_8255</command>";
    rem     echo "<command>set diska dsk</command>";
    rem     echo "<command>type_via_keybuf \\r\\r</command>";
    rem     echo "<command>type_via_keybuf run\loader.bas</commando>";
    rem      echo "<command>set renderer SDL</command>";
    rem ) | .\tools\emulators\openmsx-16.0\openmsx.exe -control stdio

    start /wait tools/emulators/openmsx-16.0/openmsx.exe -machine Philips_NMS_8255 -diska dsk/
goto:eof

:abrir_emulador_con_dsk
    rem copy %TARGET_DSK% tools\emulators\BlueMSX
    rem start /wait tools/emulators/BlueMSX/blueMSX.exe -diskA %TARGET_DSK%
    rem start /wait tools/emulators/fMSX/fMSX.exe -diska %TARGET_DSK%
    rem start /wait tools/emulators/openmsx-16.0/openmsx.exe -machine Philips_NMS_8255 -diska %TARGET_DSK%
    start tools\emulators\openmsx-16.0\openmsx.exe -script tools\emulators\openmsx-16.0\emul_start_config.txt
goto:eof
:abrir_emulador_con_cas
    rem copy %TARGET_CAS% tools\emulators\BlueMSX
    rem start /wait tools/emulators/BlueMSX/blueMSX.exe -cas %TARGET_CAS%
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_CAS%
    start /wait tools/emulators/openmsx-16.0/openmsx.exe -machine Philips_NMS_8255 -cassetteplayer %TARGET_CAS%
goto:eof
:abrir_emulador_con_wav
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_WAV%
    start /wait tools/emulators/openmsx-16.0/openmsx.exe -machine Philips_NMS_8255 -cassetteplayer %TARGET_WAV%
goto:eof
:abrir_emulador_con_rom   
    copy %TARGET_ROM% tools\emulators\BlueMSX
    start /wait tools/emulators/BlueMSX/blueMSX.exe -rom1 %TARGET_ROM%
    rem start /wait tools/emulators/fMSX/fMSX.exe -cas %TARGET_ROM%
    rem start /wait tools/emulators/openmsx-16.0/openmsx.exe -machine Philips_NMS_8255 -carta %TARGET_ROM%
goto:eof






:not_exist_deletecomments
    echo "Not exit deletecomments"
goto :end
:not_exist_disk2rom
    echo "Not exit disk2rom"
goto :end
:not_exist_mkcas
    echo "Not exit mkcas"
goto :end
:not_exist_mcp
    echo "Not exit mcp"
goto :end
:not_exist_disk_manager
    echo "Not exit diskmanager"
goto :end
:not_exist_tokenizer
    echo "Not exit tokenizer"
goto :end
:not_exist_emulators
    echo "Not exit emulators"
goto :end
:not_exist_bluemsx
goto :end
:not_exist_openmsx
goto :end

:error
    echo "ha habido un error"
goto:eof

:end
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete