extends CharacterBody2D
class_name Enemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var hitbox : HitboxComponent = $HitboxComponent
@onready var hurtbox : HurtboxComponent = $HurtboxComponent
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

@export var speed : float = 150.0
@export var attack_range : float = 80.0
@export var attack_cooldown : float = 1.0
@export var attack_data : AttackData

enum STATE { IDLE, CHASE, ATTACK, DEAD }
var active_state : STATE = STATE.IDLE

var player_ref : Player = null
var attack_timer : float = 0.0

func _ready() -> void:
	health_component.died.connect(_on_died)
	hurtbox.get_hit.connect(_on_get_hit)
	player_ref = get_tree().get_first_node_in_group("player")
	switch_state(STATE.CHASE)
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()

func switch_state(to_state: STATE) -> void:
	active_state = to_state
	match active_state:
		STATE.ATTACK:
			hitbox.attack_data = attack_data
			hitbox.lunch_attack()
		STATE.DEAD:
			queue_free()

func process_state(delta: float) -> void:
	match active_state:
		STATE.IDLE:
			if player_ref:
				switch_state(STATE.CHASE)

		STATE.CHASE:
			if not player_ref:
				switch_state(STATE.IDLE)
				return
			var distance = global_position.distance_to(player_ref.global_position)
			if distance <= attack_range:
				switch_state(STATE.ATTACK)
			else:
				nav_agent.target_position = player_ref.global_position
				var next = nav_agent.get_next_path_position()
				velocity = (next - global_position).normalized() * speed
		
		STATE.ATTACK:
				attack_timer += delta
				if attack_timer >= attack_cooldown:
					attack_timer = 0.0
					hitbox.end_attack()
					switch_state(STATE.CHASE)

func _on_died() -> void:
	switch_state(STATE.DEAD)

func _on_get_hit(data: AttackData) -> void:
	pass
