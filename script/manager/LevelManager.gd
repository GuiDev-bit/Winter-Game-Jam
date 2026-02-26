extends Node

var current_level_data: LevelData

func load_level(level_data: LevelData):
	current_level_data = level_data
	# On change de scène pour charger la map définie dans la ressource
	get_tree().change_scene_to_packed(level_data.map_scene)

	call_deferred("_initialize_level_spawner")

func _initialize_level_spawner():
	var spawner = get_tree().current_scene.find_child("EnemySpawner")
	if spawner:
		# On donne les quantités de la ressourceau  spawner
		spawner.update_quantities_from_data(current_level_data)
