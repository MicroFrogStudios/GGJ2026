extends Control


func _on_continue_button_pressed() -> void:
	gc.close_in_game_menu()


func _on_quitbutton_pressed() -> void:
	gc.load_main_menu()

func _on_settingsbutton_pressed() -> void:
	$Panel/Settings.visible = true
	$Panel/Main.visible = false

func _on_quit_settings_pressed() -> void:
	$Panel/Settings.visible = false
	$Panel/Main.visible = true
