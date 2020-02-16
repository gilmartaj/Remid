import pygame # Biblioteca para manipulação de áudio (MP3, WAV, OGG, MOD)
import sys # Biblioteca para acessar os parâmetros do console

try:
    # Inicializa a biblioteca
    pygame.init()
    # Carrega o áudio
    pygame.mixer.music.load(sys.argv[1])
    # Reproduz o áudio
    pygame.mixer.music.play()
	#mantém o programa ativo enquanto a música estiver tocando
    while pygame.mixer.music.get_busy(): 
       	pass # não faz nada
    # Quando terminar de torcar, mostra a mensagem
    print("O áudio terminou de tocar.")       
except: # Caso ocorra algum erro, mostra a mensagem
    print('Erro ao reproduzir.')
