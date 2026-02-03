extends Node

var player: AudioStreamPlayer
var current_track: AudioStream = null
var resume_from = null

var scene_music = {
	"MainMenu": "res://audio/music/Welcome to the masquerade.ogg",
	"Level1": "res://audio/music/Zenni's theme (ambient 2).ogg",
	"Level2": "res://audio/music/Intermezzo 1.ogg",
	"Level3": "res://audio/music/vibing.ogg",
	"Level4": "res://audio/music/Zenni's theme (ambient 2).ogg",
	"Level5_2": "res://audio/music/vibing.ogg",
	"Level5": "res://audio/music/Zenni's theme (ambient 2).ogg",
	"Level6": "res://audio/music/Intermezzo 1.ogg",
	"Level7": "res://audio/music/Ballroom dance (Boss fight).ogg",
	"Level8": "res://audio/music/Ballroom dance (Boss fight).ogg",
	"Credits": "res://audio/music/Welcome to the masquerade.ogg"
}


func _init():
	# Create the player immediately when the autoload is instantiated
	player = AudioStreamPlayer.new()
	player.autoplay = false
	add_child(player)
	set_music_volume(0.4)

func play_music(scene_name : String):
	var track = null
	if scene_music.has(scene_name):
		track = load(scene_music[scene_name])
		print(track)
	else:
		print("No music track for scene: " + scene_name)
		track = load(scene_music["MainMenu"]) # default track
	if current_track == track:
		stop_music()
		resume_music()
		return # already playing
	current_track = track
	player.stream = track
	player.bus = "Music"
	player.play()


func set_music_volume(value: float):
	# value should be 0.0 - 1.0 
	var linear = max(value, 0.001)
	var db = linear_to_db(linear)
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
