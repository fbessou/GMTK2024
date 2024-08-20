class_name ControlHint
extends Node

@export var default_color: Color = Color.WHITE


func fade_in() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", default_color, 1.0)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
func fade_out() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 1.0)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.play()
