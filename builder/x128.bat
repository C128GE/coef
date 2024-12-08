cd build
c1541 -format "disk,00" d64 disk.d64
copy ..\out\base.prg .\
c1541 -attach disk.d64 -write base.prg base
c1541 -attach disk.d64 -list
x128 -autostartprgmode 1 -autostart disk.d64 -moncommands "..\out\base.vs"
