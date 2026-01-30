extends Node

var player: AudioStreamPlayer
var current_track: AudioStream = null
var resume_from = null

var scene_music = {
	"MainMenu": "res://assets/music/Welcome to the masquerade.ogg",
	"Level1": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level2": "res://assets/music/Intermezzo 1.ogg",
	"Level_jaula": "res://assets/music/vibing.ogg",
	"Level4": "res://assets/music/Intermezzo 1.ogg",
	"Level5": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level6": "res://assets/music/vibing.ogg",
	"Level7": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level8": "res://assets/music/Intermezzo 1.ogg",
}


func _init():
	# Create the player immediately when the autoload is instantiated
	player = AudioStreamPlayer.new()
	player.autoplay = false
	add_child(player)


func play_music(scene_name : String):
	var track = null
	if scene_music.has(scene_name):
		track = load(scene_music[scene_name])
		print(track)
	if current_track == track:
		return # already playing
	current_track = track
	player.stream = track
	player.bus = "Music"
	player.play()


func set_music_volume(value: float):
	# value should be 0.0 - 1.0 
	var linear = max(value, 0.001)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),
	db)
	


func fade_music(to_db: float, duration := 0.3):
	var bus = AudioServer.get_bus_index("Music")
	var tween = create_tween()
	tween.tween_method(
		func(db): AudioServer.set_bus_volume_db(bus, db),
		AudioServer.get_bus_volume_db(bus),
		to_db,
		duration
	)


func stop_music():
	resume_from = player.get_playback_position()
	player.stop()


func resume_music():
	player.play(resume_from)
