extends Area2D
class_name HurtboxComponent

var health_comp : HealthComponent
enum Team {RED, BLUE, OTHER}
@export var team : Team
signal get_hit(data)

func _ready() -> void:
	health_comp = get_parent().get_node_or_null("HealthComponent")

func damage(data : AttackData) -> void:
	if health_comp:
		health_comp.deplete_health(data.damage)
	emit_signal("get_hit", data)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent and area.get_parent() is Ball:
		area.get_parent().set_player_nearby(false)
		area.get_parent().is_aiming = false
		area.get_parent().aim_direction = Vector2.ZERO
		get_parent().ball_ref = null
