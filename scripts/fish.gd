class_name Fish
extends CharacterBody2D

enum State { PLAYER, NPC }

enum Facing { RIGHT = 1, LEFT = -1 }

@export var max_speed := 200.0
@export var accel := max_speed / 0.2
@export var drag := 0.4
@export var view_scale := 1.0
@export var max_inclination := 0.35 # from 0.05 to 0.95

var facing := Facing.RIGHT
var orientation := 0.0

var swimming := false:
	set(s):
		if s != swimming:
			swimming = s
			_update_animation()

@onready var _animated_sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var _mouth_area:= $MouthArea2D as Area2D

func _ready() -> void:
	_update_animation()
	assert(_animated_sprite != null)
	assert(_mouth_area != null)
	assert(_mouth_area.collision_layer == 0x4)
	assert(_mouth_area.collision_mask == 0x4)


func _physics_process(delta: float) -> void:
	var command_direction := Input.get_vector(
		"fish_left", "fish_right", "fish_up", "fish_down"
	)
	
	# Move
	velocity += command_direction * accel * delta
	velocity = velocity.limit_length(max_speed)
	velocity = velocity * pow(drag, delta)

	move_and_slide()
	
	# Visual
	
	if not is_zero_approx(command_direction.x):
		facing = Facing.LEFT if command_direction.x < 0 else Facing.RIGHT
	
	var target_orientation := 0.0
	if not command_direction.is_zero_approx():
		target_orientation = command_direction.angle() if facing == Facing.RIGHT else _wrap_angle(PI - command_direction.angle())
		target_orientation = clampf(target_orientation, -PI/2 * 0.95, PI/2 * 0.95)
		
	orientation = lerp_angle(orientation, target_orientation, 0.1)
	
	swimming = not command_direction.is_zero_approx()
	match facing:
		Facing.LEFT:
			_flip_horizontal(false)
			rotation = -orientation * max_inclination
		Facing.RIGHT:
			_flip_horizontal(true)
			rotation = orientation * max_inclination

func _wrap_angle(a: float) -> float:
	return wrapf(a, -PI, PI)

func _update_animation() -> void:
	var animation := "idle"
	
	if swimming:
		if _animated_sprite.sprite_frames.has_animation("swimming"):
			animation = "swimming"
	
	_animated_sprite.play(animation)

func _flip_horizontal(flip: bool) -> void:
	_animated_sprite.flip_h = flip
	_mouth_area.position.x = absf(_mouth_area.position.x) * (1 if flip else -1)
