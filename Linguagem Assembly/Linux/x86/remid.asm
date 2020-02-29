; Define printf as an external function
EXTERN SDL_Init
EXTERN Mix_OpenAudio
EXTERN Mix_LoadMUS
EXTERN Mix_PlayMusic
EXTERN Mix_PlayingMusic

SDL_INIT_AUDIO equ 0x00000010
AUDIO_S16LSB equ 0x8010

SECTION .DATA
    mensagemLeitura: db "Informe o caminho do áudio: ", 0
    comprimentoLeitura: equ $-mensagemLeitura
    mensagemSaida:	db "O áudio terminou de tocar.\n", 0
    comprimentoSaida: equ $-mensagemSaida
    
SECTION .bss
caminhoAudio: resb 256

SECTION .TEXT
    global main
    
main:
    push dword SDL_INIT_AUDIO
    call SDL_Init
    add esp, 4
    push dword 1024
    push dword 2
    push dword AUDIO_S16LSB
    push dword 44100    
    call Mix_OpenAudio
    add esp, 16
    
    mov eax, 0x04
    mov ebx, 1
    mov ecx, mensagemLeitura
    mov edx, comprimentoLeitura
    int 0x80
    
    mov     edx, 255
    mov     ecx, caminhoAudio     
    mov     ebx, 0          
    mov     eax, 3           
    int     0x80  
    
    mov ecx, 256
    mov edi, caminhoAudio
    mov eax, 13
    repne scasb
    mov byte [edi-1], 0
    
    or ecx, ecx
    jnz tocar
    
    mov ecx, 256
    mov edi, caminhoAudio
    mov eax, 10
    repne scasb
    mov byte [edi-1], 0
    
    tocar:
    push dword caminhoAudio
    call Mix_LoadMUS
    add esp, 4
    push dword 1
    push eax
    call Mix_PlayMusic
    add esp, 8
    
    continuar:
    call Mix_PlayingMusic
    and eax, 1
    jnz continuar
    
    mov eax, 0x04
    mov ebx, 1
    mov ecx, mensagemSaida
    mov edx, comprimentoSaida
    int 0x80

    mov	eax,0	; Exit code 0
    ret			; Return
