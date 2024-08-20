extends Node

const levels : Array[PackedScene] = [
	preload("res://scenes/Levels/level_1.tscn"),
	preload("res://scenes/Levels/level_2.tscn"),
	preload("res://scenes/Levels/descent.tscn"),
	preload("res://scenes/Levels/level_3.tscn")
]
var current_level_index := -1
var current_level : Level

@onready var switch_level_animation := $CanvasLayer/AnimationPlayer as AnimationPlayer

func _ready() -> void:
	load_next_level()

func switch_to_next_level() -> void:
	current_level.level_finished.disconnect(switch_to_next_level)
	switch_level_animation.play("fade_out")
	await switch_level_animation.animation_finished
	load_next_level()
	switch_level_animation.play("fade_in")
	await switch_level_animation.animation_finished

func load_next_level() -> void:
	current_level_index += 1
	var next_level: Level = levels[current_level_index].instantiate()
	next_level.level_finished.connect(switch_to_next_level)
	if current_level != null:
		current_level.queue_free()
	current_level = next_level
	get_tree().root.add_child.call_deferred(next_level)
