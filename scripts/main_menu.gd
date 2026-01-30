extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$menu/startbutton.grab_focus.call_deferred()
	pass


func _on_startbutton_pressed() -> void:
	print("Start Button Pressed")
	gc.start_game()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	
func _on_settingsbutton_pressed() -> void:
	$menu.visible = false;
	$Settings.visible = true


func _on_quit_settings_button_pressed() -> void:
	$menu.visible = true;
	$Settings.visible = false
