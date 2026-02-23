extends Area2D
class_name  HitboxComponent

@export var attack_data : AttackData 
@export var shape : CollisionShape2D
@export var team := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_attack()


func lunch_attack() : #activer la collision
	if shape :
		shape.set_deferred("disabled", false)


func end_attack(): #désactiver la collision 
	if shape :
		shape.set_deferred("disabled",true)
		attack_data = null

func _on_area_entered(area: HurtboxComponent) -> void:
	if attack_data:
		area.take_hit(attack_data)
