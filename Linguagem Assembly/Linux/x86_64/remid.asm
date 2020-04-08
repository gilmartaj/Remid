EXTERN Mix_LoadMUS
EXTERN Mix_OpenAudio
EXTERN Mix_PlayMusic
EXTERN Mix_PlayingMusic
EXTERN SDL_Init
EXTERN SDL_Quit

SDL_INIT_AUDIO equ 0x00000010
AUDIO_S16LSB equ 0x8010

SECTION .DATA
    mensagemFimAudio:	db "O áudio terminou de tocar.", 10, 0
    comprimentoMsgFimAudio: equ $-mensagemFimAudio
    mensagemErro: db "Erro ao reproduzir.", 10, 0
    comprimentoMsgErro: equ $-mensagemErro
    
SECTION .bss
enderecoCaminhoAudio: resq 1

SECTION .TEXT
    global main
    
main:    

    mov rax, rsi
    add rax, 8
    mov rsi, [rax]
    mov [enderecoCaminhoAudio], rsi
	
    push SDL_INIT_AUDIO
    call SDL_Init
    
    mov rdi, 44100
    mov rsi, AUDIO_S16LSB
    mov rdx, 2
    mov rcx, 1024
    call Mix_OpenAudio
    
tocar:
    
    mov rdi, [enderecoCaminhoAudio]
    call Mix_LoadMUS
    
    mov rdi, rax
    mov rsi, 1
    call Mix_PlayMusic
    
    cmp rax, 0
    je continuar_tocando
    
erro:
    mov rax, 1
    mov rdi, 1
    mov rsi, mensagemErro
    mov rdx, comprimentoMsgErro
    syscall
    jmp fim_do_programa
    
continuar_tocando:
    call Mix_PlayingMusic
    cmp rax, 1
    je continuar_tocando
    
    mov rax, 1
    mov rdi, 1
    mov rsi, mensagemFimAudio
    mov rdx, comprimentoMsgFimAudio
    syscall
	
fim_do_programa:
    call SDL_Quit
    mov	rax, 60
    mov rdi, 0
    syscall
