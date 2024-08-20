extends Level

func _ready() -> void:
	if exit_area != null:
		exit_area.body_entered.connect(collapse_and_finish.unbind(1))

func collapse_and_finish() -> void:
	($ExitArea/BreakSFX as AudioStreamPlayer2D).play()
	await get_tree().create_timer(2).timeout
	level_finished.emit()
