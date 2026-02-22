extends CanvasLayer

@onready var timer_label = $TimerLabel
@onready var score_label = $ScoreLabel

func _ready():
	GameManager.game_started.connect(_on_game_started)
	GameManager.goal_scored.connect(_on_goal_scored)
	GameManager.game_ended.connect(_on_game_ended)

func _process(_delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		var time_left = int(GameManager.match_duration - GameManager.match_time)
		timer_label.text = str(time_left)

func _on_game_started():
	update_score()

func _on_goal_scored(_team):
	update_score()

func _on_game_ended():
	timer_label.text = "GAME OVER"

func update_score():
	score_label.text = str(GameManager.score_left) + " - " + str(GameManager.score_right)
