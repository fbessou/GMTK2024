class_name DarknessLevel
extends Level


@onready var animation := $AnimationPlayer as AnimationPlayer
@export var camera_zoom_interpolated := 0.0 :
	set(x):
		camera_zoom_interpolated = x
		interpolate_zoom(x)

func _ready() -> void:
	super()
	RenderingServer.set_default_clear_color(Color("#393e7c"))
	var area := $WaterCurrents/WaterCurrent15 as Area2D
	area.body_entered.connect(_on_body_entered_tunnel)
	AmbientSoundManager.stop_ambient()

func _on_body_entered_tunnel(body: Node2D) -> void:
	var fish := body as Angler
	if fish == null:
		return
	if fish.state != Fish.State.PLAYER:
		return
	fish.halo = true
	
	# Play ending animation with Cthulhu
	fish.freeze()
	($Angler/Camera2D as Camera2D).enabled = false
	(%AnimatedCamera as Camera2D).enabled = true
	animation.play("ending")
	await animation.animation_finished
	print("THE END")

func interpolate_zoom(x: float) -> void:
	var camera := %AnimatedCamera as Camera2D
	var camera_center := camera.global_position.y
	var camera_top := (%CameraTopPosition as Node2D).global_position.y
	var half_screen_height : int = ProjectSettings.get_setting("display/window/size/viewport_height") / 2
	camera.zoom = Vector2.ONE * float(half_screen_height) / (camera_center - camera_top)
	var fish := %Angler as Node2D
	fish.global_position = camera.global_position - Vector2(0, (camera_center - camera_top) * (1.0 - pow(.15, x)))
	
