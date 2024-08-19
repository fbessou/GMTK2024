class_name Whale
extends Fish

func _process(_delta: float) -> void:
	var camera := find_child("Camera2D") as Camera2D
	if camera != null:
		camera.zoom = Vector2.ONE / (1.0 / view_scale + velocity.length() / 2000)
