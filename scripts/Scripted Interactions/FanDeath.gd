extends Node2D

@onready var electric_fan: ElectricFan = $"../Gameplay Elements/ElectricFan"

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
