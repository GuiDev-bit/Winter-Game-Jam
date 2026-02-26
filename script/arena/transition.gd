extends CanvasLayer

var rect : ColorRect

func _ready() -> void:
	layer = 100
	rect = ColorRect.new()
	rect.color = Color(0, 0, 0, 1)
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.visible = false
	add_child(rect)

func change_scene(path: String) -> void:
	rect.visible = true
	var t = create_tween()
	t.tween_property(rect, "color", Color(0,0,0,1), 0.4)
	await t.finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	var t2 = create_tween()
	t2.tween_property(rect, "color", Color(0,0,0,0), 0.4)
	await t2.finished
	rect.visible = false

func fade_in_only() -> void:
	rect.visible = true
	rect.color = Color(0, 0, 0, 1)
	var t = create_tween()
	t.tween_property(rect, "color", Color(0,0,0,0), 0.4)
	await t.finished
	rect.visible = false
