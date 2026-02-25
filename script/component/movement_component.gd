extends Node
class_name MovementComponement

@export var body : CharacterBody2D
@export var max_speed :=300
@export var acceleration := 2000
@export var max_gravity := 2000
@export var decceleration := 300
@export var air_decceleration := 100
@export var air_acceleration := 1900
@export var jump_height := -1000
@export var gravity := 850
var last_direction := 1.0
@export var direction := 1.0
var past_direction = direction

#knock_back
var knockback := Vector2.ZERO
var knock_timer := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if direction != 0 :
		last_direction = direction

func slide(delta : float) : 
	
	var velocity_weight: float = delta * (acceleration if direction  else decceleration) 
	body.velocity.x = move_toward(body.velocity.x, direction * max_speed , velocity_weight)
	#body.move_and_slide()

func air_slide(delta : float) :
	var velocity_weight: float = delta * (air_acceleration if direction  else air_decceleration) 
	body.velocity.x = move_toward(body.velocity.x, direction * max_speed * 1.2 , velocity_weight)
	#body.move_and_slide()




#sauts
func jump():
	body.velocity.y = jump_height



func apply_gravity(delta: float , gravity_multiplier := 1.0): 
	body.velocity.y = move_toward(body.velocity.y, gravity *gravity_multiplier, max_gravity * delta * gravity_multiplier)


func deccelerate(delta : float ):
	body.velocity.x = move_toward(body.velocity.x, 0 , decceleration * delta )

func dash():
	body.velocity.x = 400 * last_direction

func apply_knockback(direction : Vector2, force : float, duration : float = 0.2 ):
	force = clamp(force, 500 , 800)
	knockback = direction * force
	knock_timer= duration

func actif_knockback(delta : float) :
	if knock_timer > 0 :
		body.velocity = knockback
		knock_timer -= delta
	if knock_timer <= 0 :
		#body.velocity =Vector2.ZERO
		pass
