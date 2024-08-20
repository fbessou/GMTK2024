extends Node2D

@onready var electric_fan: ElectricFan = $"../Gameplay Elements/ElectricFan"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var plankton: Fish = $"../Plankton"
@onready var front: Node2D = $"../Eel/DeathSprite/Front"
@onready var path_2d: Path2D = $"../Path2D"
@onready var path_follow_2d: PathFollow2D = $"../Path2D/PathFollow2D"
@onready var collision_shape_2d: CollisionShape2D = $"../Eel/CollisionShape2D"
@onready var fan_power_box: PowerBox = $"../Gameplay Elements/Fan PowerBox"

func _on_area_2d_body_entered(body: Node2D) -> void:
	var eel := body as Eel
	if(eel == null):
		return
		
	fan_power_box.audio_stream_player_2d.play()
	electric_fan.power_start()
	
	var tween := get_tree().create_tween()
	tween.tween_property(electric_fan, "rotation_speed", electric_fan.rotation_speed * 5.0, 0.5)\
	.set_trans(Tween.TRANS_QUAD)
	
	var camera := get_viewport().get_camera_2d()
	camera.reparent(front)
	eel.state = Fish.State.FROZEN
	path_2d.curve.set_point_position(0, front.global_position)
	
	front.reparent(path_follow_2d)
	front.position = Vector2.ZERO
	animation_player.play("Death")
	await tween.finished
	eel.slice()
	
	await animation_player.animation_finished
	
	plankton.position = front.global_position
	plankton.show()
	plankton.z_index = 10
	plankton.state = Fish.State.PLAYER
	plankton.switch_to_player()
	GameManager.set_active_fish_camera(plankton)
	await plankton.tree_exited
	front.queue_free()
