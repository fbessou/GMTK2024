class_name Angler
extends Fish

func _flip_horizontal(flip: bool) -> void:
	super(flip)
	var light := $PointLight2D as Node2D
	light.position.x = absf(light.position.x) * (1 if flip else -1)
