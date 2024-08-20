extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $StaticCameraZone/AudioStreamPlayer2D

var captured_camera : Camera2D = null
#var saved_zoom : Vector2 = null
var whales_released := false
func _on_body_entered(body: Node2D) -> void:

	if body is Whale:
		(body as Whale).camera_captured = true
	var body_camera := body.find_child("Camera2D")
	if body_camera == null:
		return
#	saved_zoom = body_camera.zoom()
	var target := find_child("Camera2DTarget") as Camera2D
	
	if not whales_released:
		($AnimationPlayer as AnimationPlayer).play("whales_in_background")
		whales_released = true

	audio_stream_player_2d.play()
	var tween := get_tree().create_tween()
	body_camera.reparent(self)
	captured_camera = body_camera
	tween.tween_property(body_camera, "zoom", target.zoom, 2)
	tween.parallel().tween_property(body_camera, "global_position", target.global_position, 2)
	tween.play()
	
	
func _on_body_exited(body: Node2D) -> void:
	if body is Whale:
		(body as Whale).camera_captured = false
	else:
		return
	# ($AnimationPlayer as AnimationPlayer).stop(true)
	var camera := get_viewport().get_camera_2d()
	camera.reparent(body, false)
	camera.position = Vector2.ZERO
	# 	captured_camera.reparent(body)
	
	return	
	#var tween := get_tree().create_tween()
	#tween.tween_property(captured_camera, "zoom", target.zoom, 2)
	#tween.parallel().tween_property(body_camera, "global_position", target.global_position, 2)
	#tween.play()
#
	#captured_camera.drag_horizontal_enabled = true
	#captured_camera.drag_vertical_enabled = true
	#captured_camera.position_smoothing_enabled = true
	
