extends Node2D

func _ready() -> void:
	GameManager.game_ended.connect(_on_game_ended)
	GameManager.start_game()
	AudioManager.play_game_music()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if GameManager.current_state == GameManager.GameState.PLAYING:
			get_tree().paused = true
			GameManager.current_state = GameManager.GameState.PAUSED
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			get_tree().paused = false
			GameManager.current_state = GameManager.GameState.PLAYING

func _on_game_ended() -> void:
	# Détermine gagnant
	if GameManager.score_left > GameManager.score_right:
		get_tree().change_scene_to_file("res://scenes/ui/win_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/lose_menu.tscn")
