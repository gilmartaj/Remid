import core.stdc.stdlib : exit;
import derelict.sdl2.sdl; // importa a ligação da biblioteca SDL2
import derelict.sdl2.mixer; // importa a ligação da biblioteca SDL2 Mixer
import std.array : split; //separar as strings
import std.file : exists;
import std.stdio : readln, write, writeln; // importa a função de escrita na tela com quebra de linha depois do que é escrito
import std.string: strip, toStringz;

// Método principal que executa o programa
void main(string[] args)
{
    if(inicializar() == -1)
    {
        exit(1);
    }

    string comando;
    string[] opcoes;
    Mix_Music* audioCarregado;
    bool comecou;
    bool tocando;
    
    writeln(q"(
[carregar | c] caminho_do_audio --> carrega o áudio especificado no caminho
[reproduzir | r] [caminho_do_audio]--> toca o áudio carregado anteriormente
[pausar | p] --> pausa o ádio (se estiver tocando)
[terminar | t] --> termina o áudio
[sair | s] - encerra o programa)");
    
    while(true)
    {
        write("comando: ");
        comando = readln();
        opcoes = split(comando);
        
        if(opcoes.length)
        {
            switch(opcoes[0])
            {
                case "carregar", "c":
                    string caminhoArquivo = strip(strip(comando)[opcoes[0].length..$]);
                    if(!exists(caminhoArquivo))
                    {
                        audioCarregado = null;
                        writeln("Arquivo não encontrado");
                    }
                    else 
                    {
                        audioCarregado = carregarAudio(caminhoArquivo);
                        if(!audioCarregado)
                        writeln("Erro ao carregar arquivo.");
                    }
                    comecou = false;
                    tocando = false;
                    break;
                case "reproduzir", "r":
                    if(audioCarregado)
                    {
                        if(tocando && !Mix_PlayingMusic())
                        {
                            tocando = comecou = false;
                        }
                        if(!comecou)
                        {
                            comecou = true;
                            reproduzirAudio(audioCarregado, true);
                        }
                        else
                            reproduzirAudio();
                        tocando = true;
                    }
                    else
                        writeln("Não há áudio carregado.");
                    break;
                case "pausar", "p":
                    pausarAudio();
                    tocando = false;
                    break;
                case "terminar", "t":
                    comecou = false;
                    tocando = false;
                    pararAudio();
                    break;
                case "sair", "s":
                    exit(0);
                    break;    
                default:
                    writeln("Comando inválido.");
                    break;
            }
        }
    }

    /*try // bloco de execução do programa (se ocorrer algum erro, entra no bloco catch)
    {
        // Carrega a biblioteca SDL2
        DerelictSDL2.load(); 
        // Carrega a biblioteca SDL2 Mixer
        DerelictSDL2Mixer.load();
	// Inicializa a biblioteca SDL configurada para áudioinicializa a biblioteca SDL configurada para áudio
        SDL_Init(SDL_INIT_AUDIO); 
        // Inicializa a API de mixer de áudio
        Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 1024);
        // Carrega o arquivo de música para usar, salvando na variável audio
        // (A concatenação com o caractere \0 acontece pois este é o caractere padrão para fim de string da
        // linguagem C, na qual são desenvolvidas as bibliotecas SDL)
        // A variável args[1] refere-se ao primeiro argumento passado na linha de comando quando o programa é executado
        Mix_Music* audio = Mix_LoadMUS((args[1]~'\0').ptr);
        // Reproduz o áudio 1 vez (-1 pode ser passado para repetir "infinitamente")
        Mix_PlayMusic(audio, 1);
        
        // Executa o programa enquanto o áudio estiver tocando
        while (Mix_PlayingMusic()) 
        {}
	
        // Quando a música termina normalmente, exibe uma mensagem para o usuário
        writeln("O áudio terminou de tocar.");
	}
	catch (Exception e)
	{
	    // Caso ocorra algum erro, mostra uma mensagem para o usuário
	    writeln("Erro ao executar.");
	}*/
}

int inicializar()
{
    // Carrega a biblioteca SDL2
    DerelictSDL2.load(); 
    // Carrega a biblioteca SDL2 Mixer
    DerelictSDL2Mixer.load();
	// Inicializa a biblioteca SDL configurada para áudioinicializa a biblioteca SDL configurada para áudio
    SDL_Init(SDL_INIT_AUDIO); 
    // Inicializa a API de mixer de áudio
    return Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 1024);
}

Mix_Music* carregarAudio(string caminhoArquivo)
{
    return Mix_LoadMUS(toStringz(caminhoArquivo));
}

void reproduzirAudio(Mix_Music* audio = null, bool doInicio = false)
{
    if(doInicio)
        Mix_PlayMusic(audio, 1);
    else
        Mix_ResumeMusic();
}

void pausarAudio()
{
    Mix_PauseMusic();
}

void pararAudio()
{
    pausarAudio();
    Mix_RewindMusic();
}
