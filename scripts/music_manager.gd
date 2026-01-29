extends Node

var player: AudioStreamPlayer
var current_track: AudioStream = null

var scene_music = {
	"MainMenu": "res://assets/music/Welcome to the masquerade.ogg",
	"Level1": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level2": "res://assets/music/Intermezzo 1.ogg",
	"Level_jaula": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level4": "res://assets/music/Intermezzo 1.ogg",
	"Level5": "res://assets/music/Zenni's theme (ambient 2).ogg",
	"Level6": "res://assets/music/Intermezzo 1.ogg",
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
	player.play()
