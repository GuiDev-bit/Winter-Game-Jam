extends Control

# Button et Button2 dans le GridContainer = niveau 1 et 2
@onready var level1 : Button = $PanelContainer/VBoxContainer/GridContainer/Button
@onready var level2 : Button = $PanelContainer/VBoxContainer/GridContainer/Button2
@onready var back : Button = $PanelContainer/VBoxContainer/Button

func _on_button_pressed() -> void:
	# Niveau 1 = arena de base
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_button_2_pressed() -> void:
	# Niveau 2 à faire plus tard
	pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
