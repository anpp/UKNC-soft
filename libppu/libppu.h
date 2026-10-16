#ifndef LIB_PPU_H
#define LIB_PPU_H

extern void RunPPU(void* func_adr, unsigned int size);
extern unsigned int getmemPPU(unsigned int size);
extern void freememPPU(unsigned int adr);

#endif //LIB_PPU_H
