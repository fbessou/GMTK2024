class_name BreakableWall
extends Node

@export var speedThreshold: float = 3000.
@onready var collision_shape_2d: CollisionShape2D = $Colliders/RigidBody2D/CollisionShape2D
@onready var visual: Node = $Visual

var isBroken: bool = false


func _on_body_entered(body: Node2D) -> void:
	var fish := body as Fish
	if(fish == null):
		return
	
	if(fish.velocity.length() >= speedThreshold):
		isBroken = false
		collision_shape_2d.hide()
		collision_shape_2d.queue_free()
		collapse()

func collapse() -> void:
	for child in visual.get_children():
		(child as Rock).collapsing = true
