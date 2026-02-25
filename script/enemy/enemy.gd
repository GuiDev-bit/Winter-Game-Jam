extends CharacterBody2D
class_name Enemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var hurtbox : HurtboxComponent = $HurtboxComponent
@onready var movcomp : MovementComponement = $MovementComponement
@onready var sprite : AnimatedSprite2D =$AnimatedSprite2D

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

var is_attacking := false



enum STATE { IDLE, CHASE, ATTACK, DEAD }
var active_state : STATE = STATE.IDLE

var player_ref : Player = null
var ball_ref : Ball = null
var attack_timer : float = 0.0
var target = null
var direction : float = 1.0
var last_dir : float = 1.0

func _ready() -> void:
	health_component.died.connect(_on_died)
	hurtbox.get_hit.connect(_on_get_hit)
	switch_state(STATE.CHASE)
	add_to_group("enemies")
	AiManager.register_enemy(self)
	ball_ref = AiManager.ball
	player_ref =AiManager.player
	execute_role()

func _physics_process(delta: float) -> void:
	process_state(delta)
	process_animation()
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

#animation
func process_animation():
	match active_state :
		STATE.IDLE :
			if not is_on_floor():
				sprite.play("fall")
			else :
				sprite.play("deccelerate")
		STATE.CHASE :
			if not is_on_floor():
				sprite.play("fall")
			else :
				sprite.play("slide")
		STATE.ATTACK :
			sprite.play("hit_bat")
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

func attack():
	pass




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
	movcomp.dash()
	timer_atk.start()
	is_attacking = true
	hitbox.lunch_attack()
	


func _on_get_hit(data: AttackData) -> void:
	pass


func use_correct( data : AttackData):
	hitbox.attack_data =  data


func _on_atkduration_timeout() -> void:
	is_attacking = false
	hitbox.end_attack()
	
