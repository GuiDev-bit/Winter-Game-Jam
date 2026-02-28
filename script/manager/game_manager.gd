extends Node

signal game_started
signal game_ended
signal goal_scored(team)
signal player_respawn

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var has_already_scored := false

var current_state : GameState = GameState.MENU
var match_time : float = 0.0
var match_duration : float = 120.0


var selected_weapon : String = "gloves"  

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
	match_duration = MatchManager.match_duration
	current_state = GameState.PLAYING
	AudioManager.play_game_music()
	respawn_player()
	emit_signal("game_started")

func end_game():
	current_state = GameState.GAME_OVER
	
	emit_signal("game_ended")
	MatchManager._on_game_ended()

func add_goal(team: String) -> void:
	if has_already_scored :
		return
	if team == "left":
		score_left += 1
		MatchManager.team_left_score = score_left
	elif team == "right":
		score_right += 1
		MatchManager.team_right_score = score_right
	emit_signal("goal_scored", team)
	has_already_scored = true
	# Vérification de la victoire via l'autre Autoload
	var winner = MatchManager.check_win_condition()
	if winner != "":
		end_game()
		return
	await get_tree().create_timer(2.0).timeout
	respawn_player()
	has_already_scored = false

func respawn_player():
	player_respawn.emit()


func reset() -> void:
	score_left = 0
	score_right = 0
	match_time = 0.0
	current_state = GameState.MENU
