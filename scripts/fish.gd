class_name Fish
extends CharacterBody2D

enum State { CONTROLLED, }
enum Facing { RIGHT = 1, LEFT = -1 }
@export var max_speed := 200.0
@export var accel := max_speed / 0.2
@export var drag := 0.4

var facing := Facing.RIGHT
var orientation := 0.0
var orientation_speed := 0.0
var speed := 0.0

@onready var _sprite := $AnimatedSprite2D as AnimatedSprite2D

func _process(_delta: float) -> void:
	# Inclination / H-flip
	var rot := 0.0
	match facing:
		Facing.LEFT:
			_sprite.flip_h = true
			rot = -orientation
		Facing.RIGHT:
			_sprite.flip_h = false
			rot = orientation
	_sprite.rotation = rot * .35

func _physics_process(delta: float) -> void:
	var command_direction := Input.get_vector(
		"fish_left", "fish_right", "fish_up", "fish_down"
	)
	
	velocity += command_direction * accel * delta
	velocity = velocity.limit_length(max_speed)
	velocity = velocity * pow(drag, delta)
	
	if not is_zero_approx(command_direction.x):
		facing = Facing.LEFT if command_direction.x < 0 else Facing.RIGHT

	move_and_slide()
	
	var target_orientation := 0.0
	if not command_direction.is_zero_approx():
		target_orientation = command_direction.angle() if facing == Facing.RIGHT else _wrap_angle(PI - command_direction.angle())
		target_orientation = clampf(target_orientation, -PI/2 * 0.95, PI/2 * 0.95)
	($Polygon2D as Node2D).rotation = target_orientation
	($Polygon2D2 as Node2D).rotation = orientation
	orientation = lerp_angle(orientation, target_orientation, 0.1)

func _wrap_angle(a: float) -> float:
	return wrapf(a, -PI, PI)
