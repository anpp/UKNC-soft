#!/usr/bin/bash

#pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c testgraph.c -S
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-gcc -m40 -mint16 -nostdlib -fomit-frame-pointer -fno-builtin  -O2 -c ./testgraph.c
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-ld -T ~/data/develop/UKNC/GCC-PDP11/bin/no_header.ld -o ./testgraph.bin ./../crt/crt0.o ./../libgraph/libgraph.o ./../libmouse/libmouse.o ./../libkeyb/libkeyb.o ./../pdp11-soft-float/pdp11-fis.o ./testgraph.o
~/data/develop/UKNC/GCC-PDP11/bin/pdp11-aout-objcopy -O binary ./testgraph.bin ./testgraph.sav
python3 ~/data/develop/UKNC/GCC-PDP11/bin/bin2sav.py ./testgraph.sav

cp -f ./testgraph.sav ../../../../dsk/tstgr.sav

cd ../../../../dsk

./builddsk_tstgr.sh

