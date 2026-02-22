extends RigidBody2D
class_name Ball

@onready var sprite : Sprite2D = $Sprite2D

# Physique
@export var bounce_force : float = 800.0
@export var gravity_scale_value : float = 2.5
@export var squash_amount : float = 0.4
@export var stretch_amount : float = 0.3

var previous_velocity : Vector2 = Vector2.ZERO
var base_scale : Vector2 = Vector2(0.25, 0.25)

func _ready() -> void:
	gravity_scale = gravity_scale_value

func _physics_process(_delta: float) -> void:
	if GameManager.current_state != GameManager.GameState.PLAYING:
		linear_velocity = Vector2.ZERO
		return
	apply_squash_stretch()
	previous_velocity = linear_velocity

func apply_force_to_ball(direction: Vector2, force: float) -> void:
	apply_central_impulse(direction.normalized() * force)

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
	print("collision avec: ", _body.name)
	var impact_strength = previous_velocity.length() / bounce_force
	var squash = 1.0 + impact_strength * squash_amount
	sprite.scale = Vector2(base_scale.x * squash, base_scale.y / squash)
