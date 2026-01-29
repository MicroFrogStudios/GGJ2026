extends AudioStreamPlayer

@export var notes :Array[AudioStreamMP3];
var current_note : int = 0 

func play_next():
	stream = notes[current_note]
	play(0)
	current_note = (current_note + 1) % notes.size()
