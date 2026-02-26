extends CanvasLayer

var rect : ColorRect
var anim_player : AnimationPlayer

func _ready() -> void:
	layer = 100
	rect = ColorRect.new()
	rect.color = Color(0, 0, 0, 1)
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.visible = false
	add_child(rect)
	anim_player = AnimationPlayer.new()
	add_child(anim_player)
	_create_animations()

func _create_animations() -> void:
	var lib = AnimationLibrary.new()
	var fade_out = Animation.new()
	fade_out.length = 0.4
	var track = fade_out.add_track(Animation.TYPE_VALUE)
	fade_out.track_set_path(track, NodePath("../ColorRect:color"))
	fade_out.track_insert_key(track, 0.0, Color(0, 0, 0, 0))
	fade_out.track_insert_key(track, 0.4, Color(0, 0, 0, 1))
	lib.add_animation("fade_out", fade_out)
	var fade_in = Animation.new()
	fade_in.length = 0.4
	var track2 = fade_in.add_track(Animation.TYPE_VALUE)
	fade_in.track_set_path(track2, NodePath("../ColorRect:color"))
	fade_in.track_insert_key(track2, 0.0, Color(0, 0, 0, 1))
	fade_in.track_insert_key(track2, 0.4, Color(0, 0, 0, 0))
	lib.add_animation("fade_in", fade_in)
	anim_player.add_animation_library("", lib)

func change_scene(path: String) -> void:
	rect.visible = true
	anim_player.play("fade_out")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	anim_player.play("fade_in")
	await anim_player.animation_finished
	rect.visible = false

func fade_in_only() -> void:
	rect.visible = true
	rect.color = Color(0, 0, 0, 1)
	anim_player.play("fade_in")
	await anim_player.animation_finished
	rect.visible = false
