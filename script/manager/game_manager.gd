extends Node

signal game_started
signal game_ended
signal goal_scored(team)

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state : GameState = GameState.MENU
var match_time : float = 0.0
var match_duration : float = 60.0

var score_left : int = 0
var score_right : int = 0

func _process(delta):
	if current_state == GameState.PLAYING:
		match_time += delta
		if match_time >= match_duration:
			end_game()

func start_game():
	score_left = 0
	score_right = 0
	match_time = 0.0
	current_state = GameState.PLAYING
	emit_signal("game_started")

func end_game():
	current_state = GameState.GAME_OVER
	emit_signal("game_ended")

func add_goal(team : String):
	if team == "left":
		score_left += 1
	elif team == "right":
		score_right += 1

	emit_signal("goal_scored", team)
