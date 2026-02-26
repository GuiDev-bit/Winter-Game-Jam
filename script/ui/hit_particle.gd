extends Node2D

var particles : GPUParticles2D

func _ready() -> void:
	particles = GPUParticles2D.new()
	add_child(particles)

func setup(sprite: Texture2D, color: Color, amount: int, spread: float, lifetime: float) -> void:
	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(0, -1, 0)
	mat.spread = spread
	mat.initial_velocity_min = 100.0
	mat.initial_velocity_max = 300.0
	mat.gravity = Vector3(0, 300, 0)
	mat.scale_min = 0.1
	mat.scale_max = 0.3
	mat.color = color
	particles.process_material = mat
	particles.texture = sprite
	particles.amount = amount
	particles.lifetime = lifetime
	particles.one_shot = true
	particles.emitting = true
	await get_tree().create_timer(lifetime + 0.5).timeout
	queue_free()
