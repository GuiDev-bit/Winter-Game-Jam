extends Control

@onready var start : Button = $VBoxContainer/Start
@onready var settings : Button = $VBoxContainer/Settings
@onready var exit : Button = $VBoxContainer/Exit

func _ready() -> void:
	AudioManager.play_menu_music()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/level_selector.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
