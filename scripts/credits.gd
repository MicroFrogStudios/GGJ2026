extends Control

@onready var quit_button = $menu/quitbutton
@onready var timer_label = $Control3/Timer
@onready var clock_sprite = $Control3/Sprite2D


func _on_quitbutton_pressed() -> void:
	gc.load_main_menu()


func _ready() -> void:
	var time_secs = Time.get_ticks_msec() / 1000.0 - gc.game_start_time
	if time_secs < 59*60:
		var minutes = int(time_secs) / 60
		var seconds = int(time_secs) % 60
		timer_label.text = "%d:%02d" % [minutes, seconds]
		quit_button.grab_focus.call_deferred()
	else:
		timer_label.text = ""
		clock_sprite.visible = false
