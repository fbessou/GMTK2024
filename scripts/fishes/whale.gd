class_name Whale
extends Fish

var camera_captured := false;

func _process(_delta: float) -> void:
	var camera := find_child("Camera2D") as Camera2D
	if camera != null and !camera_captured:
		var target_zoom := Vector2.ONE / (1.0 / view_scale + velocity.length() / 2000)
		camera.zoom = lerp(camera.zoom, target_zoom, 0.2)
