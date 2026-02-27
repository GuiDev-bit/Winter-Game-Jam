extends Resource
class_name LevelData


@export var level_name: String = "Niveau 1"
@export var level_description: String = "Un niveau ensoleillé !"
@export var map_scene: PackedScene
@export_group("Tempête")
@export var max_storm_level : int = 1  # 0 = SUN seulement, 1 = peut aller à STORM, 2 = peut aller à EXTREME
@export_group("Ennemis")
@export var batteur_count: int = 1
@export var boxeur_count: int = 0
@export var canon_count: int = 0
