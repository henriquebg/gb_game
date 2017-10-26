del bin\game.o
del bin\game.gb
cd src
rgbasm -o ..\bin\game.o main.asm
cd ..
rgblink -t -d -o bin\game.gb bin\game.o
pause