class_name Angler
extends Fish

var halo := false :
	set(h):
		if h != halo:
			halo = h
			if h:
				_switch_to_halo_mode()
			else:
				_switch_to_light_mode()

func _ready() -> void:
	super()
	_switch_to_light_mode()
	halo = false

func _flip_horizontal(flip: bool) -> void:
	super(flip)
	var light := $PointLight2D as Node2D
	light.position.x = absf(light.position.x) * (1 if flip else -1)

func _switch_to_halo_mode() -> void:
	($PointLight2D as Node2D).hide()
	($LightHalo as Node2D).show()

func _switch_to_light_mode() -> void:
	($PointLight2D as Node2D).show()
	($LightHalo as Node2D).hide()
