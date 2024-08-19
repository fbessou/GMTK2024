class_name FoodBubble
extends Node2D

@export var fish_textures_resource: FoodIcons

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_bubble()

func show_bubble() -> void:
	show()
	animation_tree.active = true
	audio_stream_player.play()
	
func hide_bubble() -> void:
	hide()
	animation_tree.active = false
	sprite_2d.hide()
	
func load_texture_by_fish_type(fishType: int) -> void:
	if(fishType == 0):
		sprite_2d.texture = null
		return
	sprite_2d.texture = fish_textures_resource.textures[fishType - 1]

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "Default"):
		sprite_2d.show()
