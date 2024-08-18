class_name 	PlanktonIdle
extends AnimatedSprite2D

var _velocity := Vector2.ZERO
var depth : float = 1.
var moving : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not moving:
		return
	if _velocity.length_squared() < 4:
		_velocity = Vector2.from_angle(randf_range(-PI,PI))*randf_range(10., 50.)
	else:
		_velocity *= 0.9
		
	translate(_velocity * _delta)
