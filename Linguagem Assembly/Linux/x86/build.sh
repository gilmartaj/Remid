nasm -f elf remid.asm -o remid.o && gcc -m32  remid.o -o remid -lSDL -lSDL_mixer
