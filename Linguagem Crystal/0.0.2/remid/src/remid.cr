require "../lib/sdl.cr-master/src/**"
require "option_parser"

ERRO = -1
audio_carregado : Pointer(LibMix::Music) | Nil = nil
caminho_arquivo : String = ""

def carregar_audio(caminho_arquivo : String)
  # carrega áudio a partir do caminho informado
  return LibMix.load_mus caminho_arquivo if caminho_arquivo
end

def continuar_audio
  # continua o áudio carregada de onde parou (caso tenha sido pausada)
  LibMix.resume_music
end

def esta_parado
  # verifica se o áudio está parado (ele está parado se não está tocando e nem pausado)
  return !esta_tocando && !esta_pausado
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

def parar_audio
  LibMix.halt_music # para o áudio (caso tenha sido iniciado)
end

def pausar_audio
  LibMix.pause_music # pausa o áudio (caso esteja tocando)  
end

def reproduzir_audio(audio : Pointer(LibMix::Music))
    LibMix.play_music audio, 1 if audio# reproduz o áudio passado como argumento 1 vez (-1 repetiria "infinitamente")
end

if inicializar() == ERRO
  puts "Erro ao executar."
  exit 1
end

mostrar_ajuda

loop do
  print "comando: "
  comando = read_line
  
  opcoes = comando.split
  
  if opcoes.size > 0
    case opcoes[0]
      when "ajuda", "a"
        mostrar_ajuda
      when "carregar", "c"
        if opcoes.size > 1
          parar_audio if esta_tocando
          auxiliar = comando.strip
          caminho_arquivo = auxiliar[opcoes[0].size...auxiliar.size].strip
          if !File.exists? caminho_arquivo
            audio_carregado = nil
            puts "Arquivo não encontrado."
          else
            audio_carregado = carregar_audio caminho_arquivo
            puts "Erro ao carregar arquivo." if !audio_carregado
          end
        else
          puts "Caminho do áudio não informado."
        end
      when "reproduzir", "r"
        if audio_carregado
          if esta_parado
            audio_carregado = carregar_audio caminho_arquivo
            if audio_carregado #carrega o áudio de novo para corrigir um pequeno bug que acontece quando o áudio é reiniciado sem ser recarregado
              reproduzir_audio audio_carregado
            else
              puts "Erro ao reproduzir."
            end
          elsif esta_pausado
            continuar_audio
          else 
            puts "O áudio já está tocando."
          end
        else
          puts "Não há áudio carregado."
        end
      when "pausar", "p"
        if esta_tocando
          pausar_audio 
        else
          puts "O áudio não está tocando." 
        end
      when "terminar", "t"
        if !esta_parado
          parar_audio
        else puts
          "O áudio já está parado." 
        end
      when "sair", "s"
      exit 0
      else
        puts "Comando inválido."
    end
  end
end
