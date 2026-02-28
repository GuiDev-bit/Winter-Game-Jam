extends GPUParticles2D

func _ready() -> void:
	emitting = false
	
	var mat := ParticleProcessMaterial.new()
	mat.direction = Vector3(-1, 0, 0)  # droit vers la gauche
	mat.spread = 5.0  # très droit
	mat.initial_velocity_min = 600.0
	mat.initial_velocity_max = 800.0
	mat.gravity = Vector3(-100, 50, 0)  # légèrement vers le bas
	mat.scale_min = 0.2
	mat.scale_max = 0.5
	mat.color = Color(1, 1, 1, 0.8)
	process_material = mat
	
	texture = load("res://assets/sprites/particles/truc.png")
	amount = 150
	lifetime = 3.0
	one_shot = false
	
	# Spawne sur toute la hauteur à droite
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_shape_scale = Vector3(10, 400, 1)
	
	Stormmanager.storm_state_changed.connect(_on_storm_changed)

func _on_storm_changed(new_state: Stormmanager.StormState) -> void:
	var mat = process_material as ParticleProcessMaterial
	match new_state:
		Stormmanager.StormState.SUN:
			emitting = false
		Stormmanager.StormState.STORM:
			emitting = true
			amount = 150
			mat.initial_velocity_min = 600.0
			mat.initial_velocity_max = 800.0
		Stormmanager.StormState.EXTREME:
			emitting = true
			amount = 400
			mat.initial_velocity_min = 1000.0
			mat.initial_velocity_max = 1500.0
