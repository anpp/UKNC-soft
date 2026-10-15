#!/usr/bin/bash

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -std=gnu23 -fomit-frame-pointer -O2 \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -c turmit.c -o turmit.o

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -Wl,-Map=turmit.map \
    ./../libgraph/libgraph.o \
    ./../libkeyb/libkeyb.o \
    ./turmit.o \
    -o turmit.sav

cp -f ./turmit.sav ../../../../dsk/turmit.sav

cd ../../../../dsk

./builddsk_turmit.sh

