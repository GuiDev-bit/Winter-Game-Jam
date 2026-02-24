extends CharacterBody2D
class_name Player

@onready var  move_component : MovementComponement=$MovementComponent
@onready var  input_component : Inputcomponent =$InputComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var aim_line : Line2D = $AimLine
@onready var crosshair : Sprite2D = $Crosshair



#the weapons
enum Weapon {GlOVES, CANON}
@export var use_secondweap := false
@export var secondary_weapon : Weapon 
var is_bat_charging := false #dsl d'avoir nommé ca de facon random, en gros c pour savoir si le joueur charge l'attaque ou pass
var charge_attack_bat := 1.0


var attack_timer := 0.3
var attack_time := 0.3
@export var bat_data : AttackData
@export var gloves_data : AttackData
@export var snow_canon_data : AttackData

#states
enum STATE { FALL, FLOOR,JUMP, HURT, HIT }

var active_state :STATE = STATE.FALL  
var prev_velocity_x := 0.0

#about animations
var slide_anim:= ["slide_a", "slide_b","slide_c"]
var current_slide:= ""

var dir := Vector2(1,0)


var ball_ref : Ball = null


func _ready() -> void:
	add_to_group("player")
	switch_state(active_state)
	GameManager.player_respawn.connect(_on_respawn)
	aim_line.visible = false
	crosshair.visible = false

func _on_respawn(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	switch_state(STATE.FALL)

func _physics_process(delta) -> void :
	move_component.direction = input_component.x_input #assigner la directiomn au mouvement comp
	process_state(delta)
	update_animation()
	#update_aim()


	prev_velocity_x = lerp(prev_velocity_x, velocity.x, 6.7 * delta)
	move_and_slide()

func update_aim() -> void:
	if not aim_line or not crosshair:
		return
	if ball_ref and ball_ref.player_nearby and Input.is_action_pressed("attack_r"):
		var mouse_pos = get_global_mouse_position()
		var aim_dir = (mouse_pos - global_position).normalized()
		var angle = (mouse_pos - global_position).angle()
		crosshair.global_position = global_position + aim_dir * 80
		crosshair.rotation = angle
		crosshair.visible = true
		calculate_trajectory(aim_dir)
		aim_line.visible = true
	else:
		aim_line.visible = false
		crosshair.visible = false


func calculate_trajectory(aim_dir: Vector2) -> void:
	var points : Array = [Vector2.ZERO]
	var sim_pos : Vector2 = global_position
	var sim_dir : Vector2 = aim_dir
	var space_state = get_world_2d().direct_space_state
	for i in range(5):
		var query = PhysicsRayQueryParameters2D.create(sim_pos, sim_pos + sim_dir * 500)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result and result.normal.length() > 0:
			points.append(to_local(result.position))
			sim_pos = result.position + result.normal * 2
			sim_dir = sim_dir.bounce(result.normal)
		else:
			points.append(to_local(sim_pos + sim_dir * 500))
			break
	aim_line.points = points


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
			_on_enter_hit_state()


func process_state(delta: float) ->void : #handle state-logique
	match active_state :
		STATE.FALL :
			move_component.apply_gravity(delta, 1.3)
			move_component.air_slide(delta)
			if is_on_floor() :
				switch_state(STATE.FLOOR)
			else :
				attack_state_transition()

		STATE.FLOOR:
			if not is_on_floor() :
				switch_state(STATE.FALL)
			move_component.slide(delta)
			if input_component.jump_press :
				switch_state(STATE.JUMP)
			else :
				attack_state_transition()

		STATE.JUMP :
			move_component.apply_gravity(delta)
			move_component.slide(delta)
			if velocity.y >=   0 : 
				switch_state(STATE.FALL)
			else :
				attack_state_transition()

		STATE.HIT :
			if input_component.charged_bat :
				_attack_with_bat()
			bat_power_scale(delta)
			check_attack_timer(delta)
			handle_air_physics(delta)




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
	check_direction()

#choisi une animation différente pour le slide
func pick_random_slide():
	var choices = slide_anim.duplicate()
	choices.erase(current_slide)
	current_slide = choices.pick_random()

func get_direction_to_mouse() -> Vector2:
	var mouse_pos = get_global_mouse_position() # position de la souris dans le monde
	var direction = (mouse_pos - global_position).normalized()
	return direction

func check_attack_timer(delta) : #gère la durée de l'attaque
	if is_bat_charging == false : #regarde si il charge pas l'attauqe
			if attack_timer > 0 :
				attack_timer -= delta * 1
			else : 
				hitbox.end_attack()
				attack_timer = attack_time
				switch_state(STATE.FLOOR)

func attack_state_transition(): #les conditions généralent pur switch vers attaque
			if Input.is_action_just_pressed("attack_l") :
				switch_state(STATE.HIT)
				use_secondweap = false
			elif  Input.is_action_just_pressed("attack_r") :
				use_secondweap = true
				switch_state(STATE.HIT)

func check_direction():
	if move_component.direction > 0:
		dir = Vector2(1,0)
		animated_sprite.flip_h = false
		hitbox.shape.position.x = 52
	elif move_component.direction < 0:
		animated_sprite.flip_h = true
		dir = Vector2(-1,0)
		hitbox.shape.position.x = -52

func _on_enter_hit_state():
	is_bat_charging = true
	if not use_secondweap:
		return
	_launch_secondary_weapon()

func _launch_secondary_weapon():
	match secondary_weapon :
		Weapon.GlOVES :
			_attack_with_gloves()
		Weapon.CANON :
			_attack_with_canon()

func _attack_with_gloves():
	gloves_data.direction = dir
	hitbox.attack_data = gloves_data
	hitbox.lunch_attack()
	is_bat_charging = false

func _attack_with_canon():
	# TODO: projectile
	is_bat_charging = false

func _attack_with_bat():
		bat_data.direction = get_direction_to_mouse()
		hitbox.attack_data = bat_data
		hitbox.attack_data.force = 2500* charge_attack_bat
		hitbox.lunch_attack()
		#print(hitbox.attack_data.damage )
		attack_timer = attack_time
		is_bat_charging = false
		charge_attack_bat = 0.6

func bat_power_scale(delta :float) :
	if is_bat_charging :
		charge_attack_bat = clamp(charge_attack_bat,0.6 , 1.0)
		charge_attack_bat = move_toward(charge_attack_bat, 1.0, delta / 1.5 )




func handle_air_physics(delta :float): #gère les déplacement lors d'une attaque
	if  is_on_floor() :
		if is_bat_charging : 
			move_component.deccelerate(delta)
		else : 
			move_component.dash()
	else :
		if velocity.y >=   0 :
			move_component.apply_gravity(delta, 1.3)
			move_component.air_slide(delta)
		else : 
			move_component.apply_gravity(delta)
			move_component.air_slide(delta)
