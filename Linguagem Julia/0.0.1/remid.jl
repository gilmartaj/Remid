struct Mix_Music
  type::Int32
  data::Int32
  fading::Int32
  fade_step::Int32
  fade_steps::Int32
  error::Int32
end

const SDL_INIT_AUDIO = 0x10
const AUDIO_S16LSB = 0x8010

ccall((:SDL_Init, :libSDL2), Cvoid, (Cint,), SDL_INIT_AUDIO)
ccall((:Mix_OpenAudio, :libSDL2_mixer), Cvoid, (Cint, Cint, Cint, Cint), 44100, AUDIO_S16LSB, 2, 1024)

audio = ccall((:Mix_LoadMUS, :libSDL2_mixer), Ptr{Mix_Music}, (Cstring,), ARGS[1])
erro = ccall((:Mix_PlayMusic, :libSDL2_mixer), Cint, (Ptr{Mix_Music}, Cint,), audio, 1)

if erro == -1
  println("Erro ao reproduzir.")
  exit(1)
end

while ccall((:Mix_PlayingMusic, :libSDL2_mixer), Cint, ()) != 0 end
println("O áudio terminou de tocar\n")


