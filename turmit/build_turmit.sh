#!/usr/bin/bash

#pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c turmit.c -S
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ./turmit.c
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-ld -T ~/data/develop/UKNC/GCC-PDP11/bin/no_header.ld -o ./turmit.bin ./../crt/crt0.o ./../libgraph/libgraph.o ./../libkeyb/libkeyb.o ./turmit.o
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-objcopy -O binary ./turmit.bin ./turmit.sav
python3 ~/data/develop/UKNC/GCC-PDP11/bin/bin2sav.py ./turmit.sav

cp -f ./turmit.sav ../../../../dsk/turmit.sav

cd ../../../../dsk

./builddsk_turmit.sh

