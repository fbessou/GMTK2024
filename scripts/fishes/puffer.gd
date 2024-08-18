class_name Puffer
extends Fish

@export var _small_sprite_frames : SpriteFrames
@export var _large_sprite_frames : SpriteFrames

@export_group("Scare")
@export var scareRadius := 250.

@onready var _default_max_speed := max_speed
@onready var _default_drag := drag
@onready var scare_collision_shape : Node2D = $ScareArea/CollisionShape2D
var _is_large := false :
	set(l):
		if l != _is_large:
			_is_large = l
			_update_size()

func _power_on() -> void:
	_is_large = true
	grow_scare_area()
	max_speed = 15.0
	drag = 0.9

func _power_off() -> void:
	_is_large = false
	max_speed = _default_max_speed
	drag = _default_drag
	scare_collision_shape.scale = Vector2.ZERO

func _update_size() -> void:
	var current_animation := _animated_sprite.animation
	var current_frame := _animated_sprite.frame
	_animated_sprite.sprite_frames = _large_sprite_frames if _is_large else _small_sprite_frames
	_animated_sprite.play()
	_animated_sprite.animation = current_animation
	_animated_sprite.frame = current_frame

func grow_scare_area() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(scare_collision_shape, "scale", scareRadius * Vector2.ONE, 0.1)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.play()

func _on_scare_area_body_entered(_body: Node2D) -> void:
	if(_body is not Fish || _body == self):
		return
	(_body as Fish)._scare(position)
