extends Parallax2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$SkyStormLayer20260227183650.position.x -= 8 * delta 
	$SkyStormLayer20260227183652.position.x += 7 * delta 
	$SkyStormLayer20260227183644.position.x -= 9 * delta 
	$SkyStormLayer20260227183640.position.x += 6 *delta
