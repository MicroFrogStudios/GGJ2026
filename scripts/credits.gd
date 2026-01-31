extends Control

@onready var quit_button = $menu/quitbutton


func _on_quitbutton_pressed() -> void:
	gc.load_main_menu()


func _ready() -> void:
	quit_button.grab_focus.call_deferred()
