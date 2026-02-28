extends CharacterBody2D
class_name Player

@onready var  move_component : MovementComponement=$MovementComponent
@onready var  input_component : Inputcomponent =$InputComponent
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var crosshair : Sprite2D 
@onready var crossair : Node2D = $Crossair
@onready var camera : Camera2D = $Camera2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var health := $HealthComponent

var munition_max = 5
var current_munition = 0

#the weapons
enum Weapon {GlOVES, CANON}
@export var use_secondweap := false
@export var secondary_weapon : Weapon 
var is_bat_charging := false #dsl d'avoir nommé ca de facon random, en gros c pour savoir si le joueur charge l'attaque ou pass
var charge_attack_bat := 1.0

@onready var snow_ball_scene := preload("res://scenes/Hitbox and Hurtbox/snowball.tscn")

var atk_cooldown := 5.0
var atk_cooldown_timer := 0.0

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

signal i_died

var ball_ref : Ball = null


func _ready() -> void:
	add_to_group("player")
	switch_state(active_state)
	AiManager.get_player_reference(self)
	current_munition = munition_max
	$HealthComponent.died.connect(_on_died)
	if GameManager.selected_weapon == "canon":
		secondary_weapon = Weapon.CANON
	else:
		secondary_weapon = Weapon.GlOVES

