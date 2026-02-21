extends Node2D

func _on_goal_left_body_entered(body):
	if body.name == "Ball":
		GameManager.add_goal("right")

func _on_goal_right_body_entered(body):
	if body.name == "Ball":
		GameManager.add_goal("left")
