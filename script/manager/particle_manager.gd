extends Node

const HIT_PARTICLES = preload("res://scenes/ui/hit_particles.tscn")

var circle_tex : Texture2D
var star_tex : Texture2D
var sparkle_tex : Texture2D
var diamond_tex : Texture2D
var snowflake_tex : Texture2D
var snowflake2_tex : Texture2D
var cloud_tex : Texture2D

func _ready() -> void:
	circle_tex = load("res://assets/sprites/particles/boule.png")
	star_tex = load("res://assets/sprites/particles/etoile.png")
	sparkle_tex = load("res://assets/sprites/particles/jsp.png")
	diamond_tex = load("res://assets/sprites/particles/carrepasdroit.png")
	snowflake_tex = load("res://assets/sprites/particles/truc.png")
	snowflake2_tex = load("res://assets/sprites/particles/trucchose.png")
	cloud_tex = load("res://assets/sprites/particles/bouleneige.png")

func spawn(pos: Vector2, sprite: Texture2D, color: Color, amount: int = 8, spread: float = 45.0, lifetime: float = 0.4) -> void:
	var p = HIT_PARTICLES.instantiate()
	get_tree().current_scene.add_child(p)
	p.global_position = pos
	p.setup(sprite, color, amount, spread, lifetime)

func player_hit(pos: Vector2) -> void:
	spawn(pos, circle_tex, Color(1, 0.2, 0.2), 10, 360)
	spawn(pos, star_tex, Color(1, 0.5, 0), 3, 360)

func enemy_hit(pos: Vector2) -> void:
	spawn(pos, circle_tex, Color(1, 1, 1), 8, 360)
	spawn(pos, diamond_tex, Color(0.5, 0.8, 1), 3, 360)

func ball_hit(pos: Vector2) -> void:
	spawn(pos, sparkle_tex, Color(1, 1, 0.5), 2, 360)

func jump_puff(pos: Vector2) -> void:
	spawn(pos, cloud_tex, Color(1, 1, 1, 0.8), 3, 60, 0.3)

func charge_release(pos: Vector2) -> void:
	spawn(pos, sparkle_tex, Color(0.5, 0.8, 1), 12, 360)
	spawn(pos, star_tex, Color(1, 1, 1), 8, 360)

func slide_dust(pos: Vector2) -> void:
	spawn(pos, diamond_tex, Color(0.7, 0.9, 1, 0.7), 1, 30, 0.2)
