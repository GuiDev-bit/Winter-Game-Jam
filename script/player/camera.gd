extends Camera2D

var shake_strength := 0.0
var shake_duration := 0.0
var is_end_chaos := false

func _process(delta: float) -> void:
	if is_end_chaos:
		return
	if shake_duration > 0:
		shake_duration -= delta
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		shake_strength = 0.0
		offset = Vector2.ZERO

func shake(strength: float, duration: float) -> void:
	shake_strength = strength
	shake_duration = duration

func end_game_chaos() -> void:
	is_end_chaos = true
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Zoom vers le joueur
	tween.tween_property(self, "zoom", Vector2(2.5, 2.5), 1.5)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_EXPO)
	
	# Tremble de plus en plus fort
	tween.tween_method(_apply_chaos_shake, 5.0, 25.0, 1.5)
	
	await tween.finished
	
	# Transition vers le menu de fin
	await get_tree().create_timer(0.5).timeout
	zoom = Vector2(1, 1)
	offset = Vector2.ZERO
	is_end_chaos = false

func _apply_chaos_shake(strength: float) -> void:
	offset = Vector2(
		randf_range(-strength, strength),
		randf_range(-strength, strength)
	)
