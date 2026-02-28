extends Node2D
class_name PlayerSpawn

@export var player : Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_respawn.connect(Callable(self, "spawn_player"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func spawn_player():
	if player == null : 
		return
	player.global_position = global_position
	
