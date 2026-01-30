extends Node


var resolutions = [
	Vector2i(3440, 1440),
	Vector2i(2560, 1440),
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(800, 600)
]


func _ready() -> void:
	var option_button = $OptionButton
	option_button.clear()
	for res in resolutions:
		option_button.add_item("%d x %d" % [res.x, res.y])


func _on_OptionButton_item_selected(index: int) -> void:
	var new_resolution = resolutions[index]	
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(new_resolution)
		
	print("Resolution changed to %s x %s" % [new_resolution.x, new_resolution.y])
	

func _on_check_box_toggled(_toggled_on: bool) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_quitbutton_pressed() -> void:
	gc.go_back()


func _on_h_slider_value_changed(value: float) -> void:
	var normalized = value / 100.0
	music_manager.set_music_volume(normalized)
