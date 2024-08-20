class_name ElectricDoor
extends IPowerable

@export var rise_speed := 3.0
@export var fall_speed := 1.0
@export var max_height:=1.0

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
	isPowered = true
	
func power_stop() -> void:
	isPowered = false
