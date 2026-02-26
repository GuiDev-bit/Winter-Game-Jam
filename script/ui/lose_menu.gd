extends Control

@onready var retry : Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Retry
@onready var main_menu : Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/Main Menu"

func _on_retry_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/main/main.tscn")

func _on_main_menu_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
