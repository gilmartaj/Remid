local sdl = require "SDL"
local sdl_mixer	= require "SDL.mixer"

if(not arg[1]) then
  print("Erro ao reproduzir.")
  os.exit(1)
end

sdl.init(sdl.flags.Audio)
sdl_mixer.openAudio(44100, sdl.audioFormat.S16, 2, 1024)
audio = sdl_mixer.loadMUS(arg[1])

if(audio) then
  audio.play(audio, 1)
  repeat until not audio.playing()
  print("O áudio terminou de tocar.")
else
  print("Erro ao reproduzir.")
end


