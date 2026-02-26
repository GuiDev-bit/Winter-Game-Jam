extends Control

func _ready() -> void:
	AudioManager.play_menu_music()
	Transition.fade_in_only()

func _on_start_pressed() -> void:
	Transition.change_scene("res://scenes/ui/level_selector.tscn")

func _on_settings_pressed() -> void:
	Transition.change_scene("res://scenes/ui/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
