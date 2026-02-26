extends CanvasLayer

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var rect : ColorRect = $ColorRect

func _ready() -> void:
	rect.modulate = Color(0, 0, 0, 0)
	layer = 100

func change_scene(path: String) -> void:
	anim.play("fade_out")
	await anim.animation_finished
	get_tree().change_scene_to_file(path)
	await anim.animation_finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	anim.play("fade_in")

func fade_in_only() -> void:
	rect.modulate = Color(0, 0, 0, 1)
	anim.play("fade_in")
	
