extends Control

@onready var music_slider : HSlider = $HBoxContainer/VBoxContainer/Music/HSlider
@onready var sfx_slider : HSlider = $HBoxContainer/VBoxContainer/SFX/HSlider
@onready var back : Button = $HBoxContainer/VBoxContainer/Back
@onready var reset : Button = $"HBoxContainer/VBoxContainer/Reset to default"

func _ready() -> void:
	var volumes = SaveManager.load_volume()
	music_slider.value = volumes["music"]
	sfx_slider.value = volumes["sfx"]

func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
	SaveManager.save_volume(value, sfx_slider.value)

func _on_h_slider_2_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.save_volume(music_slider.value, value)

func _on_reset_to_default_pressed() -> void:
	music_slider.value = 1.0
	sfx_slider.value = 1.0
	AudioManager.set_music_volume(1.0)
	AudioManager.set_sfx_volume(1.0)
	SaveManager.save_volume(1.0, 1.0)

func _on_back_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
