class_name FoodBubble
extends Node

@export var fish_textures_resource: FoodIcons

@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func show_bubble() -> void:
	animated_sprite_2d.show()
	animated_sprite_2d.play("default")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
	
func hide_bubble() -> void:
	animated_sprite_2d.hide()
	return
	
func load_texture_by_fish_type(fishType: int) -> void:
	sprite_2d.texture = fish_textures_resource.textures[fishType]
