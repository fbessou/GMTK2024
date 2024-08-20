class_name Whale
extends Fish

@export var sounds: Array[AudioStream]
@onready var sing_sfx: AudioStreamPlayer2D = $SingSFX

var elapsed_time := 0.0
var camera_captured := false;
var rand_time := 3.0

func _process(delta: float) -> void:
	var camera := find_child("Camera2D") as Camera2D
	elapsed_time += delta
	if(elapsed_time > rand_time):
		elapsed_time = 0.0
		rand_time = randf_range(3.0, 7.0)
		var rand_index := randi_range(0, 14)
		sing_sfx.stream = sounds[rand_index]
		sing_sfx.play()
	if camera != null and !camera_captured:
		var target_zoom := Vector2.ONE / (1.0 / view_scale + velocity.length() / 2000)
		camera.zoom = lerp(camera.zoom, target_zoom, 0.2)
