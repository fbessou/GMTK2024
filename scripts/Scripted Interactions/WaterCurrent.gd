@tool
extends Area2D

@onready var collision_shape := %CollisionShape2D as CollisionShape2D
@onready var particles := %CPUParticles2D as CPUParticles2D
@onready var audio := $WaterCurrentAudio as AudioStreamPlayer2D

@export_range(0, 10000, 1, "suffix:px") var width: int:
	set(new_width):
		width = new_width
		if collision_shape != null:
			update_dimensions()
		
@export_range(0, 10000, 1, "suffix:px")  var length: int:
	set(new_length):
		length = new_length
		if collision_shape != null:
			update_dimensions()


@export_range(0, 5000, 10, "suffix:px/s²") var intensity: int:
	set(new_intensity):
		intensity  = new_intensity
		gravity = new_intensity

@export var bubbles_amount := 10:
	set(new_amount):
		bubbles_amount = new_amount
		if particles != null:
			update_dimensions()

@export var bubbles_size := 0.5:
	set(size):
		bubbles_size = size
		if particles != null:
			update_dimensions()

@export var audio_max_distance := 2000:
	set(distance):
		audio_max_distance = distance
		_update_audio()

func update_dimensions() -> void:
	if collision_shape == null:
		return
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width, length)
	collision_shape.shape = shape
	particles.emission_rect_extents=Vector2(width/2, length/2)
	
	particles.scale_amount_max = bubbles_size
	particles.scale_amount_min = bubbles_size/5
	particles.initial_velocity_min = bubbles_size*400/5
	particles.initial_velocity_min = bubbles_size*400
	
	particles.amount = bubbles_amount


func _ready() -> void:
	update_dimensions()
	_update_audio()
	gravity_direction = Vector2.from_angle(rotation + PI/2.)

func _update_audio() -> void:
	if audio == null:
		return
	
	audio.max_distance = audio_max_distance
