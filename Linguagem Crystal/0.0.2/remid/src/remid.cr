require "../lib/sdl.cr-master/src/**"
require "option_parser"

ERRO = -1

def carregar_audio(caminho_arquivo)
  # carrega áudio a partir do caminho informado
  return LibMix.load_mus caminho_arquivo
end

def continuar_audio
  # continua o áudio carregada de onde parou (caso tenha sido pausada)
  LibMix.resume_music
end

def esta_parado
  # verifica se o áudio está parado (ele está parado se não está tocando e nem pausado)
  return !estaTocando && !estaPausado
end

def esta_pausado
    # verifica se o áudio está pausado (a função da biblioteca retorna 1 ou 0, então é feita a conversão para bool)
    LibMix.music_paused == 0 ? false : true
end

def esta_tocando
  # verifica se o áudio está tocando (a função da biblioteca retorna 1 ou 0, então é feita a conversão para bool)
  LibMix.music_playing == 0 ? false : true
end

def inicializar
  # Inicializa a biblioteca SDL configurada para áudio
  LibSDL.init(LibSDL::INIT_AUDIO)
  # Inicializa a API de mixer de áudio
  return LibMix.open_audio(44100, LibMix::Mix_DEFAULT_FORMAT, 2, 1024)
end

def mostrar_ajuda
  # usa uma string para gerar o texto do menu de uma forma mais visível no código
  texto_ajuda = "[carregar | c] caminho_do_audio --> carrega o áudio especificado no caminho
[reproduzir | r] [caminho_do_audio]--> toca o áudio carregado anteriormente
[pausar | p] --> pausa o áudio (se estiver tocando)
[terminar | t] --> termina o áudio
[sair | s] - encerra o programa
[ajuda | a] - mostra esta ajuda"
  puts texto_ajuda
end

def pararAudio
  LibMix.halt_music # para o áudio (caso tenha sido iniciado)
end

def pausarAudio
  LibMix.pause_music # pausa o áudio (caso esteja tocando)  
end

def reproduzirAudio(audio : Pointer(LibMix::Music))
    LibMix.play_music audio, 1 # reproduz o áudio passado como argumento 1 vez (-1 repetiria "infinitamente")
end

loop do
  if inicializar() == ERRO
    puts "Erro ao executar."
    exit 1
  end
  x = gets
  break if x == "a"
end


