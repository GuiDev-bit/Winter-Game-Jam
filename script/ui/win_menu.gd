extends Control

@onready var label : Label = $Panel/MarginContainer/VBoxContainer/Label

func _ready() -> void:
	AudioManager.play_win_music()
	var score = GameManager.score_left
	SaveManager.save_score(score)
	var scores = SaveManager.load_scores()
	var text = "TOP 5\n"
	for i in range(scores.size()):
		text += str(i + 1) + ". " + str(scores[i]) + "\n"
	label.text = text

func _on_play_again_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/main/main.tscn")

func _on_main_menu_pressed() -> void:
	GameManager.reset()
	Transition.change_scene("res://scenes/ui/main_menu.tscn")
