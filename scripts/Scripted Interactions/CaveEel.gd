extends Fish

var player : Fish
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var flee_sfx: AudioStreamPlayer2D = $FleeSFX

func _scare(_scareOrigin: Vector2) -> void:
	if(!scarable):
		return

	scarable = false
	
	flee_sfx.play()
	animation_player.play("Scare")
	
	await(flee_sfx.finished)

	queue_free()

func _on_scare_anim_area_body_entered(body: Node2D) -> void:
	var puffer := body as Puffer
	if(puffer == null):
		return
	if(puffer.state == State.PLAYER):
		player = puffer
		scarable = true
	if(puffer._is_large):
		_scare(puffer.position)


func _on_scare_anim_area_body_exited(_body: Node2D) -> void:
	var puffer := _body as Puffer
	if(puffer == null):
		return
	scarable = false
