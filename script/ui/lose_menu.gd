extends Control

func _on_retry_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/main/main.tscn")

func _on_main_menu_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
