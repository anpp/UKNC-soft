#!/usr/bin/bash

#pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ainv.c -S
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ./ainv.c
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-ld -T ~/data/develop/UKNC/GCC-PDP11/bin/no_header.ld -o ./ainv.bin ./../crt/crt0.o ./../libgraph/libgraph.o ./../libkeyb/libkeyb.o ./../pdp11-soft-float/pdp11-fis.o ./ainv.o
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-objcopy -O binary ./ainv.bin ./ainv.sav
python3 ~/data/develop/UKNC/GCC-PDP11/bin/bin2sav.py ./ainv.sav

cp -f ./ainv.sav ../../../../dsk/ainv.sav

cd ../../../../dsk

./builddsk_ainv.sh

