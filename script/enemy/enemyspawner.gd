extends Node2D
class_name EnemySpawner


@export var enemy_scene: PackedScene 
@export var spawn_points: Array[Node2D] 
@export var respawn_cooldown: float = 3.0

# On utilise les clés de l'enum directement
var enemy_quantities = {
	Enemy.Type.BATTEUR: 2,
	Enemy.Type.BOXEUR: 0,
	Enemy.Type.CANON: 0
}

func _ready():
	for type in enemy_quantities:
		for i in range(enemy_quantities[type]):
			spawn_enemy(type)

func spawn_enemy(type: Enemy.Type):
	var enemy_instance = enemy_scene.instantiate()
	# On assigne le type et la référence
	enemy_instance.type = type
	enemy_instance.spawner_manager = self
	
	enemy_instance.global_position = spawn_points.pick_random().global_position
	add_child(enemy_instance)

func start_respawn_cooldown(type: Enemy.Type):
	get_tree().create_timer(respawn_cooldown).timeout.connect(spawn_enemy.bind(type))
	#get_tree().current_scene.add_child.call_deferred(enemy)
