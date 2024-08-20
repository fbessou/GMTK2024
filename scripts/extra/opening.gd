class_name Opening
extends Node2D

const PlanktonIdleScn = preload("res://scenes/extra/plankton_idle.tscn")
@onready var level: Node2D = owner
@onready var rune_path: Path2D = $RunePath
@onready var rune: Sprite2D = $RunePath/RunePathFollow/Rune
@onready var plankton_fg :Node2D = $PlanktonsForeground
@onready var plankton_path :Path2D = $PlanktonPath
@onready var plankton_path_follow :PathFollow2D = $PlanktonPath/PlanktonPathFollow

@onready var elected_plankton: Fish = %PlayerPlankton

@export var plankton_bgs :Array[Node2D] = []
@export var nodes_to_hide: Array[Node2D] = []


@export var skip_opening: bool = false
@export var plankton_count: int = 200;
@export var plankton_fg_count: int = 10;

# 500px, 100px de mou largeur, 100px de bande
# 250px - 450px hauteur
@export var zone_up := 192
@export var zone_down := 420

@export var zone_left := -500
@export var zone_hcenter := -200
@export var zone_right := -25

var plankton_instances : Array[PlanktonIdle] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	for index in range(plankton_count):
		var layer :Node2D = plankton_bgs.pick_random() 
		var proximity := float(index)/float(plankton_count)*2
		var plankton := _create_plankton()
		if abs(plankton.global_position.x - zone_hcenter) < 50:
			proximity = 0.1
		plankton.scale *= lerp(0.5, 1., proximity)
		layer.add_child(plankton)
		#plankton_instances.append(plankton)

	for index in range(plankton_fg_count):
		var plankton := _create_plankton()
		#plankton.scale *= 2
		$PlanktonsForeground.add_child(plankton)
	for node in nodes_to_hide:
		node.hide()

	if not skip_opening:
		($AnimationPlayer as AnimationPlayer).animation_finished.connect(start_game.unbind(1))
		
func _process(_delta: float) -> void:
	if skip_opening:
		($AnimationPlayer as AnimationPlayer).stop()
		start_game()
		set_process(false)

func _create_plankton() -> PlanktonIdle:
	var sprite := PlanktonIdleScn.instantiate() as PlanktonIdle
	var x := randi_range(zone_left, zone_right)
	var y := randi_range(zone_down, zone_up)
	sprite.global_position = Vector2(x, y)
	return sprite


func start_game() -> void:
	# Ensure rune is at its final position
	rune.global_position = rune_path.global_transform * rune_path.curve.get_point_position(rune_path.curve.point_count-1)
	var rune_mat := rune.material as ShaderMaterial
	rune_mat.set_shader_parameter("power", 0)
	rune.reparent(level)
	for child in rune.get_children():
		rune.remove_child(child)
	
	# Start playing with our little plankton
	elected_plankton.reparent(level)
	elected_plankton.switch_to_player()
	
	GameManager.set_active_fish_camera(elected_plankton)

	for node in nodes_to_hide:
		node.show()
	hide()
