class_name IdleState
extends State


static func Name() -> String:
	return "idle"


func Enter():
	player.anim.play("idle")
	player.anim.speed_scale = 1


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if player.velocity.x != 0:
		transitioned.emit(RunState.Name())
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not player.control_disabled:
		transitioned.emit(JumpState.Name())
	if not player.is_on_floor():
		transitioned.emit(FallState.Name())
