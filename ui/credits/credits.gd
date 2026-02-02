extends Control


@onready var quit_button = $menu/quitbutton
@onready var timer_label = $Control3/Timer
@onready var clock_sprite = $Control3/Sprite2D


func _on_quitbutton_pressed() -> void:
	gc.load_main_menu()


func _ready() -> void:
	# Set final time
	var time_secs = Time.get_ticks_msec() - gc.game_start_time
	if time_secs < 59 * 60 * 1000:
		var minutes = int(time_secs / (60 * 1000))
		var seconds = int(time_secs / 1000) % 60
		var milliseconds = int(time_secs) % 1000
		timer_label.text = "%d:%02d.%03d" % [minutes, seconds, milliseconds]
		quit_button.grab_focus.call_deferred()
	else:
		timer_label.text = ""
		clock_sprite.visible = false
	quit_button.grab_focus.call_deferred()