func _on_respawn(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	switch_state(STATE.FALL)

func _physics_process(delta) -> void :
	active_atk_cooldown(delta)
	move_component.direction = input_component.x_input #assigner la directiomn au mouvement comp
	process_state(delta)
	update_animation()
	update_crossair()
	update_aim()



	prev_velocity_x = lerp(prev_velocity_x, velocity.x, 6.7 * delta)
	move_and_slide()

func update_aim() -> void:
	if not  crosshair:
		return
	if ball_ref and ball_ref.player_nearby and Input.is_action_pressed("attack_r"):
		var mouse_pos = get_global_mouse_position()
		var aim_dir = (mouse_pos - global_position).normalized()
		var angle = (mouse_pos - global_position).angle()
		crosshair.global_position = global_position + aim_dir * 80
		crosshair.rotation = angle
		crosshair.visible = true
		calculate_trajectory(aim_dir)


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


func active_game():  #check if game is active 
	if GameManager.current_state != GameManager.GameState.PLAYING:
		velocity = Vector2.ZERO
		move_and_slide()
		return

#state Transition
func switch_state(to_state : STATE) :
	if to_state == STATE.HIT :
		if atk_cooldown_timer == 1000 :
			return
	active_state = to_state

	#State specific thing that will run once when entering the state
	match  active_state :
		STATE.FALL :
			pass
		STATE.JUMP :
			move_component.jump()
			anim.play("Entity/scretch")
			ParticleManager.jump_puff(global_position + Vector2(0, 30))
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
				anim.play("Entity/sqash")
				ParticleManager.jump_puff(global_position + Vector2(0, 30))
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
			if input_component.charged_bat and is_bat_charging :
				_attack_with_bat()
			bat_power_scale(delta)
			check_attack_timer(delta)
			handle_air_physics(delta)

		STATE.HURT :
			move_component.actif_knockback(delta)
			move_component.deccelerate(delta)
			move_component.apply_gravity(delta)
			if move_component.knock_timer <= 0:
				switch_state(STATE.FALL)



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
					
					pick_random_slide()
				else :
					ParticleManager.slide_dust(global_position + Vector2(0, 50))
					animated_sprite.play(current_slide)
					anim.play("Entity/Slide")
			else:
				animated_sprite.play("idle")
		STATE.JUMP:
			animated_sprite.play("jump")
		STATE.FALL:
			animated_sprite.play("fall")
		STATE.HURT:
			animated_sprite.play("hurt")
		STATE.HIT :
			if is_bat_charging :
				if is_on_floor() :
					animated_sprite.play("hit_charge_bat")
				else :
					animated_sprite.play("hit_charge_air")
			else:
				if use_secondweap :
					play_correct_atk_anim()
				elif is_on_floor() :
					animated_sprite.play("hit_bat")

				else :
					animated_sprite.play("hit_bat_air")
	check_direction()

#choisi une animation différente pour le slide
func pick_random_slide():
	var choices = slide_anim.duplicate()
	choices.erase(current_slide)
	current_slide = choices.pick_random()

func get_direction_to_mouse() -> Vector2:
	var mouse_pos = get_global_mouse_position() # position de la souris dans le monde
	var direction = (mouse_pos - global_position).normalized()
	if dir.x > 0 :
		direction.x = abs(direction.x)
	elif dir.x < 0 :
		direction.x = -1 * abs(direction.x)
	return direction

func check_attack_timer(delta) : #gère la durée de l'attaque
	if is_bat_charging == false : #regarde si il charge pas l'attauqe
			if attack_timer > 0 :
				attack_timer -= delta * 1
			else : 
				hitbox.end_attack()
				attack_timer = attack_time
				switch_state(STATE.FLOOR)
				atk_cooldown_timer = atk_cooldown
				use_secondweap = false


func attack_state_transition(): #les conditions généralent pur switch vers attaque
		if  (atk_cooldown_timer < 0 ) == false:
			if Input.is_action_just_pressed("attack_l") :
				switch_state(STATE.HIT)
				use_secondweap = false
				return
			elif  Input.is_action_just_pressed("attack_r") :
				use_secondweap = true
				switch_state(STATE.HIT)
				return
		else : 
			return 

func check_direction():
	if move_component.direction > 0:
		dir = Vector2(1,0)
		animated_sprite.flip_h = false
		hitbox.shape.position.x = 44.5
	elif move_component.direction < 0:
		animated_sprite.flip_h = true
		dir = Vector2(-1,0)
		hitbox.shape.position.x = -44.5

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
	atk_cooldown_timer = atk_cooldown

func _attack_with_canon():
	if current_munition > 0 :
		var snow : Snow = snow_ball_scene.instantiate()
		get_tree().current_scene.add_child(snow)
		snow.global_position = global_position
		snow.hitbox.team = hitbox.team
		snow.lunch_ball(get_direction_to_mouse())
		current_munition -= 1
	is_bat_charging = false

func _attack_with_bat():
		hitstop()
		ParticleManager.charge_release(global_position)
		bat_data.direction = get_direction_to_mouse()
		hitbox.attack_data = bat_data
		hitbox.attack_data.force = 2400* charge_attack_bat
		hitbox.lunch_attack()
		#print(hitbox.attack_data.damage )
		attack_timer = attack_time
		is_bat_charging = false
		AudioManager.play_bat_hit()

		charge_attack_bat = 0.6

func bat_power_scale(delta :float) :
	if is_bat_charging :
		charge_attack_bat = clamp(charge_attack_bat,0.6 , 1.0)
		charge_attack_bat = move_toward(charge_attack_bat, 1.0, delta / 1.5 )



func update_crossair():
	#var mouse_pos = get_global_mouse_position() # position de la souris dans le monde
	#var direction = (mouse_pos - global_position).normalized()
	crossair.rotation =get_direction_to_mouse().angle()

func active_atk_cooldown(delta : float):
	if atk_cooldown_timer > 0:
		atk_cooldown_timer -= delta
	else :
		atk_cooldown_timer = 0


func handle_air_physics(delta :float): #gère les déplacement lors d'une attaque
	if  is_on_floor() :
		if is_bat_charging : 
			move_component.deccelerate(delta)
		else : 
			if use_secondweap and secondary_weapon == Weapon.CANON :
				move_component.dash(-1.0)
			else :
				move_component.dash()
	else :
		if velocity.y >=   0 :
			move_component.apply_gravity(delta, 1.3)
			move_component.air_slide(delta)
		else : 
			move_component.apply_gravity(delta)
			move_component.air_slide(delta)


func _on_hurtbox_component_get_hit(data: AttackData) -> void:
	flash_red()
	camera.shake(6.0, 0.3)
	ParticleManager.player_hit(global_position)
	move_component.apply_knockback(data.direction, data.force)
	switch_state(STATE.HURT)


func play_correct_atk_anim():
	match secondary_weapon :
		Weapon.GlOVES :
			animated_sprite.play("hit_glove_a")
		Weapon.CANON :
			animated_sprite.play("canon")

func flash_red() -> void:
	animated_sprite.modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.1).timeout
	animated_sprite.modulate = Color(1, 1, 1, 1)


func trigger_end_chaos() -> void:
	camera.end_game_chaos()

func hitstop(duration: float = 0.08) -> void:
	Engine.time_scale = 0.5
	await get_tree().create_timer(duration, true).timeout
	Engine.time_scale = 1.0


func play_right_anim():
	pass


func _on_animated_sprite_2d_animation_changed() -> void: 
	if animated_sprite.animation != "jump" or animated_sprite.animation != "idle" :
		if animated_sprite.animation == "hit_bat" :
			anim.play("Entity/scretch")
		else :
			anim.play("Entity/sqash")
		



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "sqash" or anim_name == "scretch" :
			if animated_sprite.animation == "idle" :
				anim.play("Entity/Idle")
				print(223)
			elif active_state == STATE.FLOOR : 
				anim.play("Entity/Slide")

func _on_died() -> void:
	$HealthComponent.reset_health()
	i_died.emit()
