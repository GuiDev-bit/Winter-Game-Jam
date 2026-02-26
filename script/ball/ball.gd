extends RigidBody2D
class_name Ball

@onready var sprite : Sprite2D = $Sprite2D
@onready var hurtbox : HurtboxComponent = $HurtboxComponent 


# Physique
@export var bounce_force : float = 800.0
@export var gravity_scale_value : float = 1.20
@export var squash_amount : float = 0.4
@export var stretch_amount : float = 0.3

@export var air_drag := 700
@export var max_strength := 2000.0   # puissance max horizontal
@export var min_strength := 1200.0    # puissance min vertical


var previous_velocity : Vector2 = Vector2.ZERO
var base_scale : Vector2 = Vector2(0.25, 0.25)
var aim_direction : Vector2 = Vector2.ZERO
var player_nearby : bool = false
var is_aiming : bool = false
var aiming_cooldown : float = 0.0





func _ready() -> void:
	gravity_scale = gravity_scale_value
	AiManager.get_ball_reference(self)

func _physics_process(delta: float) -> void:
	#active_game
	#apply_squash_stretch()
	#update_aim(delta)
	
	#friction horizontale
	apply_horizontal_drag(delta)
	gravity_update()
	#save the prev velocity
	previous_velocity = linear_velocity




func apply_force_to_ball(direction: Vector2, force: float) -> void:
	var dir := direction.normalized()
	
	# --- puissance adaptative selon l’angle vertical ---
	var vertical_factor = abs(dir.y)  # 0 = horizontal, 1 = vertical
	var adjusted_force = lerp(force, force * 0.55, vertical_factor)
	
	stop_ball_movement()
	physics_material_override.bounce = 1.0
	apply_impulse(dir * adjusted_force)
	
	
func apply_squash_stretch() -> void:
	var speed = linear_velocity.length()
	if speed < 10:
		sprite.scale = sprite.scale.lerp(base_scale, 0.2)
		return
	var stretch = 1.0 + (speed / bounce_force) * stretch_amount
	var squash = 1.0 / stretch
	var angle = linear_velocity.angle()
	sprite.rotation = angle
	sprite.scale = sprite.scale.lerp(Vector2(base_scale.x * squash, base_scale.y * stretch), 0.3)

func _on_body_entered(_body: Node) -> void:
	#print("collision avec: ", _body.name)
	var impact_strength = previous_velocity.length() / bounce_force
	var squash = 1.0 + impact_strength * squash_amount
	#sprite.scale = Vector2(base_scale.x * squash, base_scale.y / squash)


@warning_ignore("unused_parameter")
func _on_ball_get_hit(data: AttackData) -> void:
	apply_force_to_ball(data.direction, data.force)
	#print(data.force)


func set_player_nearby(value: bool) -> void:
	player_nearby = value


func active_game():
	if GameManager.current_state != GameManager.GameState.PLAYING:
		linear_velocity = Vector2.ZERO
		return


func update_aim(delta : float):
	if is_aiming:
		aiming_cooldown = 0.5  # reset le timer tant qu'on vise
	else:
		aiming_cooldown -= delta
	if player_nearby or aiming_cooldown > 0:
		if Input.is_action_pressed("attack_r"):
			is_aiming = true
			var mouse_pos = get_global_mouse_position()
			aim_direction = (mouse_pos - global_position).normalized()
		elif is_aiming and Input.is_action_just_released("attack_r"):
			is_aiming = false
			if aim_direction != Vector2.ZERO:
				apply_force_to_ball(aim_direction, bounce_force)
	else:
		is_aiming = false


func gravity_update():
	if linear_velocity.y > 0 :
		gravity_scale = 2.35
	else :
		gravity_scale = gravity_scale_value

func apply_horizontal_drag(_delta: float) -> void:
	var vx = linear_velocity.x
	if abs(vx) < 5.0:
		physics_material_override.bounce =  0.45
		return  # vitesse trop faible, pas besoin de friction
	var drag = -sign(vx) * air_drag # 600 = force de friction, ajuste selon le feeling
	apply_central_force(Vector2(drag, 0.0))


func stop_ball_movement() -> void:
	# Annule toute vélocité actuelle
	linear_velocity = Vector2.ZERO

	# Réinitialise previous_velocity pour squash/stretch
	previous_velocity = Vector2.ZERO
