#!/usr/bin/bash

#pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c mines.c -S
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ./mines.c
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-ld -T ~/data/develop/UKNC/GCC-PDP11/bin/no_header.ld -o ./mines.bin ./../crt/crt0.o ./../libgraph/libgraph.o ./../libmouse/libmouse.o ./../libkeyb/libkeyb.o ./../common/rnd-float.o ./mines.o
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-objcopy -O binary ./mines.bin ./mines.sav
python3 ~/data/develop/UKNC/GCC-PDP11/bin/bin2sav.py ./mines.sav

cp -f ./mines.sav ../../../../dsk/mines.sav

cd ../../../../dsk

./builddsk_mines.sh

