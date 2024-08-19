extends Level

func _ready() -> void:
	super()
	#for c in $Environment/Cave.get_children():
		#var lo := c.find_child("LightOccluder2D") as LightOccluder2D
		#if lo == null: continue
		#lo.occluder.cull_mode = OccluderPolygon2D.CULL_CLOCKWISE
