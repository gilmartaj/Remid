#include <SDL2/SDL.h>
#include <SDL2/SDL_mixer.h>

#include <stdio.h>

int main(int argc, char *argv[])
{	
	int erro = 0;
	SDL_Init(SDL_INIT_AUDIO);
	Mix_OpenAudio( 44100, MIX_DEFAULT_FORMAT, 2, 1024);
	Mix_Music *mus = Mix_LoadMUS(argv[1]);
	erro = Mix_PlayMusic( mus, 1 );
	if(erro == -1)
	{
		printf("Erro ao reproduzir.\n");
		exit(1);
	}
	while(Mix_PlayingMusic());
	printf("O áudio terminou de tocar\n");
}
