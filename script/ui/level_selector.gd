extends Control

@onready var description_label : Label = $"PanelContainer/MarginContainer/Level Info/DescriptionLabel"

func _on_button_pressed() -> void:
	GameManager.reset()
	var level_data = load("res://script/Ressources/level1.tres")
	LevelManager.load_level(level_data)

func _on_button_2_pressed() -> void:
	GameManager.reset()
	var level_data = load("res://script/Ressources/level2.tres")
	LevelManager.load_level(level_data)

func _on_back_pressed() -> void:
	Transition.change_scene("res://scenes/ui/main_menu.tscn")

func _on_go_pressed() -> void:
	pass
