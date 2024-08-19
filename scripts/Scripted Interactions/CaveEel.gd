extends Fish

var player : Fish
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _scare(_scareOrigin: Vector2) -> void:
	if(!scarable):
		return
		
	scarable = false
	
	player.freeze()
	
	animation_player.play("Scare")
	
	await(animation_player.animation_finished)
	player.switch_to_player()
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
