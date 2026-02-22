extends Node
class_name HealthComponent

@export var max_health : float = 100
var health : float = 100

signal died


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_health()



func deplete_health(amount : float ) : 
	health -= amount
	if health <= 0 : 
		emit_signal("died")

func reset_health():
	health = max_health
