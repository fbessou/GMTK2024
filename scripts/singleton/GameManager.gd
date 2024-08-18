extends Node


func set_active_fish_camera(fish: Fish) -> void:
	var camera := get_viewport().get_camera_2d()
	camera.reparent(fish, false)
	camera.position = Vector2.ZERO
	camera.zoom = Vector2.ONE * fish.view_scale
	
