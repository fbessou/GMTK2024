class_name EatFish
extends CollisionObject2D

@export var player: Player
@export var duration_in: float = 2.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mouth:Area2D = $Mouth
	# CameraShifter.transition_to_requested_camera_2d(player.camera, destination)
	mouth.connect("body_entered", _eat_fish)

func _eat_fish(_body: Node2D) -> void :
	# on eat ->
	#	camera's parent changes
	#	fish stack
	var destCamera :Camera2D = $Camera2D
	var destZoom := destCamera.zoom
	var destGlobalPosition := destCamera.global_position
	destCamera.enabled=true
	
	var srcCamera := (_body as Player).camera
	destCamera.global_position = srcCamera.get_screen_center_position()
	destCamera.zoom = srcCamera.zoom
	
	player.disable_inputs()
	
	srcCamera.reset_smoothing()
	srcCamera.position = Vector2.ZERO
	srcCamera.enabled = false
	
	var tween := get_tree().create_tween()
	tween.tween_property(destCamera, "global_position", destGlobalPosition, duration_in)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(destCamera, "zoom", destZoom, duration_in)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_QUAD)
		
	tween.play()
	await tween.finished
	
	# enable player logic layer so it can be eaten
	set_collision_layer_value(3, true)
	
	player.enable_inputs()
	
	
