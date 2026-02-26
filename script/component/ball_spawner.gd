extends Node2D
class_name Ball_spawner

@export var ball : Ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_respawn.connect(Callable(self, "spawn_ball"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_ball():
	if ball == null : 
		return
	ball.global_position = global_position
	
