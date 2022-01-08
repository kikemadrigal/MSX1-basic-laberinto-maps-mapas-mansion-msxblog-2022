@echo off
set TARGET_DSK=disco.dsk

rem /*********Creando .bin de la pabtalla
start /wait tools\sjasm\sjasm.exe src\word0.asm
start /wait tools\sjasm\sjasm.exe src\word1.asm
move /Y word0.bin ./bin
move /Y word1.bin ./bin
rem /*******borrando comentarios*******/



rem preparamos un dsk vacío
if exist %TARGET_DSK% del /f /Q %TARGET_DSK%
copy tools\Disk-Manager\main.dsk .\%TARGET_DSK%

rem añadimos todos los .bas menos el main en la carpeta objects el /A es para decirle que es ASCII
copy /A src obj

rem le quitamos comentarios al bas, para ejcutar este comando necesitas tener java jre instalado
java -jar tools/deletecomments/deletecomments.jar src/main.bas obj/main.bas  

rem Añadimos todos los archivos .bas de la carpeta objects al dsk
rem por favor mirar for /?
for /R obj/ %%a in (*.bas) do (
    start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   

rem añadimos todos los arhivos binarios de la carpeta bin al disco
rem recuerda que un sc2, sc5, sc8 es también un archivo binario, renombralo
rem por favor mirar for /?
for /R bin/ %%a in (*.bin) do (
    start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C %TARGET_DSK% "%%a")   


rem copy %TARGET_DSK% tools\emulators\BlueMSX
rem start /wait tools/emulators/BlueMSX/blueMSX.exe -diska %TARGET_DSK%
rem start /wait emulators/fMSX/fMSX.exe -diska %TARGET_DSK%
start /wait tools/emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska %TARGET_DSK%