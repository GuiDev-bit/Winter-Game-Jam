extends Node

# 1. On définit nos 3 niveaux de tempête
enum StormState { SUN, STORM, EXTREME }

# 2. Variables pour suivre l'état actuel et le temps
var current_state: StormState = StormState.SUN
var time_elapsed: float = 0.0

# 3. On définit les paliers de temps en secondes (Tresholds)
@export var storm_threshold: float = 30.0    # Déclenche STORM à 30 secondes
@export var extreme_threshold: float = 60.0  # Déclenche EXTREME à 1 minute (60s)

# 4. Signal pour prévenir les autres scripts (effets visuels, dégâts au joueur, etc.)
signal storm_state_changed(new_state: StormState)

func _ready():
	storm_state_changed.emit(current_state)

func _process(delta: float) -> void:
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
		change_state(StormState.STORM)
		
	# Passage de STORM à EXTREME
	elif current_state == StormState.STORM and time_elapsed >= extreme_threshold:
		change_state(StormState.EXTREME)

func change_state(new_state: StormState) -> void:
	current_state = new_state
	
	# Affichage dans la console pour débugger
	match current_state:
		StormState.STORM:
			print("Temps écoulé (", time_elapsed, "s) -> La tempête commence (STORM) !")
		StormState.EXTREME:
			print("Temps écoulé (", time_elapsed, "s) -> C'est la fin du monde (EXTREME) !")
			
	# On avertit tout le reste du jeu que la tempête a changé
	storm_state_changed.emit(current_state)
