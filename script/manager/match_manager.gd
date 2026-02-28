extends Node

@export var match_duration : float = 120.0

signal match_configured
signal match_completed

enum MatchType {
	NORMAL,
	TUTORIAL,
	TIMED
}

# Configuration du match
var match_type : MatchType= MatchType.NORMAL
var score_to_win : int = 5 # points pour gagner
var storm_level : int = 0 

# Teams
var team_left_name : String = "Left"
var team_right_name : String = "Right"
var team_left_score : int = 0
var team_right_score : int = 0

func setup_match(type: MatchType , score_max : int, duration : float ) -> void:
	match_type = type
	score_to_win = score_max
	match_duration = duration
	team_left_score = 0
	team_right_score = 0
	emit_signal("match_configured")

func setup_tutorial() -> void:
	setup_match(MatchType.TUTORIAL, 2, 999.0)

func check_win_condition() -> String:
	if team_left_score >= score_to_win:
		emit_signal("match_completed")
		return "left"
	elif team_right_score >= score_to_win:
		emit_signal("match_completed")
		return "right"
	return ""

func _on_game_ended() -> void:
	var winner = check_win_condition()
	emit_signal("match_completed", winner)
	await get_tree().create_timer(1.5).timeout
	if winner == "left":
		Transition.change_scene("res://scenes/ui/win_menu.tscn")
		AudioManager.play_win_music()
	else:
		Transition.change_scene("res://scenes/ui/lose_menu.tscn")
	team_left_score = 0
	team_right_score = 0
		#AudioManager.
