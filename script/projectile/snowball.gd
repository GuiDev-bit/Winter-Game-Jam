extends RigidBody2D
class_name Snow

var force := 2000
@onready var hitbox = $HitboxComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("je suis la")


# Called every frame. 'delta' is the elapsed time since the previous frame.


func lunch_ball(  direction : Vector2):
	apply_impulse(direction * force)



func _on_timer_timeout() -> void:
	queue_free()
