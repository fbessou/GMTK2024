class_name Puffer
extends Fish

@export var _small_sprite_frames : SpriteFrames
@export var _large_sprite_frames : SpriteFrames

@onready var _default_max_speed := max_speed
@onready var _default_drag := drag

var _is_large := false :
	set(l):
		if l != _is_large:
			_is_large = l
			_update_size()

func _power_on() -> void:
	_is_large = true
	max_speed = 15.0
	drag = 0.9

func _power_off() -> void:
	_is_large = false
	max_speed = _default_max_speed
	drag = _default_drag

func _update_size() -> void:
	var current_animation := _animated_sprite.animation
	var current_frame := _animated_sprite.frame
	_animated_sprite.sprite_frames = _large_sprite_frames if _is_large else _small_sprite_frames
	_animated_sprite.play()
	_animated_sprite.animation = current_animation
	_animated_sprite.frame = current_frame
