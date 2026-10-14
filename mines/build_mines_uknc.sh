#!/usr/bin/bash

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -std=gnu23 -fomit-frame-pointer -O2 \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -c mines.c -S

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -std=gnu23 -fomit-frame-pointer -O2 \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -c mines.c -o mines.o

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -Wl,-Map=mines.map \
    ./../libkeyb/libkeyb.o \
    ./../libmouse/libmouse.o \
    ./../libgraph/libgraph.o \
    ./../common/lfsr.o \
    ./mines.o \
    -o mines.sav

cp -f ./mines.sav ../../../../dsk/mines.sav

cd ../../../../dsk

./builddsk_mines.sh

