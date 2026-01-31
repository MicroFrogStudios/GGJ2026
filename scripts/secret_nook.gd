extends Area2D


@onready var camera = gc.camera

var found_time := 0
var was_already_triggerd := false
var starting_camera_left := 0


func _ready() -> void:
	starting_camera_left = camera.limit_left


func _on_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter" or was_already_triggerd:
		return
	print("NOOK ", camera.limit_left)
	found_time = Time.get_ticks_msec()
	was_already_triggerd = true
	camera.limit_left = -286


func _process(_delta: float) -> void:
	if found_time == 0:
		return
	var time_since_found = Time.get_ticks_msec() - found_time
	camera.limit_left = starting_camera_left + (time_since_found / 1.0) * (-285 - starting_camera_left) / 1000.0
	# camera.limit_left = lerp(starting_camera_left, -285, time_since_found / 1000.0)
	if time_since_found >= 1000:
		found_time = 0
