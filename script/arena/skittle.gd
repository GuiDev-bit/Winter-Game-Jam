extends RigidBody2D
class_name Skittle

enum Team { LEFT, RIGHT }
@export var team : Team = Team.LEFT

@onready var health : HealthComponent = $HealthComponent

var knocked := false

func _ready() -> void:
	health.died.connect(_on_died)
	contact_monitor = true
	max_contacts_reported = 4

func _on_body_entered(body: Node) -> void:
	if body is Ball:
		var speed = body.linear_velocity.length()
		if speed > 300:
			knocked = true
			var direction = body.linear_velocity.normalized()
			apply_impulse(direction * speed * 0.3)
			apply_torque_impulse(randf_range(-500, 500))
			health.deplete_health(100)

func _on_died() -> void:
	if team == Team.LEFT:
		GameManager.add_goal("right")
	else:
		GameManager.add_goal("left")
	queue_free()
