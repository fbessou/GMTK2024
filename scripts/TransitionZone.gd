class_name TransitionZone
extends Area2D

@export var destination: Camera2D
@export var player: Player
@export var duration_in: float = 7.
@export var duration_out: float = 2.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# CameraShifter.transition_to_requested_camera_2d(player.camera, destination)
	connect("body_entered", _change_camera)
	
func _change_camera(_body: Node2D) -> void :
	
	var start_zoom := player.camera.zoom

	player.disable_inputs()
	
	var tween := get_tree().create_tween()
	
	tween.tween_property(player.camera, "global_position", destination.global_position, duration_in)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(player.camera, "zoom", destination.zoom, duration_in)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_QUAD)

	tween.tween_interval(2.)
	
	tween.tween_property(player.camera, "position", Vector2.ZERO, duration_out)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(player.camera, "zoom", start_zoom, duration_out)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_EXPO)
		
	tween.play()
	await tween.finished


	player.enable_inputs()
