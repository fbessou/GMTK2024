class_name BreakableWall
extends Node

@export var speedThreshold: float = 3000.
@onready var collision_shape_2d: CollisionShape2D = $Colliders/Static/CollisionShape2D
@onready var visual: Node = $Visual
@onready var break_sfx: AudioStreamPlayer2D = $BreakSFX

var isBroken: bool = false


func _on_body_entered(body: Node) -> void:
	var fish := body as Fish
	if(fish == null):
		return
	var max_velocity := fish.get_max_velocity() 
	if(max_velocity >= speedThreshold and !isBroken):
		isBroken = true
		collision_shape_2d.hide()
		collision_shape_2d.queue_free()
		collapse()
	fish.velocity = Vector2.ZERO

func collapse() -> void:
	break_sfx.play()
	for child in visual.get_children():
		(child as Rock).collapsing = true
