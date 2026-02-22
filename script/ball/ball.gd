extends RigidBody2D
class_name Ball

@onready var sprite : Sprite2D = $Sprite2D

# Physique
@export var bounce_force : float = 800.0
@export var gravity_scale_value : float = 2.5  # lourdeur
@export var squash_amount : float = 0.4
@export var stretch_amount : float = 0.3

var previous_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	gravity_scale = gravity_scale_value
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.4  # rebond modéré
	physics_material_override.friction = 0.8

func _physics_process(_delta: float) -> void:
	if GameManager.current_state != GameManager.GameState.PLAYING:
		linear_velocity = Vector2.ZERO
		return
	apply_squash_stretch()
	previous_velocity = linear_velocity

# Appliquer une force sur la balle
func apply_force_to_ball(direction: Vector2, force: float) -> void:
	apply_central_impulse(direction.normalized() * force)

# Squash et stretch selon la vitesse
func apply_squash_stretch() -> void:
	var speed = linear_velocity.length()
	
	if speed < 10:
		# Au repos, forme normale
		sprite.scale = sprite.scale.lerp(Vector2.ONE, 0.2)
		return
	
	# Stretch dans la direction du mouvement
	var stretch = 1.0 + (speed / bounce_force) * stretch_amount
	var squash = 1.0 / stretch  # conservation du volume
	
	var angle = linear_velocity.angle()
	sprite.rotation = angle
	sprite.scale = sprite.scale.lerp(Vector2(squash, stretch), 0.3)

# Squash à l'impact
func _on_body_entered(_body: Node) -> void:
	var impact_strength = previous_velocity.length() / bounce_force
	var squash = 1.0 + impact_strength * squash_amount
	sprite.scale = Vector2(squash, 1.0 / squash)
