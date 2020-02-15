import derelict.sdl2.sdl; // importa a ligação da biblioteca SDL2
import derelict.sdl2.mixer; // importa a ligação da biblioteca SDL2 Mixer

import std.stdio : writeln; // importa a função de escrita na tela com quebra de linha depois do que é escrito

/// Método principal que executa o programa
void main(string[] args) {

	try // bloco de execução do programa (se ocorrer algum erro, entra no bloco catch)
	{
    // Carrega a biblioteca SDL2
    DerelictSDL2.load(); 

    // Carrega a biblioteca SDL2 Mixer
    DerelictSDL2Mixer.load();

	// Inicializa a biblioteca SDL configurada para áudioinicializa a biblioteca SDL configurada para áudio
    SDL_Init(SDL_INIT_AUDIO); 
    // Inicializa a API de mixer de áudio
	Mix_OpenAudio( 44100, MIX_DEFAULT_FORMAT, 2, 1024);
	// Carrega o arquivo de música para usar, salvando na variável musica
	// (A concatenação com o caractere \0 acontece pois este é o caractere padrão para fim de string da
	// linguagem C, na qual são desenvolvidas as bibliotecas SDL)
	// A variável args[1] refere-se ao primeiro argumento passado na linha de comando quando o programa é executado
	Mix_Music *audio = Mix_LoadMUS((args[1]~'\0').ptr);
	// Reproduz o áudio 1 vez (-1 pode ser passado para repetir "infinitamente")
	Mix_PlayMusic( audio, 1 );
	// Executa o programa enquanto o áudio estiver tocando
	while (Mix_PlayingMusic()) {}
	
	// Quando a música termina normalmente, exibe uma mensagem para o usuário
	writeln("O áudio terminou de tocar.");
	
	}
	catch (Exception e)
	{
		// Caso ocorra algum erro, mostra uma mensagem para o usuário
		writeln("Erro ao executar.");
	}
}
