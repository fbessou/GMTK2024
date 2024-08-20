class_name Fish
extends CharacterBody2D

signal body_collided(body: Node2D, speed: float)

enum State {
	PLAYER, # Player has control
	NPC, # Moving alone???
	FROZEN, # Position frozen
}
enum Kind { None, Plankton, Puffer, Angler, Whale, Eel, Anchovy }
enum Facing { RIGHT = 1, LEFT = -1 }

const FROZEN_DRAG := 1.0

@export var kind := Kind.None
@export var max_speed := 200.0
@export var accel := max_speed / 0.2
@export var drag := 0.6
@export var view_scale := 1.0
@export var max_inclination := 0.35 # from 0.05 to 0.95
@export var eat := Kind.None
@export var state := State.NPC
@export var scarable: bool = false
@export var ignoreCurrent: bool = false

@export_group("Eat Animation")
@export var eatAnimationSpeed := 0.5
@export var transType : Tween.TransitionType
@export var cameraAnimationSpeed := 1.0
@export var cameraZoomFactor := 2.0

@export var facing := Facing.LEFT
var orientation := 0.0
var target : Fish

var mean_vel_array: Vector3

var swimming := false:
	set(s):
		if s != swimming:
			swimming = s
			_update_animation()

@onready var _power_off_timer := $PowerOffTimer as Timer
@onready var _animated_sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var _mouth_area:= $MouthArea2D as Area2D
@onready var food_bubble := $FoodBubble as FoodBubble
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var corruption_audio: AudioStreamPlayer2D = $CorruptionAudio
@onready var scare_sfx: AudioStreamPlayer2D = $ScareSFX


func _ready() -> void:
	#max_speed *= 10.0
	_update_animation()
	assert(_animated_sprite != null)
	assert(_mouth_area != null)
	assert(food_bubble != null)
	assert(_mouth_area.collision_layer == 0x4)
	assert(_mouth_area.collision_mask == 0x4)
	match(state):
		State.PLAYER:
			switch_to_player()
			(material as ShaderMaterial).set_shader_parameter("corruption", 1.0)
		State.NPC:
			switch_to_npc()
			(material as ShaderMaterial).set_shader_parameter("corruption", 0.0)
		State.FROZEN:
			freeze()
	_mouth_area.body_entered.connect(_on_body_entered)
	_mouth_area.body_exited.connect(_on_body_exited)
	food_bubble.load_texture_by_fish_type(eat)
	_power_off_timer.timeout.connect(_power_off)

func _unhandled_input(event: InputEvent) -> void:
	if state == State.PLAYER:
		if event.is_action_pressed("fish_power"):
			if _power_off_timer.is_stopped():
				_power_on()
			else:
				_power_off_timer.stop()
		elif event.is_action_released("fish_power"):
			_power_off_timer.start()

func _physics_process(delta: float) -> void:
	
	# Apply Water Current if there is one
	if(!ignoreCurrent):
		velocity += get_gravity() * delta
	
	var command_direction := Vector2.ZERO
	if state == State.PLAYER:
		command_direction = Input.get_vector(
			"fish_left", "fish_right", "fish_up", "fish_down"
		)
	
	# Move
	var lon_vel := command_direction.dot(velocity)
	if lon_vel < max_speed:
		lon_vel = lon_vel + minf(accel * delta, max_speed - lon_vel)
	velocity += command_direction * lon_vel - command_direction * command_direction.dot(velocity)
	var d := FROZEN_DRAG if state == State.FROZEN else drag
	velocity = velocity * pow(1.0 - d, delta)
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		var collider := collision.get_collider() as Node2D
		var speed := velocity.length()
		if collider != null:
			body_collided.emit(collider, speed)
		# update velocity
		velocity = velocity.slide(collision.get_normal())
	
	calculate_mean_velocity()
	
	# Visual
	_match_visual_angle(command_direction)

func _wrap_angle(a: float) -> float:
	return wrapf(a, -PI, PI)

func _update_animation() -> void:
	var animation := "idle"
	
	if swimming:
		if _animated_sprite.sprite_frames.has_animation("swimming"):
			animation = "swimming"
	
	_animated_sprite.play(animation)

func _flip_horizontal(flip: bool) -> void:
	_animated_sprite.flip_h = flip
	_mouth_area.position.x = absf(_mouth_area.position.x) * (1 if flip else -1)

func _power_on() -> void:
	pass

