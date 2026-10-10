#!/usr/bin/bash

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc \
    -std=gnu23 -fomit-frame-pointer -O2 \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -c plot.c -o plot.o

~/data/develop/UKNC/GCC-UKNC-RT11/gcc/bin/pdp11-uknc-rt11-gcc -nostartfiles \
    -Wl,-Map=plot.map \
    ./../crt/crt0.o \
    ./../libgraph/libgraph.o \
    ./../libkeyb/libkeyb.o \
    ./plot.o \
    -o plot.sav

cp -f ./plot.sav ../../../../dsk/plot.sav

cd ../../../../dsk

./builddsk_plot.sh

