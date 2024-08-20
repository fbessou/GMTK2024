class_name ElectricFan
extends IPowerable

@export var rotation_speed := 1.0
@onready var holder: Node2D = $Holder
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var isRotating := false

func _physics_process(delta: float) -> void:
	if(isRotating):
		holder.rotate(rotation_speed * delta)
		

func power_start() -> void:
	audio_stream_player_2d.play()
	isRotating = true
	
func power_stop() -> void:
	isRotating = false
