extends CharacterBody2D
class_name Player

@onready var  move_component : MovementComponement=$MovementComponent
@onready var  input_component : Inputcomponent =$InputComponent

#states
enum STATE { FALL, FLOOR,JUMP, HURT, }

var active_state :STATE = STATE.FALL  

func _ready() -> void:
	switch_state(active_state)
	GameManager.player_respawn.connect(_on_respawn)

func _on_respawn(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	switch_state(STATE.FALL)

func _physics_process(delta) -> void :
	move_component.direction = input_component.x_input #assigner la directiomn au mouvement comp
	process_state(delta)
	move_and_slide()


func active_game():  #check if game is active 
	if GameManager.current_state != GameManager.GameState.PLAYING:
		velocity = Vector2.ZERO
		move_and_slide()
		return

#state Transition
func switch_state(to_state : STATE) :
	active_state = to_state

	#State specific thing that will run once when entering the state
	match  active_state :
		STATE.FALL :
			pass
		STATE.JUMP :
			move_component.jump()
			if input_component.x_input != 0:
				velocity.x = 500 * input_component.x_input


func process_state(delta: float) ->void : #handle state-logique
	match active_state :
		STATE.FALL :
			move_component.apply_gravity(delta, 1.3)
			move_component.air_slide(delta)
			if is_on_floor() :
				switch_state(STATE.FLOOR)

		STATE.FLOOR:
			if not is_on_floor() :
				switch_state(STATE.FALL)
			move_component.slide(delta)
			if input_component.jump_press :
				switch_state(STATE.JUMP)



		STATE.JUMP :
			move_component.apply_gravity(delta)
			move_component.slide(delta)
			if velocity.y >=   0 : 
				switch_state(STATE.FALL)
