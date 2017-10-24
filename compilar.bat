del game.o
del game.gb
rgbasm -o game.o main.asm
rgblink -t -d -o game.gb game.o
pause