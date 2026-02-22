extends Area2D
class_name  HitboxComponent

@export var attack_data : AttackData 
@export var shape : CollisionObject2D 
@export var team := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func lunch_attack() : #activer la collision
	pass


func end_attack(): #désactiver la collision 
	pass


func _on_area_entered(area: HurtboxComponent) -> void:
	if attack_data:
		area.take_hit(attack_data)
