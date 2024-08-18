class_name Eel
extends Fish

#@onready var electricity_sprite := %ElectricitySprite as AnimatedSprite2D
@onready var electricity_area := $ElectricityArea2D as Area2D

@onready var _default_max_speed := max_speed
@onready var _default_drag := drag

func _ready() -> void:
	super()
	_power_off()

func _power_on() -> void:
	electricity_area.show()
	electricity_area.monitorable = true
	max_speed = 0.0
	drag = 0.97

func _power_off() -> void:
	electricity_area.hide()
	electricity_area.monitorable = false
	max_speed = _default_max_speed
	drag = _default_drag

func _flip_horizontal(flip: bool) -> void:
	super(flip)
	electricity_area.position.x = absf(electricity_area.position.x) * (1 if flip else -1)
