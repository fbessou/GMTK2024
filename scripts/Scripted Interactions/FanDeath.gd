extends Node2D

@onready var electric_fan: ElectricFan = $"../Gameplay Elements/ElectricFan"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var plankton: Fish = $"../Plankton"
@onready var front: Node2D = $"../Eel/DeathSprite/Front"

func _on_area_2d_body_entered(body: Node2D) -> void:
	var eel := body as Eel
	if(eel == null):
		return
	
	electric_fan.isRotating = true
	var tween := get_tree().create_tween()
	tween.tween_property(electric_fan, "rotation_speed", electric_fan.rotation_speed * 5.0, 0.5)\
	.set_trans(Tween.TRANS_QUAD)
	await tween.finished
	eel.state = Fish.State.FROZEN
	animation_player.play("Death")
	await animation_player.animation_finished
	plankton.position = front.global_position
	plankton.show()
	plankton.z_index = 0
	plankton.state = Fish.State.PLAYER
	plankton.switch_to_player()
	GameManager.set_active_fish_camera(plankton)
