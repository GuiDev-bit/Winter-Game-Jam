extends Control

func _on_button_pressed() -> void:
	# Niveau 1 = arena de base
	GameManager.reset()
	Transition.change_scene("res://scenes/main/main.tscn")

func _on_button_2_pressed() -> void:
	# Niveau 2 à faire plus tard
	pass

func _on_back_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn")


func _on_go_pressed() -> void:
	pass # Replace with function body.
