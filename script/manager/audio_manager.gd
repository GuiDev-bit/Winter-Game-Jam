extends Node

@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var sfx_player : AudioStreamPlayer = $SFXPlayer

func play_sfx(stream: AudioStream) -> void:
	sfx_player.stream = stream
	sfx_player.play()

func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream:
		return
	music_player.stream = stream
	music_player.play()
