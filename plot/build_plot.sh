#!/usr/bin/bash

#pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c plot.c -S
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ./plot.c
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-ld -T ~/data/develop/UKNC/GCC-PDP11/bin/no_header.ld -o ./plot.bin ./../crt/crt0.o ./../libgraph/libgraph.o ./../libkeyb/libkeyb.o ./../pdp11-soft-float/pdp11-fis.o ./plot.o
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-objcopy -O binary ./plot.bin ./plot.sav
python3 ~/data/develop/UKNC/GCC-PDP11/bin/bin2sav.py ./plot.sav

cp -f ./plot.sav ../../../../dsk/plot.sav

cd ../../../../dsk

./builddsk_plot.sh

