extends Area2D
class_name HitboxComponent

@export var attack_data : AttackData 
@export var shape : CollisionShape2D
enum Team {RED, BLUE, OTHER}
@export var team : Team
@export var always_active := false
signal hit_something

func _ready() -> void:
	if always_active :
		return
	end_attack()

func lunch_attack():
	if shape:
		shape.set_deferred("disabled", false)

func end_attack():
	if shape:
		shape.set_deferred("disabled", true)
	attack_data = null

func _on_area_entered(area: Area2D) -> void:
	print("hitbox a touché: ", area.name, " attack_data: ", attack_data)
	if attack_data and area is HurtboxComponent:
		var hurtb : HurtboxComponent = area
		if hurtb.team == team :
			return
		var data_copy = attack_data 
		area.damage(data_copy)
		emit_signal("hit_something")
		if not always_active :
			end_attack()
		var player = get_tree().get_first_node_in_group("player")
		if player and player.camera:
			player.camera.shake(5.0, 0.2)
	if area is HurtboxComponent and area.get_parent() is Ball:
		#area.get_parent().set_player_nearby(true)
		#get_parent().ball_ref = area.get_parent()
		pass

func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent and area.get_parent() is Ball:
		area.get_parent().set_player_nearby(false)
		get_parent().ball_ref = null
