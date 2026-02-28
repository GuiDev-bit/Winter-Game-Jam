extends RigidBody2D

enum Team { RED, BLUE }
@export var team = Team.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if team == Team.BLUE : 
		AiManager.enemy_skittle  = self



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Ball : 
		if team == Team.RED : 
			GameManager.add_goal("left")
		if team == Team.BLUE: 
			GameManager.add_goal("right")
