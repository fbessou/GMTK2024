extends AnimatedSprite2D

func _ready() -> void:
	set_frame_and_progress(randi()%2, randf())
