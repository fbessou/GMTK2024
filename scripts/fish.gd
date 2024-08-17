class_name Fish
extends CharacterBody2D

enum State {
	PLAYER, # Player has control
	NPC, # Moving alone???
	FROZEN, # Position frozen
}
enum Kind { None=0, Plankton=1, Puffer=2, Angler=4, Whale=8 }
enum Facing { RIGHT = 1, LEFT = -1 }

const FROZEN_DRAG := 0.95

@export var kind := Kind.None
@export var max_speed := 200.0
@export var accel := max_speed / 0.2
@export var drag := 0.6
@export var view_scale := 1.0
@export var max_inclination := 0.35 # from 0.05 to 0.95
@export_flags("Plankton", "Puffer", "Angler", "Whale") var eat := 0
@export var state := State.NPC

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

func _unhandled_input(event: InputEvent) -> void:
	if state == State.PLAYER:
		if event.is_action_pressed("fish_power"):
			_power_on()
		elif event.is_action_released("fish_power"):
			_power_off()

func _physics_process(delta: float) -> void:
	var command_direction := Vector2.ZERO
	if state == State.PLAYER:
		command_direction = Input.get_vector(
			"fish_left", "fish_right", "fish_up", "fish_down"
		)
	
	# Move
	var lon_vel := command_direction.dot(velocity)
	if lon_vel < max_speed:
		lon_vel = lon_vel + maxf(accel * delta, max_speed - lon_vel)
	velocity += command_direction * lon_vel - command_direction * command_direction.dot(velocity)
	var d := FROZEN_DRAG if state == State.FROZEN else drag
	velocity = velocity * pow(1.0 - d, delta)
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

func _power_on() -> void:
	pass

func _power_off() -> void:
	pass
