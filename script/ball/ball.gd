extends CharacterBody2D

@export var speed : float = 400.0
var direction : Vector2 = Vector2.RIGHT

func _physics_process(delta):
	if GameManager.current_state != GameManager.GameState.PLAYING:
		return

	velocity = direction * speed
	move_and_slide()
