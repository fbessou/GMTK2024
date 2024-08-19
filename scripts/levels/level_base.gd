class_name Level
extends Node2D

signal level_finished

@onready var exit_area := $ExitArea as Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_area.body_entered.connect(
		func(_body: Node2D) -> void:
			level_finished.emit()
	)
	
	
