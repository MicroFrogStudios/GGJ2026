extends Control

func _ready() -> void:
	gc.in_game_menu_instance = self

func _on_continue_button_pressed() -> void:
	print("continue")
	gc.close_in_game_menu()
	

func _on_quitbutton_pressed() -> void:
	print("quit")
	gc.close_in_game_menu()
	gc.load_main_menu()

func _on_settingsbutton_pressed() -> void:
	$Panel/Settings.visible = true
	$Panel/Main.visible = false

func _on_quit_settings_pressed() -> void:
	$Panel/Settings.visible = false
	$Panel/Main.visible = true
