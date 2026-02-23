extends CharacterBody2D
class_name Player

@onready var  move_component : MovementComponement=$MovementComponent
@onready var  input_component : Inputcomponent =$InputComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : HitboxComponent = $HitboxComponent



#the weapons
enum Weapon { BAT, GlOVES, CANON}
@export var current_weapon : Weapon =  Weapon.BAT
var attack_timer := 0.3
var attack_time := 0.3
@export var bat_data : AttackData

#states
enum STATE { FALL, FLOOR,JUMP, HURT, HIT }

var active_state :STATE = STATE.FALL  
var prev_velocity_x := 0.0

#about animations
var slide_anim:= ["slide_a", "slide_b","slide_c"]
var current_slide:= ""


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
	update_animation()


	prev_velocity_x = lerp(prev_velocity_x, velocity.x, 6.7 * delta)
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
		STATE.FLOOR :
			pick_random_slide()
		STATE.HIT :
			bat_data.direction = get_direction_to_mouse()
			hitbox.attack_data = bat_data
			hitbox.lunch_attack()


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
			elif Input.is_action_just_pressed("attack_r") :
				switch_state(STATE.HIT)

		STATE.JUMP :
			move_component.apply_gravity(delta)
			move_component.slide(delta)
			if velocity.y >=   0 : 
				switch_state(STATE.FALL)

		STATE.HIT :
			if attack_timer > 0 :
				attack_timer -= delta * 1
			else : 
				hitbox.end_attack()
				attack_timer = attack_time
				switch_state(STATE.FLOOR)

#Update the  animations 

func update_animation() -> void:
	#print("direction: ", move_component.direction)
	#print("state: ", active_state)

	match active_state:
		STATE.FLOOR:
			if velocity.x != 0: #i use velocity to know when he is  moving
				if move_component.direction == 0 : #je check quand il dérape
					animated_sprite.play("friction")
				elif  move_component.direction * velocity.x  < 0 :
					#animated_sprite.play("slide_transition") 
					pick_random_slide()
				else :
					animated_sprite.play(current_slide)
			else:
				animated_sprite.play("idle")
		STATE.JUMP:
			animated_sprite.play("jump")
		STATE.FALL:
			animated_sprite.play("fall")
		STATE.HURT:
			animated_sprite.play("idle")
	if move_component.direction > 0:
		animated_sprite.flip_h = false
		hitbox.shape.position.x = 52
	elif move_component.direction < 0:
		animated_sprite.flip_h = true
		hitbox.shape.position.x = -52

#choisi une animation différente pour le slide
func pick_random_slide():
	var choices = slide_anim.duplicate()
	choices.erase(current_slide)
	current_slide = choices.pick_random()

func get_direction_to_mouse() -> Vector2:
	var mouse_pos = get_global_mouse_position() # position de la souris dans le monde
	var direction = (mouse_pos - global_position).normalized()
	return direction
