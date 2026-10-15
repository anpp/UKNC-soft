#!/usr/bin/bash

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -std=gnu23 -fomit-frame-pointer -O2 \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -c ainv.c -o ainv.o

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -Wl,-Map=ainv.map \
    ./../libkeyb/libkeyb.o \
    ./../libgraph/libgraph.o \
    ./ainv.o \
    -o ainv.sav

cp -f ./ainv.sav ../../../../dsk/ainv.sav

cd ../../../../dsk

./builddsk_ainv.sh

