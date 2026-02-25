extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	#await get_tree().process_frame
	GameManager.start_game()
