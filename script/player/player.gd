extends CharacterBody2D
@onready var  move_component : MovementComponement=$MovementComponent
@onready var  input_component : Inputcomponent =$InputComponent


func _physics_process(delta) -> void :
	move_component.direction = input_component.x_input #assigner la directiomn au mouvement compp
	move_component.slide(delta)
	if not  is_on_floor() : 
		move_component.apply_gravity(delta)

	move_and_slide()
#Je vais tout refaire en state machine

func active_game():  #j'ai séparé ca du joueur
	if GameManager.current_state != GameManager.GameState.PLAYING:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
