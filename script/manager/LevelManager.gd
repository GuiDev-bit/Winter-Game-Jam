extends Node

var current_level_data: LevelData
var spawner : EnemySpawner

func load_level(level_data: LevelData):
	current_level_data = level_data
	# On change de scène pour charger la map définie dans la ressource
	AiManager.enemies.clear()
	# Configure le storm manager avec le niveau max autorisé
	Stormmanager.setup(level_data.max_storm_level)
	# Lance le jeu
	GameManager.start_game()
	Transition.change_scene_packed(level_data.map_scene)

func _initialize_level_spawner():
	if spawner:
		# On donne les quantités de la ressourceau  spawner
		spawner.update_quantities_from_data(current_level_data)


func proper_charge_level():
		call_deferred("_initialize_level_spawner")
