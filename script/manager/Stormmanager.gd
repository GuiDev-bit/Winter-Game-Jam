extends Node

# 1. On définit nos 3 niveaux de tempête
enum StormState { SUN, STORM, EXTREME }

# 2. Variables pour suivre l'état actuel et le temps
var current_state: StormState = StormState.SUN
var time_elapsed: float = 0.0
var max_storm_level: int = 2

# 3. On définit les paliers de temps en secondes (Tresholds)
@export var storm_threshold: float = 30.0    # Déclenche STORM à 30 secondes
@export var extreme_threshold: float = 60.0  # Déclenche EXTREME à 1 minute (60s)

# Multiplicateurs de puissance de balle
var ball_force_multiplier: float = 1.0
const STORM_MULTIPLIER: float = 1.2
const EXTREME_MULTIPLIER: float = 1.5

# 4. Signal pour prévenir les autres scripts (effets visuels, dégâts au joueur, etc.)
signal storm_state_changed(new_state: StormState)

func _ready():
	storm_state_changed.emit(current_state)

func setup(max_level: int) -> void:
	max_storm_level = max_level
	current_state = StormState.SUN
	time_elapsed = 0.0
	ball_force_multiplier = 1.0
	storm_state_changed.emit(current_state)

func _process(delta: float) -> void:
	if GameManager.current_state != GameManager.GameState.PLAYING:
		return
	# Si on est déjà au niveau EXTREME, plus besoin de compter le temps pour changer d'état
	if current_state == StormState.EXTREME:
		return
		
	# On ajoute le temps écoulé depuis la dernière frame
	time_elapsed += delta
	
	# On vérifie si on doit passer au niveau supérieur
	check_thresholds()

func check_thresholds() -> void:
	# Passage de SUN à STORM
	if current_state == StormState.SUN and time_elapsed >= storm_threshold:
		if max_storm_level >= 1:
			change_state(StormState.STORM)
		
	# Passage de STORM à EXTREME
	elif current_state == StormState.STORM and time_elapsed >= extreme_threshold:
		if max_storm_level >= 2:
			change_state(StormState.EXTREME)

func change_state(new_state: StormState) -> void:
	current_state = new_state
	
	# Affichage dans la console pour débugger
	match current_state:
		StormState.SUN:
			ball_force_multiplier = 1.0
		StormState.STORM:
			ball_force_multiplier = STORM_MULTIPLIER
		StormState.EXTREME:
			ball_force_multiplier = EXTREME_MULTIPLIER
			
	# On avertit tout le reste du jeu que la tempête a changé
	storm_state_changed.emit(current_state)
