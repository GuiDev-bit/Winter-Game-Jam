extends Control

func _on_retry_pressed() -> void:
	GameManager.reset()
	LevelManager.load_level(LevelManager.current_level_data)

func _on_main_menu_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
