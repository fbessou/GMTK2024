class_name Rock
extends Polygon2D

@export var amount:=10.0
@export var speed:=10.0
@export var curveX: Curve
@export var curveY: Curve

var elapsedTime := 0.0
var animTime := 1.0

var collapsing := false

var start_pos: Vector2
var rand_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = position
	rand_speed = randf_range(1.0, 3.0)
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!collapsing):
		position.x = start_pos.x + speed * randf_range(-amount, amount) * delta
		position.y = start_pos.y + speed * randf_range(-amount, amount) * delta
	else:
		color.a = 1.0 - elapsedTime / animTime
		position = start_pos + Vector2(curveX.sample(rand_speed * elapsedTime / animTime), - curveY.sample(rand_speed * elapsedTime / animTime)) * 100.0
		elapsedTime += delta
