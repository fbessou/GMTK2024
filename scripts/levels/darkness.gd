extends Level


@onready var animation := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	super()
	ProjectSettings.set_setting("rendering/environment/defaults/default_clear_color", Color.BLACK)
	var area := $WaterCurrents/WaterCurrent8 as Area2D
	area.body_entered.connect(_on_body_entered_tunnel)

func _on_body_entered_tunnel(body: Node2D) -> void:
	var fish := body as Fish
	if fish == null:
		return
	if fish.state != Fish.State.PLAYER:
		return
	
	# Play ending animation with Cthulhu
	fish.freeze()
	($Angler/Camera2D as Camera2D).enabled = false
	($AnimationPlayer/Camera2D as Camera2D).enabled = true
	animation.play("ending")
	await animation.animation_finished
	print("THE END")
