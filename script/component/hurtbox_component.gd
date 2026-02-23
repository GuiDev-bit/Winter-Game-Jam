extends Area2D
class_name HurtboxComponent

#@export var ball : Ball
#@export var body : CharacterBody2D

@export var health_comp : HealthComponent

signal get_hit(data)


func damage(data : AttackData) :
	if health_comp :
		health_comp.deplete_health(data.damage)
	emit_signal("get_hit", data)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent and area.get_parent() is Ball:
		area.get_parent().set_player_nearby(false)
		area.get_parent().is_aiming = false
		area.get_parent().aim_direction = Vector2.ZERO
		get_parent().ball_ref = null
