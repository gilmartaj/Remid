#include "../../include/SDL.h"
#include "../../include/SDL_mixer.h"

#include <iostream>

using namespace std;

int main(int argc, char** argv)
{	
	int erro = 0;
	SDL_Init(SDL_INIT_AUDIO);
	Mix_OpenAudio( 44100, MIX_DEFAULT_FORMAT, 2, 1024);
	Mix_Music *audio = Mix_LoadMUS(argv[1]);
	erro = Mix_PlayMusic(audio, 1);
	if(erro == -1)
	{
		cout << "Erro ao reproduzir.\n";
		exit(1);
	}
	while(Mix_PlayingMusic());
	cout << "O áudio terminou de tocar\n";
}
