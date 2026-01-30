extends Control

func _ready() -> void:
	gc.in_game_menu_instance = self

func _on_continue_button_pressed() -> void:
	print("continue")
	gc.close_in_game_menu()
	
func gain_focus():
	$Panel/Main/ContinueButton.grab_focus.call_deferred()

func _on_quitbutton_pressed() -> void:
	print("quit")
	gc.close_in_game_menu()
	gc.load_main_menu()

func _on_settingsbutton_pressed() -> void:
	$Panel/Settings.visible = true
	$Panel/Main.visible = false
	$Panel/Settings/volume/HSlider.grab_focus.call_deferred()

func _on_quit_settings_pressed() -> void:
	$Panel/Settings.visible = false
	$Panel/Main.visible = true
	$Panel/Main/ContinueButton.grab_focus.call_deferred()
