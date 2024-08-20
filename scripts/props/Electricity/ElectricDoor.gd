class_name ElectricDoor
extends IPowerable

@export var rise_speed := 3.0
@export var fall_speed := 1.0
@export var max_height:=1.0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var startPos : Vector2

var isPowered: bool = false

func _ready() -> void:
	startPos = position

func _physics_process(delta: float) -> void:
	if(isPowered && position.y > startPos.y - max_height):
		position.y -= delta * rise_speed
	if(!isPowered && position.y < startPos.y):
		position.y += delta * fall_speed
		

func power_start() -> void:
	audio_stream_player_2d.play()
	isPowered = true
	
func power_stop() -> void:
	audio_stream_player_2d.play()
	isPowered = false
