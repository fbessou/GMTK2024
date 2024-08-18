extends Node

var pauseMenu : CanvasLayer = null

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

var paused: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if(paused):
			_resume()
		else:
			_pause()

func set_active_fish_camera(fish: Fish) -> void:
	var camera := get_viewport().get_camera_2d()
	camera.reparent(fish, false)
	camera.position = Vector2.ZERO
	camera.zoom = Vector2.ONE * fish.view_scale
	
func _pause() -> void:
	paused = true
	pauseMenu.show()
	get_tree().paused = paused
	
func _resume() -> void:
	paused = false
	pauseMenu.hide()
	get_tree().paused = paused
