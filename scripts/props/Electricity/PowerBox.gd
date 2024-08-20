extends Node


@export var associated_powerable: IPowerable
@export var on_color: Color
@export var off_color: Color
@onready var sprite_2d: Sprite2D  = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.modulate = off_color

func _on_area_2d_body_entered(body: Node2D) -> void:
	var eel := body as Eel
	if(eel == null):
		return
	
	eel.powering_on.connect(on_power_on)
	eel.powering_off.connect(on_power_off)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var eel := body as Eel
	if(eel == null):
		return
		
	eel.powering_on.disconnect(on_power_on)
	eel.powering_off.disconnect(on_power_off)
	
func on_power_on()->void:
	sprite_2d.modulate = on_color
	associated_powerable.power_start()
	
func on_power_off()->void:
	sprite_2d.modulate = off_color
	associated_powerable.power_stop()
