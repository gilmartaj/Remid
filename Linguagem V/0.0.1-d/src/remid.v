import os

#flag -I../../include/
#flag -lSDL 
#flag -lSDL_mixer

#include "SDL.h"
#include "SDL_mixer.h"

fn C.SDL_Init(u32) int
fn C.Mix_OpenAudio(int, u16, int, int) int
fn C.Mix_LoadMUS(&char) &C.Mix_Music
fn C.Mix_PlayMusic(C.Mix_Music, int) int
fn C.Mix_PlayingMusic() int

fn main()
{	
	C.SDL_Init(C.SDL_INIT_AUDIO)
	C.Mix_OpenAudio(44100, C.MIX_DEFAULT_FORMAT, 2, 1024)
	mus := C.Mix_LoadMUS(os.args[1].str)
	erro := C.Mix_PlayMusic(mus, 1)
	if erro == -1
	{
		println("Erro ao reproduzir.")
		exit(1)
	}
	for C.Mix_PlayingMusic() != 0 {}
	println("O áudio terminou de tocar.")
}