extends Node2D

var captured_camera : Camera2D = null
#var saved_zoom : Vector2 = null

func _on_body_entered(body: Node2D) -> void:

	if body is Whale:
		(body as Whale).camera_captured = true
	var body_camera := body.find_child("Camera2D")
	if body_camera == null:
		return
#	saved_zoom = body_camera.zoom()
	var target := find_child("Camera2DTarget") as Camera2D
	
	var release_whales := func() -> void:
		($AnimationPlayer as AnimationPlayer).play("whales_in_background")
		
	get_tree().create_timer(1).timeout.connect(release_whales)
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
	($AnimationPlayer as AnimationPlayer).stop(true)
	GameManager.set_active_fish_camera(body as Fish)
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
	
