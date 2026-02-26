extends Resource
class_name LevelData

@export var level_name: String = "Niveau 1"
@export var map_scene: PackedScene # La scène de ta carte

# On réutilise ton système d'enum ici
@export var enemy_counts: Dictionary = {
	# On force les clés avec l'enum de  l'ennemi
	 }

@export_group("Ennemis")
@export var batteur_count: int = 1
@export var boxeur_count: int = 0
@export var canon_count: int = 0
