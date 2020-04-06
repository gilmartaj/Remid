require "../lib/sdl.cr-master/src/**"
require "option_parser"

begin
  LibSDL.init(LibSDL::INIT_AUDIO)
  LibMix.open_audio(44100, LibMix::Mix_DEFAULT_FORMAT, 2, 1024)
  audio = LibMix.load_mus(ARGV[0])
  erro = LibMix.play_music(audio, 1)
  if erro == -1
    puts "Erro ao reproduzir."
    exit 1
  end
  until LibMix.music_playing == 0
  end
  puts "O áudio terminou de tocar."
rescue
  puts "Erro ao reproduzir."
end
