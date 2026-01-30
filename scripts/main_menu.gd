extends Control

@onready var start_button = $menu/startbutton
@onready var slider_settings = $Settings/volume/HSlider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus.call_deferred()
	


func _on_startbutton_pressed() -> void:
	print("Start Button Pressed")
	gc.start_game()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	
	
func _on_settingsbutton_pressed() -> void:
	$menu.visible = false;
	$Settings.visible = true
	slider_settings.grab_focus.call_deferred()


func _on_quit_settings_button_pressed() -> void:
	$menu.visible = true;
	$Settings.visible = false
	start_button.grab_focus.call_deferred()
