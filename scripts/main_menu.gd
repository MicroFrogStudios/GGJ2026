extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$startbutton.grab_focus.call_deferred()
	pass


func _on_startbutton_pressed() -> void:
	print("Start Button Pressed")
	gc.load_next_scene()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
