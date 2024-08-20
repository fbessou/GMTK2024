extends Node

@onready var ability_hint: ControlHint = $"Ability Hint"

func _on_water_current_body_entered(body: Node2D) -> void:
	var puffer := body as Puffer
	if(puffer == null):
		return
	ability_hint.fade_in()
