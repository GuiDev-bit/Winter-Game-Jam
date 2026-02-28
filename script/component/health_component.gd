extends Node
class_name HealthComponent

@export var max_health : float = 100
var health : float = 100

signal died
signal health_changed(new_health: float)

func _ready() -> void:
	reset_health()

func deplete_health(amount: float) -> void:
	health -= amount
	health = max(health, 0)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("died")

func reset_health() -> void:
	health = max_health
	emit_signal("health_changed", health)
