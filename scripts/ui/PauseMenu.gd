class_name PauseMenu
extends CanvasLayer

@onready var ui : Control = $UI

var bus_index: int

func _ready() -> void:
	GameManager.pauseMenu = self
	hide()

func _on_resume_button_button_down() -> void:
	GameManager._resume()


# Sliders
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	pass # Replace with function body.

func _on_ambience_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear_to_db(value))
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundFx"), linear_to_db(value))
	pass # Replace with function body.