func _power_off() -> void:
	pass
	
func _scare(_scareOrigin: Vector2) -> void:
	if(!scarable):
		return
		
	var dir := (position - _scareOrigin).normalized()
	velocity = dir*max_speed
	scare_sfx.play()
	#var elapsedTime := 0.
	#while(elapsedTime < 0.25):
		#elapsedTime += get_process_delta_time()
		## Move
		#velocity = dir
		#var lon_vel := dir.dot(velocity)
		#if lon_vel < max_speed:
			#lon_vel = lon_vel + minf(accel * get_process_delta_time(), max_speed - lon_vel)
		#velocity += dir * lon_vel - dir * dir.dot(velocity)
		#var d := FROZEN_DRAG if state == State.FROZEN else drag
		#velocity = velocity * pow(1.0 - d, get_process_delta_time()) * 50.
		#move_and_slide()
		#
		## Visual
	_match_visual_angle(dir)
		
func _match_visual_angle(direction: Vector2) -> void:
	if not is_zero_approx(direction.x):
		facing = Facing.LEFT if direction.x < 0 else Facing.RIGHT
	
	var target_orientation := 0.0
	if not direction.is_zero_approx():
		target_orientation = direction.angle() if facing == Facing.RIGHT else _wrap_angle(PI - direction.angle())
		target_orientation = clampf(target_orientation, -PI/2 * 0.95, PI/2 * 0.95)
		
	orientation = lerp_angle(orientation, target_orientation, 0.1)
	
	swimming = not direction.is_zero_approx()
	match facing:
		Facing.LEFT:
			_flip_horizontal(false)
			rotation = -orientation * max_inclination
		Facing.RIGHT:
			_flip_horizontal(true)
			rotation = orientation * max_inclination
	
	
func _on_body_entered(body: Fish) -> void:
	if(body == self || eat == 0):
		return
	if(body.kind == eat && body.state == Fish.State.PLAYER):
		food_bubble.hide_bubble()
		body.freeze()
		collision_layer = 0x0
		target = body
		# NPC fish eats target
		lerp_to_target_tween()
	else:
		food_bubble.show_bubble()

func freeze() -> void:
	state = State.FROZEN
	collision_layer = 0x0
	
func switch_to_player() -> void:
	state = State.PLAYER
	collision_layer = 0x6
	
	# shader corruption tween
	corruption_audio.play()
	var tween := get_tree().create_tween()
	var corruption_tween := func(corruption: float) -> void:
		(material as ShaderMaterial).set_shader_parameter("corruption", corruption)
		
	tween.parallel().tween_method(corruption_tween, 0. , 1., cameraAnimationSpeed)
	
func switch_to_npc() -> void:
	state = State.NPC
	collision_layer = 0x2

func _on_body_exited(_body: Fish) -> void:
	food_bubble.hide_bubble()
	
func lerp_to_target_tween() -> void:
	var current_cam := get_viewport().get_camera_2d()
	
	# position tween
	var tween_in := get_tree().create_tween()
	tween_in.tween_property(self, "global_position", target.global_position, eatAnimationSpeed)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(transType)
	
	var eat_sound := func() -> void: 
		audio_stream_player_2d.play()
	var timer:SceneTreeTimer = get_tree().create_timer(eatAnimationSpeed * 0.8) # dirty fix 
	timer.timeout.connect(eat_sound)  
	
	# camera zoom in tween
	tween_in.parallel().tween_property(current_cam, "zoom", current_cam.zoom * cameraZoomFactor, cameraAnimationSpeed)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_QUAD)
	
	corruption_audio.play()
	tween_in.play()
	await tween_in.finished
	global_position = target.global_position
	switch_to_player()
	
	var zoom_base := current_cam.zoom
	GameManager.set_active_fish_camera(self)
	
	target.queue_free()
	
	# camera zoom out tween
	var tween_out := get_tree().create_tween()
	tween_out.tween_property(current_cam, "zoom", view_scale * Vector2.ONE, cameraAnimationSpeed)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_QUAD)\
		.from(zoom_base)
		

func calculate_mean_velocity() -> void:
	mean_vel_array.x = mean_vel_array.y
	mean_vel_array.y = mean_vel_array.z
	mean_vel_array.z = velocity.length()
	
func get_max_velocity() -> float:
	return max(mean_vel_array.x, mean_vel_array.y, mean_vel_array.z)
