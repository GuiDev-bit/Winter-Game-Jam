extends Area2D
class_name HitboxComponent

@export var attack_data : AttackData 
@export var shape : CollisionShape2D
@export var team := 0

func _ready() -> void:
	end_attack()

func lunch_attack():
	if shape:
		shape.set_deferred("disabled", false)

func end_attack():
	if shape:
		shape.set_deferred("disabled", true)
		attack_data = null

func _on_area_entered(area: Area2D) -> void:
	if attack_data and area is HurtboxComponent:
		area.damage(attack_data)
	if area is HurtboxComponent and area.get_parent() is Ball:
		area.get_parent().set_player_nearby(true)
		get_parent().ball_ref = area.get_parent()

func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent and area.get_parent() is Ball:
		area.get_parent().set_player_nearby(false)
		get_parent().ball_ref = null
