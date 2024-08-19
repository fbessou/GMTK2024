extends Area2D


func _ready() -> void:
	gravity_direction = Vector2.from_angle(rotation + PI/2.)
	print(gravity_direction)
