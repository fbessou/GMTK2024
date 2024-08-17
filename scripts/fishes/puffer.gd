class_name Puffer
extends Fish

@export var _small_sprite_frames : SpriteFrames
@export var _large_sprite_frames : SpriteFrames

var _is_large := false :
	set(l):
		if l != _is_large:
			_is_large = l
			_update_size()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fish_power"):
		_is_large = not _is_large

func _update_size() -> void:
	var current_animation := _animated_sprite.animation
	var current_frame := _animated_sprite.frame
	_animated_sprite.sprite_frames = _large_sprite_frames if _is_large else _small_sprite_frames
	_animated_sprite.play()
	_animated_sprite.animation = current_animation
	_animated_sprite.frame = current_frame
