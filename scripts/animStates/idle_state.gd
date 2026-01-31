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
	if player.jump_action():
		transitioned.emit(JumpState.Name())
	if not player.is_on_floor():
		transitioned.emit(FallState.Name())
