extends Node

var music_player : AudioStreamPlayer
var sfx_player : AudioStreamPlayer
var enemy_hit_sfx : AudioStream
var slide_sfx : AudioStream
var jump_sfx : AudioStream
var cannon_sfx : AudioStream

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
	enemy_hit_sfx = load("res://assets/audio/SFX/840218_kreha_hurt-3 (online-audio-converter.com) (2).ogg")
	slide_sfx = load("res://assets/audio/SFX/articulated_ICE+Skate+scrape+one+leg+drag+04.mp3")
	jump_sfx = load("res://assets/audio/SFX/386529_glennm_breathing_jumping (online-audio-converter.com) (2).ogg")
	cannon_sfx = load("res://assets/audio/SFX/crazy-diamond-punch (1) (online-audio-converter.com).ogg")
	
	var volumes = SaveManager.load_volume()
	set_music_volume(volumes["music"])
	set_sfx_volume(volumes["sfx"])
	
	menu_music = load("res://assets/audio/music/music menu/MENU SWAF (1).ogg")
	win_music = load("res://assets/audio/music/music/VICTOIRE (online-audio-converter.com).ogg")
	bat_hit_sfx = load("res://assets/audio/SFX/SFX BaseBall Bat (1) (online-audio-converter.com).ogg")

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
		
	var player = AudioStreamPlayer.new()
	player.bus = "SFX"
	player.stream = stream
	
	add_child(player)
	player.play()
	
	player.finished.connect(player.queue_free)

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

func play_enemy_hit():
	play_sfx(enemy_hit_sfx)

func play_slide():
	play_sfx(slide_sfx)

func play_jump():
	play_sfx(jump_sfx)

func play_cannon():
	play_sfx(cannon_sfx)
