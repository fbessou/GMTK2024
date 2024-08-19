extends Node2D

const PlanktonIdleScn = preload("res://scenes/extra/plankton_idle.tscn")
@onready var level: Node2D = owner
@onready var rune: Sprite2D = $RunePath/RunePathFollow/Rune
@export  var plankton_bgs :Array[Node2D] = []
@onready var plankton_fg :Node2D = $PlanktonsForeground
@onready var plankton_path :Path2D = $PlanktonPath
@onready var plankton_path_follow :PathFollow2D = $PlanktonPath/PlanktonPathFollow

@onready var elected_plankton: Fish = %PlayerPlankton

@export var plankton_count: int = 200;
@export var plankton_fg_count: int = 10;

# 500px, 100px de mou largeur, 100px de bande
# 250px - 450px hauteur
var horizontal_center := 512

var plankton_instances : Array[PlanktonIdle] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for index in range(plankton_count):
		var layer :Node2D = plankton_bgs.pick_random() 
		var proximity := float(index)/float(plankton_count)*2
		var plankton := _create_plankton()
		if abs(plankton.position.x - horizontal_center) < 50:
			proximity = 0.1
		plankton.scale *= lerp(0.5, 1., proximity)
		layer.add_child(plankton)
		plankton_instances.append(plankton)


	for index in range(plankton_fg_count):
		var plankton := _create_plankton()
		plankton.scale *= 2
		$PlanktonsForeground.add_child(plankton)	

func _create_plankton() -> PlanktonIdle:
	var sprite := PlanktonIdleScn.instantiate() as PlanktonIdle
	var x := horizontal_center + randi_range(-100, 100)
	var y := randi_range(250, 450)
	sprite.position = Vector2(x, y)
	return sprite
	

func contaminate() -> void:
	# change color of elected plankton
	#var plankton_mat := elected_plankton.material as ShaderMaterial
	#var plankton_tween_callback := func(contamination: float) -> void:
	#	plankton_mat.set_shader_parameter("plankton_contamination", contamination)
	var rune_mat := rune.material as ShaderMaterial
	var rune_tween_callback := func(power: float) -> void:
		rune_mat.set_shader_parameter("power", power)
	var tween := get_tree().create_tween()
	#tween.tween_method(plankton_tween_callback, 0. , 1., 2.)
	tween.parallel().tween_method(rune_tween_callback, 1., 0., 2.);
	await tween.finished
	start_game()
	#tween.play()
	#mat.set_shader_parameter("plankton_contamination", 1.)
	# mat.set_shader_parameter("depth", 1.)

func start_game() -> void:
	elected_plankton.reparent(level)
	elected_plankton.state = Fish.State.PLAYER
	hide()
	GameManager.set_active_fish_camera(elected_plankton)
	# remove color from stone
	# fade out for next stage
