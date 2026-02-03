extends Control

@onready var change_player = $ChangePlayer

var ignore_first_focus := true

func _ready() -> void:
	gc.in_game_menu_instance = self


func _on_continue_button_pressed() -> void:
	print("continue")
	gc.close_in_game_menu()


func gain_focus():
	$Panel/Settings.visible = false
	$Panel/Main.visible = true
	await get_tree().process_frame
	$Panel/Main/ContinueButton.grab_focus.call_deferred()


func _on_quit_button_pressed() -> void:
	print("quit")
	gc.close_in_game_menu()
	gc.load_main_menu()


func _on_settingsbutton_pressed() -> void:
	ignore_first_focus = true
	$Panel/Settings.visible = true
	$Panel/Main.visible = false
	$Panel/Settings/volume/HSlider.grab_focus.call_deferred()


func _on_quit_settings_pressed() -> void:
	ignore_first_focus = true
	$Panel/Settings.visible = false
	$Panel/Main.visible = true
	$Panel/Main/ContinueButton.grab_focus.call_deferred()
	
func _on_focus_entered() -> void:
	if ignore_first_focus:
		ignore_first_focus = false
		return
	change_player.play()
