nasm -f elf64 remid.asm -o remid.o && gcc -no-pie remid.o -o remid -lSDL -lSDL_mixer
