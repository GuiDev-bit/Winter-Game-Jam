extends Node

var music_player : AudioStreamPlayer
var sfx_player : AudioStreamPlayer

@export var menu_music : AudioStream
@export var win_music : AudioStream
@export var bat_hit_sfx : AudioStream
@export var game_music : AudioStream

func _ready() -> void:
	game_music = load("res://assets/audio/SNOW IN YOUR HAND vf (2).ogg")
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	sfx_player.bus = "SFX"
	add_child(music_player)
	add_child(sfx_player)
	
	var volumes = SaveManager.load_volume()
	set_music_volume(volumes["music"])
	set_sfx_volume(volumes["sfx"])
	
	menu_music = load("res://assets/audio/music/music menu/MENU SWAF (1).ogg")
	win_music = load("res://assets/audio/music/music/VICTOIRE.wav")
	bat_hit_sfx = load("res://assets/audio/SFX/SFX BaseBall Bat (1).wav")

func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream and music_player.playing:
		return
	stop_music()
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	sfx_player.stream = stream
	sfx_player.play()

func play_menu_music() -> void:
	play_music(menu_music)

func play_win_music() -> void:
	play_music(win_music)

func play_game_music() -> void:
	play_music(game_music)

func play_bat_hit() -> void:
	play_sfx(bat_hit_sfx)

func set_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value)
	)

func set_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(value)
	)

func get_music_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Music")
	))

func get_sfx_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("SFX")
	))
