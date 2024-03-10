..\snasm -map lowresdemo.asm lowresdemo.sna
if ERRORLEVEL 1 goto doexit

rem simple 48k model
E:\Dropbox\Backups\Source\Emulation\CSpect2\Game1\bin\Release\CSpect.exe -60 -vsync -tv -sound -s14 -map=lowresdemo.sna.map -zxnext -mmc=.\ lowresdemo.sna
rem ..\CSpect.exe -s14 -map=lowresdemo.sna.map -zxnext -mmc=.\ lowresdemo.sna

:doexit