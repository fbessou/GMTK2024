extends Node

var pauseMenu : CanvasLayer = null
var paused: bool = false

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	await get_tree().process_frame
	start_game()

func start_game() -> void:
	MusicManager.start_game_music()
	AmbientSoundManager.start_ambient()


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
	
	# match audio
	match(fish.kind):
		Fish.Kind.Plankton:
			MusicManager.stop_intro()
		Fish.Kind.Puffer:
			MusicManager.small_to_medium()
		Fish.Kind.Whale:
			MusicManager.whale()
			
	
func _pause() -> void:
	paused = true
	pauseMenu.show()
	get_tree().paused = paused
	
func _resume() -> void:
	paused = false
	pauseMenu.hide()
	get_tree().paused = paused
