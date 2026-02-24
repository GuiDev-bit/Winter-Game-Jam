extends Node
class_name Inputcomponent

var x_input := 0.0
var jump_press := false
var charged_bat :=false
var bat_charging := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	x_input = Input.get_axis("left", "right")
	jump_press = Input.is_action_just_pressed("jump")
	charged_bat = Input.is_action_just_released("attack_l")

	
