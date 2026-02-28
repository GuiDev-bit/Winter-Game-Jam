extends Node2D
class_name EnemySpawner


@export var enemy_scene: PackedScene 
@export var spawn_points: Array[Node2D] 
@export var respawn_cooldown: float = 5.0

# On utilise les clés de l'enum directement
var enemy_quantities = {
	Enemy.Type.BATTEUR: 0,
	Enemy.Type.BOXEUR: 0,
	Enemy.Type.CANON: 0
}

func _ready():
	GameManager.player_respawn.connect(Callable(self, "correct_pos") )
	LevelManager.spawner = self
	LevelManager._initialize_level_spawner()
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


func update_quantities_from_data(data: LevelData):
	# On met à jour le dictionnaire interne du spawner avec les données de la ressource
	enemy_quantities = {
	Enemy.Type.BATTEUR: data.batteur_count,
	Enemy.Type.BOXEUR: data.boxeur_count,
	Enemy.Type.CANON : data.canon_count }
	# On relance le spawn avec ces nouvelles valeurs


func start_respawn_cooldown(type: Enemy.Type):
	await get_tree().create_timer(respawn_cooldown).timeout
	spawn_enemy(type)

func correct_pos():
	for enemi in AiManager.enemies:
		# is_instance_valid est ton meilleur ami ici
		if is_instance_valid(enemi) and enemi.is_inside_tree():
			enemi.global_position = spawn_points.pick_random().global_position
