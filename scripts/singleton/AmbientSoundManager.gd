extends Node

enum Volume { LOW=1, HIGH=2 }

const AMBIENT_INTERACTIVE_STREAM = preload("res://resources/audio/ambient_interactive_stream.tres")

var _vol := Volume.HIGH
var _mute := false
@onready var _player := AudioStreamPlayer.new()
@onready var _ambient_bus := AudioServer.get_bus_index(&"Ambience")
@onready var _default_volume_db := AudioServer.get_bus_volume_db(_ambient_bus)

func _ready() -> void:
	_player.bus = &"Ambience"
	set_volume(_vol)
	add_child(_player)
	_player.stream = AMBIENT_INTERACTIVE_STREAM

func toggle_mute() -> void:
	set_mute(not _mute)
	
func set_mute(m: bool) -> void:
	_mute = m
	AudioServer.set_bus_mute(_ambient_bus, _mute)

func is_mute() -> bool:
	return _mute

func set_volume(level: Volume) -> void:
	set_mute(false)
	_vol = level
	match level:
		Volume.HIGH:
			AudioServer.set_bus_volume_db(_ambient_bus, _default_volume_db)
		Volume.LOW:
			AudioServer.set_bus_volume_db(_ambient_bus, _default_volume_db - 9.0)

func start_ambient() -> void:
	#_player.stream = game_music
	_player.play()

func stop_ambient() -> void:
	_player.stop()
	
