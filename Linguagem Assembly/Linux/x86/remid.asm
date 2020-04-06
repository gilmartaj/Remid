EXTERN Mix_CloseAudio
EXTERN Mix_LoadMUS
EXTERN Mix_OpenAudio
EXTERN Mix_PlayMusic
EXTERN Mix_PlayingMusic
EXTERN SDL_Init

SDL_INIT_AUDIO equ 0x00000010
AUDIO_S16LSB equ 0x8010

SECTION .DATA
    mensagemFimAudio:	db "O áudio terminou de tocar.", 10, 0
    comprimentoMsgFimAudio: equ $-mensagemFimAudio
    mensagemErro: db "Erro ao reproduzir.", 10, 0
    comprimentoMsgErro: equ $-mensagemErro
    
SECTION .bss
enderecoCaminhoAudio: resd 1

SECTION .TEXT
    global main
    
main:
	mov eax, [esp+8]
	add eax, 4
	mov esi, [eax]
	mov [enderecoCaminhoAudio], esi
	
    push dword SDL_INIT_AUDIO
    call SDL_Init
    add esp, 4
    push dword 1024
    push dword 2
    push dword AUDIO_S16LSB
    push dword 44100    
    call Mix_OpenAudio
    add esp, 16
    
tocar:
    push dword [enderecoCaminhoAudio]
    call Mix_LoadMUS
    add esp, 4
    push dword 1
    push eax
    call Mix_PlayMusic
    add esp, 8
    
    cmp eax, 0
    je continuar_tocando
    
erro:
    mov eax, 0x04
    mov ebx, 1
    mov ecx, mensagemErro
    mov edx, comprimentoMsgErro
    int 0x80
    jmp fim_do_programa
    
continuar_tocando:
    call Mix_PlayingMusic
    cmp eax, 1
    je continuar_tocando
    
    mov eax, 0x04
    mov ebx, 1
    mov ecx, mensagemFimAudio
    mov edx, comprimentoMsgFimAudio
    int 0x80
	
fim_do_programa:
	call Mix_CloseAudio
    mov	eax, 1
    mov ebx, 0
    int 0x80
    ret
