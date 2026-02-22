extends Node2D

func _ready() -> void:
	GameManager.start_game()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if GameManager.current_state == GameManager.GameState.PLAYING:
			get_tree().paused = true
			GameManager.current_state = GameManager.GameState.PAUSED
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			get_tree().paused = false
			GameManager.current_state = GameManager.GameState.PLAYING
