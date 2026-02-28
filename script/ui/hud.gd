extends CanvasLayer

@onready var timer_label = $Control/TimerLabel
@onready var score_label = $Control/ScoreLabel
@onready var controls_hud : Control = $ControlsHUD
@onready var health_label : Label = $HealthHUD/Label
@onready var munition :=$ControlsHUD/munition

var player_health_comp : HealthComponent = null
var player : Player

func _ready() -> void:
	GameManager.game_started.connect(_on_game_started)
	GameManager.goal_scored.connect(_on_goal_scored)
	GameManager.game_ended.connect(_on_game_ended)
	controls_hud.visible = SaveManager.load_controls_visible()
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	if player:
		player_health_comp = player.get_node_or_null("HealthComponent")
		if player_health_comp:
			player_health_comp.health_changed.connect(_on_health_changed)
			if health_label:
				health_label.text = str(int(player_health_comp.health)) + " / " + str(int(player_health_comp.max_health))

func _process(_delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		var time_left = int(GameManager.match_duration - GameManager.match_time)
		@warning_ignore("integer_division")
		var minutes : int = time_left / 60
		var seconds : int = time_left % 60
		timer_label.text = str(minutes) + ":" + ("%02d" % seconds)
		if player and player.secondary_weapon == player.Weapon.CANON :
			munition.text =str(int(player.current_munition )) + "/" + str(int(player.munition_max))
		
		
func _on_health_changed(new_health: float) -> void:
	health_label.text = str(int(new_health)) + " / " + str(int(player_health_comp.max_health))

func _on_game_started() -> void:
	update_score()

func _on_goal_scored(_team) -> void:
	update_score()

func _on_game_ended() -> void:
	timer_label.text = "0:00"

func update_score() -> void:
	score_label.text = str(GameManager.score_left) + " - " + str(GameManager.score_right)

func set_controls_visible(value: bool) -> void:
	controls_hud.visible = value
	SaveManager.save_controls_visible(value)
