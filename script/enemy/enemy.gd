extends CharacterBody2D
class_name Enemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var hurtbox : HurtboxComponent = $HurtboxComponent
@onready var movcomp : MovementComponement = $MovementComponement
@onready var sprite : AnimatedSprite2D =$AnimatedSprite2D
@export var jump_force : float = -900.0
@export var ball_jump_range : float = 200.0
@export var jump_chance : float = 0.5

enum Type {BATTEUR, BOXEUR, CANON}
@export var type : Type
@onready var timer_atk: Timer = $atkduration
enum Role {
	STRIKER,
	SUPPORT,
}

var role : Role

@export var bat_data : AttackData
@export var gloves_data : AttackData

@export var attack_range : float = 150.0
@export var attack_cooldown : float = 1.0
var atk_cooldown_timer: float = 0.0

var is_attacking := false



enum STATE { IDLE, CHASE, ATTACK, DEAD, HURT }
var active_state : STATE = STATE.IDLE

var player_ref : Player = null
var ball_ref : Ball = null
var attack_timer : float = 0.0
var target = null
var direction : float = 1.0
var last_dir : float = 1.0
var jump_cooldown : float = 0.0

func _ready() -> void:
	health_component.died.connect(_on_died)
	hurtbox.get_hit.connect(_on_get_hit)
	add_to_group("enemies")
	AiManager.register_enemy(self)
	ball_ref = AiManager.ball
	player_ref =AiManager.player
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	execute_role()

func _physics_process(delta: float) -> void:
	process_state(delta)
	process_animation()
	apply_atk_timer(delta)
	check_ball_jump(delta)
	move_and_slide()

func switch_state(to_state: STATE) -> void:
	active_state = to_state

	match active_state:
		STATE.IDLE :
			execute_role()
		STATE.ATTACK:
			lunch_attack()
		STATE.DEAD:
			AiManager.quit_list(self)
			queue_free()

func process_state(delta: float) -> void:
	match active_state:
		STATE.IDLE:
			if not is_on_floor() :
				movcomp.apply_gravity(delta)

		STATE.CHASE:
			chase(delta)

		STATE.ATTACK:
			if is_attacking == false : 
				switch_state(STATE.IDLE)
			movcomp.deccelerate(delta)
			if not is_on_floor() :
				movcomp.apply_gravity(delta)

		STATE.HURT :
			movcomp.actif_knockback(delta)
			if movcomp.knock_timer <= 0:
				switch_state(STATE.IDLE)


#animation
func process_animation():
	match active_state :
		STATE.IDLE :
			if not is_on_floor():
				if velocity.y < 0:
					sprite.play("jump")
				else:
					sprite.play("fall")
			else :
				sprite.play("deccelerate")
		STATE.CHASE :
			if not is_on_floor():
				if velocity.y < 0:
					sprite.play("jump")
				else:
					sprite.play("fall")
			else :
				sprite.play("slide")
		STATE.ATTACK :
			if type == Type.BATTEUR :
				sprite.play("hit_bat")
			elif type == Type.BOXEUR :
				sprite.play("hit_gloves")
		STATE.HURT :
			sprite.play("hurt")
	sprite.flip_h = last_dir < 0 
		


func _on_died() -> void:
	switch_state(STATE.DEAD)

func chase(delta : float):
	var target_pos = target.global_position
	var enemy_pos = global_position
	var distance_to_target = (target_pos - enemy_pos).length()
	if target == null :
		return
	if distance_to_target  < attack_range:
		direction = 0  # stoppe le mouvement
		if atk_cooldown_timer  > 0 :
			pass
		else :
			switch_state(STATE.ATTACK)
	else : 
		check_direction_to_target()
	movcomp.direction = direction 
	movcomp.slide(delta)
	if not is_on_floor() :
		movcomp.apply_gravity(delta)


func check_direction_to_target() :
		if target.global_position.x > global_position.x :
			direction = 1.0
			last_dir = 1.0
			hitbox.shape.position.x = 84
		if target.global_position.x < global_position.x :
			direction = -1.0
			last_dir= -1
			hitbox.shape.position.x = -84




func execute_role():
	match role :
		Role.STRIKER :
			if type == Type.BATTEUR :
				target = ball_ref
			else :
				target = player_ref
	if target :
			switch_state(STATE.CHASE)


func lunch_attack():
	match  type :
		Type.BATTEUR :
			use_correct(bat_data)
			hitbox.attack_data.direction = Vector2(last_dir, -1)
		Type.BOXEUR :
			use_correct(gloves_data)
			hitbox.attack_data.direction = Vector2(last_dir, 0)
	movcomp.dash()
	timer_atk.start()
	is_attacking = true
	hitbox.lunch_attack()
	atk_cooldown_timer = attack_cooldown
	


func apply_atk_timer(delta : float) :
	if atk_cooldown_timer > 0.0 :
		atk_cooldown_timer -= delta
	else : 
		atk_cooldown_timer = 0.0


func _on_get_hit(data: AttackData) -> void:
	movcomp.apply_knockback(data.direction, data.force)
	switch_state(STATE.HURT)


func use_correct( data : AttackData):
	hitbox.attack_data =  data


func _on_atkduration_timeout() -> void:
	is_attacking = false
	hitbox.end_attack()

# pour qu'elle saute vers la balle
func check_ball_jump(delta: float) -> void:
	jump_cooldown -= delta
	if not ball_ref or not is_on_floor():
		return
	if type != Type.BATTEUR:  # seulement les batteurs sautent vers la balle
		return
	var dist = global_position.distance_to(ball_ref.global_position)
	var ball_is_above = ball_ref.global_position.y < global_position.y - 30
	var ball_not_too_high = ball_ref.global_position.y > global_position.y - 300
	if dist < ball_jump_range and ball_is_above and ball_not_too_high and jump_cooldown <= 0:
		if randf() < jump_chance:
			movcomp.jump()
			jump_cooldown = 1.5
