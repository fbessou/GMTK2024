extends Node

enum Volume { LOW=1, HIGH=2 }

const MUSIC_INTERACTIVE_STREAM = preload("res://resources/audio/music_interactive_stream.tres")

var _vol := Volume.HIGH
var _mute := false
@onready var _player := AudioStreamPlayer.new()
@onready var _music_bus := AudioServer.get_bus_index(&"Music")
@onready var _default_volume_db := AudioServer.get_bus_volume_db(_music_bus)

func _ready() -> void:
	_player.bus = &"Music"
	set_volume(_vol)
	add_child(_player)
	_player.stream = MUSIC_INTERACTIVE_STREAM

func toggle_mute() -> void:
	set_mute(not _mute)
	
func set_mute(m: bool) -> void:
	_mute = m
	AudioServer.set_bus_mute(_music_bus, _mute)

func is_mute() -> bool:
	return _mute

func set_volume(level: Volume) -> void:
	set_mute(false)
	_vol = level
	match level:
		Volume.HIGH:
			AudioServer.set_bus_volume_db(_music_bus, _default_volume_db)
		Volume.LOW:
			AudioServer.set_bus_volume_db(_music_bus, _default_volume_db - 9.0)

func start_game_music() -> void:
	print("Game music started")
	_player.play()

func stop_music() -> void:
	_player.stop()

func stop_intro() -> void:
	await get_tree().process_frame
	(_player.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip(1)
	
func intro_to_small() -> void:
	MUSIC_INTERACTIVE_STREAM.add_transition(0, 1, AudioStreamInteractive.TRANSITION_FROM_TIME_IMMEDIATE, 
	AudioStreamInteractive.TRANSITION_TO_TIME_START, AudioStreamInteractive.FADE_CROSS, 4)
	(_player.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip(1)

func small_to_medium() -> void:
	MUSIC_INTERACTIVE_STREAM.add_transition(1, 2, AudioStreamInteractive.TRANSITION_FROM_TIME_IMMEDIATE, 
	AudioStreamInteractive.TRANSITION_TO_TIME_START, AudioStreamInteractive.FADE_CROSS, 4)
	(_player.get_stream_playback() as AudioStreamPlaybackInteractive).switch_to_clip(2)
	
