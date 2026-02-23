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
