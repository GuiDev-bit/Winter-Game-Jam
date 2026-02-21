extends Node
class_name MovementComponement

@export var body : CharacterBody2D
@export var max_speed :=100
@export var acceleration :=  10
@export var max_gravity := 1000
@export var friction := 2
@export var jump_height := -200
@export var gravity := 900
@export var direction := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func slide(delta : float) : 
	var velocity_weight: float =  delta * (acceleration if direction  else friction) 
	body.velocity.x = lerp(body.velocity.x, direction * max_speed, velocity_weight)
	body.move_and_slide()


func jump():
	body.velocity.y = jump_height



func apply_knockback():
	pass

func apply_gravity(delta: float , gravity_multiplier := 1.0): 
	body.velocity.y += gravity * delta
	if body.velocity.y > max_gravity : 
		body.velocity.y = max_gravity * gravity_multiplier
	else :
		body.velocity.y += gravity * delta * gravity_multiplier
	
	
