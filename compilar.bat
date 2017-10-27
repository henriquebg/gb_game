del bin\game.o
del bin\game.gb
cd src
rgbasm -o ..\bin\game.o main.asm
cd ..
rgblink -m bin\game.map -n bin\game.sym -o bin\game.gb bin\game.o
rgbfix -p0 -v bin\game.gb
pause