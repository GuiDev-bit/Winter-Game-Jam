extends Node2D
class_name SkittleGroup

enum Team { LEFT, RIGHT }
@export var team : Team = Team.LEFT
@export var skittle_scene : PackedScene

var initial_transforms : Array = []

func _ready() -> void:
	for child in get_children():
		if child is Skittle:
			initial_transforms.append({
				"pos": child.position,
				"rot": child.rotation
			})
			child.team = team
	GameManager.goal_scored.connect(_on_goal_scored)

func _on_goal_scored(_team: String) -> void:
	await get_tree().create_timer(1.0).timeout
	reset_skittles()

func reset_skittles() -> void:
	for child in get_children():
		if child is Skittle:
			child.queue_free()
	await get_tree().process_frame
	for i in range(initial_transforms.size()):
		var skittle = skittle_scene.instantiate()
		skittle.position = initial_transforms[i]["pos"]
		skittle.rotation = initial_transforms[i]["rot"]
		skittle.team = team
		add_child(skittle)
