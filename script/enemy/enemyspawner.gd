extends Node2D
class_name EnemySpawner

@export var enemy_scene : PackedScene
@export var max_enemies : int = 10
@export var spawn_interval : float = 3.0

var spawn_timer : float = 0.0

func _ready() -> void:
	try_spawn()

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		#try_spawn()

func try_spawn() -> void:
	var current = get_tree().get_nodes_in_group("enemies").size()
	if current >= max_enemies:
		return
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(enemy)
