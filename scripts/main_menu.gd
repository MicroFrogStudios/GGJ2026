extends Control

@onready var start_button = $menu/startbutton
@onready var slider_settings = $Settings/volume/HSlider
@onready var change_option_player = $ChangeOptionPlayer

var ignore_first_focus := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus.call_deferred()
	var is_mobile = OS.has_feature("web_ios") or OS.has_feature("web_android")
	if is_mobile:
		$menu/settingsbutton.visible = false
	


func _on_startbutton_pressed() -> void:
	print("Start Button Pressed")
	gc.start_game()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	
	
func _on_settingsbutton_pressed() -> void:
	ignore_first_focus = true
	$menu.visible = false;
	$Settings.visible = true
	slider_settings.grab_focus.call_deferred()


func _on_quit_settings_button_pressed() -> void:
	$menu.visible = true;
	$Settings.visible = false
	start_button.grab_focus.call_deferred()


func _on_focus_entered() -> void:
	if ignore_first_focus:
		ignore_first_focus = false
		return
	change_option_player.play()
