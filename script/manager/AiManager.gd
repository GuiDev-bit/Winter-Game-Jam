extends Node

var player : Player 
var ball : Ball
var enemies = []
var update_intervall := 0.5
var timer = 0.0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_roles()


func register_enemy(enemy : Enemy) :
	enemies.append(enemy)

func quit_list(enemy : Enemy) :
	enemies.erase(enemy)

func update_roles():
	# --- BATTEURS ---
	var batteurs = enemies.filter(func(e):
		return e.type == e.Type.BATTEUR
	)

	# Trier par distance à la balle (le plus proche en premier)
	batteurs.sort_custom(func(a, b):
		return a.global_position.distance_to(ball.global_position) \
			< b.global_position.distance_to(ball.global_position)
	)

	for i in range(batteurs.size()):
		if i == 0:
			batteurs[i].role = batteurs[i].Role.STRIKER
			


		else:
			batteurs[i].role = batteurs[i].Role.SUPPORT
			# SUPPORT :  couvre zone, proche ball  ici on les place derrière



	# --- BOXEURS ---
	# 1. On récupère tous les boxeurs vivants une seule fois
	var boxers = enemies.filter(func(en): return en.type == en.Type.BOXEUR)

	if boxers.is_empty():
		return # On sort s'il n'y a personne à gérer

	# 2. On les trie du plus proche au plus loin du joueur
	boxers.sort_custom(func(a, b):
		var dist_a = a.global_position.distance_to(player.global_position)
		var dist_b = b.global_position.distance_to(player.global_position)
		return dist_a < dist_b
	)

	# 3. Le premier de la liste (le plus proche) devient le STRIKER
	var striker = boxers[0]
	striker.role = striker.Role.STRIKER

	# 4. Tous les autres (à partir de l'index 1) deviennent SUPPORT
	for i in range(1, boxers.size()):
		var support = boxers[i]
		support.role = support.Role.SUPPORT
		# Placement tactique entre la balle et le joueur


func get_player_reference(player_ : Player):
	player = player_
 
func get_ball_reference(ball_: Ball) :
	ball = ball_
