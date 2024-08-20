class_name Eel
extends Fish

#@onready var electricity_sprite := %ElectricitySprite as AnimatedSprite2D
@onready var electricity_area := $ElectricityArea2D as Area2D

@onready var _default_max_speed := max_speed
@onready var _default_drag := drag
@onready var elec_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var cut_sfx:AudioStreamPlayer2D = $CutSFX

signal powering_on
signal powering_off


func _ready() -> void:
	super()
	_power_off()

func _power_on() -> void:
	electricity_area.show()
	electricity_area.monitorable = true
	max_speed = 0.0
	drag = 0.97
	powering_on.emit()
	elec_sound.play()

func _power_off() -> void:
	electricity_area.hide()
	electricity_area.monitorable = false
	max_speed = _default_max_speed
	drag = _default_drag
	powering_off.emit()
	elec_sound.stop()

func _flip_horizontal(flip: bool) -> void:
	super(flip)
	electricity_area.position.x = absf(electricity_area.position.x) * (1 if flip else -1)
	
func slice() -> void:
	cut_sfx.play()
