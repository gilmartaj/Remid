import core.stdc.stdlib : exit; // importa a função de encerramento manual do programa
import derelict.sdl2.sdl; // importa a ligação da biblioteca SDL2
import derelict.sdl2.mixer; // importa a ligação da biblioteca SDL2 Mixer
import std.array : split; //separar as strings
import std.file : exists; // importa a função que verifica a existência de um arquivo
import std.stdio : readln, write, writeln; // importa a função de escrita na tela com quebra de linha depois do que é escrito
import std.string: strip, toStringz; //importa as funções da biblioteca de strings
                                     //strip limpa os espaços em volta do texto, toStringz converte string e string C

// Método principal que executa o programa
void main(string[] args)
{
    enum erro = -1; // constante que representa erro de carregamento

    Mix_Music* audioCarregado; // ponteiro para a estrutura que representa o áudio na biblioteca SDL Mixer
    string caminhoArquivo; // caminho do arquivo carregado
    string comando; // comando digitado pelo usuário
    string[] opcoes; // utilizado para separar o comando dos parâmetros
    
    if(inicializar() == erro) // verifica se as bibliotecas foram iniciadas com sucesso
    {
        exit(1); // função de encerra o programa, retrnando código de erro 1
    }
    
    mostrarAjuda(); // mostra os comandos disponíveis
    
    while(true) // repete infinitamente até que o programa seja encerrado
    {
        write("comando: ");
        comando = readln(); // lê uma linha e armazena na variável comando
        opcoes = split(comando); // separa a string por caracteres de branco e salva na variável opções
        
        if(opcoes.length) // verifica se o usuário digitou algo diferente de brancos
        {
            switch(opcoes[0]) // estrutura que decide o que fazer de acordo com o comando informado pelo usuário
            {
                case "ajuda", "a":
                    mostrarAjuda();
                    break;
                case "carregar", "c":
                    if(opcoes.length > 1) // o comando carregar precisa do nome do arquivo como parâmetro, então verifica se o parâmetro foi informado
                    {
                        if(estaTocando())
                            pararAudio();
                        caminhoArquivo = strip(strip(comando)[opcoes[0].length..$]); // identifica o caminho digitado e salva em caminhoArquivo
                        if(!exists(caminhoArquivo)) // verifica se o arquivo existe
                        {
                            audioCarregado = null; // se não existe, anula a variável que representa o áudio carregado e mostra mensagem
                            writeln("Arquivo não encontrado");
                        }
                        else 
                        {
                            audioCarregado = carregarAudio(caminhoArquivo); // carrega o áudio e salva o ponteiro para a estrutura
                            if(!audioCarregado) // verifica se o áudio foi carregado com sucesso, se não foi exibe mensagem de erro
                                writeln("Erro ao carregar arquivo.");
                        }
                    }
                    else
                    {
                         writeln("Caminho do áudio não informado.");
                    }
                    break;
                case "reproduzir", "r":
                    if(audioCarregado) 
                    {
                        if(estaParado())
                        {
                            // se o áudio está parado (não começou, foi parado pelo usuário ou apenas terminou
                            // carrega o áudio novamente, pois reexecutar nos casos de ele ter sido parado pelo usuário
                            // se o áudio está parado (não começou, foi parado pelo usuário ou apenas terminougerava uma pequena falha no reinício da reprodução
                            audioCarregado = carregarAudio(caminhoArquivo);                                                   
                            reproduzirAudio(audioCarregado);
                        }
                        else if(estaPausado)
                        {
                             continuarAudio(); // se o áudio foi pausado, apenas continua de onde parou
                        }
                        else
                        {
                            writeln("O áudio já está tocando.");
                        }
                    }
                    else
                    {
                        writeln("Não há áudio carregado.");
                    }
                    break;
                case "pausar", "p":
                        if(estaTocando())
                            pausarAudio();  // pausa o áudio
                        else
                            writeln("O áudio não está tocando.");
                    break;
                case "terminar", "t":
                    if(!estaParado())
                    {
                        pararAudio(); // para o áudio
                        if(estaPausado())
                            continuarAudio();
                    }
                    else
                        writeln("O áudio já está parado.");
                    break;
                case "sair", "s":
                    exit(0); // sai do programa com estado 0 (sem erro)
                    break;    
                default:
                    writeln("Comando inválido.");  // exibe a mensagem, caso o usuário informe um comando inválido
                    break;
            }
        }
    }
}

Mix_Music* carregarAudio(string caminhoArquivo)
{
    // carrega áudio a partir do caminho informado
    // toStringz é para converter a string D em string C (terminada com '\')
    return Mix_LoadMUS(toStringz(caminhoArquivo));
}

void continuarAudio()
{
     Mix_ResumeMusic(); // continua o áudio carregada de onde parou (caso tenha sido pausada)
}

bool estaParado()
{
    return !estaTocando() && !estaPausado(); // verifica se o áudio está parado (ele está parado se não está tocando e nem pausado)
}

bool estaPausado()
{
    return cast(bool) Mix_PausedMusic(); // verifica se o áudio está pausado (a função da biblioteca retorna 1 ou 0, então é feita a conversão para bool)
}

bool estaTocando()
{
    return cast(bool) Mix_PlayingMusic(); // verifica se o áudio está tocando (a função da biblioteca retorna 1 ou 0, então é feita a conversão para bool)
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

void mostrarAjuda()
{
    // usa uma string delimitada com () para gerar o texto do menu de uma forma mais visível no código
    // (a primeira quebra de linha depois de ( não faz parte do resultado gerado)
    writeln(q"(
[carregar | c] caminho_do_audio --> carrega o áudio especificado no caminho
[reproduzir | r] [caminho_do_audio]--> toca o áudio carregado anteriormente
[pausar | p] --> pausa o áudio (se estiver tocando)
[terminar | t] --> termina o áudio
[sair | s] - encerra o programa
[ajuda | a] - mostra esta ajuda
)");
}

void pararAudio()
{
    Mix_HaltMusic(); // para o áudio (caso tenha sido iniciado)
}
void pausarAudio()
{
    Mix_PauseMusic(); // pausa o áudio (caso esteja tocando)  
}

void reproduzirAudio(Mix_Music* audio)
{
    Mix_PlayMusic(audio, 1); // reproduz o áudio passado como argumento 1 vez (-1 repetiria "infinitamente")
}
