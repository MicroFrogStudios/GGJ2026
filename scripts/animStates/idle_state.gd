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
	if player.jump_action():
		transitioned.emit(JumpState.Name())
		return
	if player.velocity.x != 0:
		transitioned.emit(RunState.Name())
		return
	var direction_y :=Input.get_axis("ui_up", "ui_down")
	if direction_y != 0:
		transitioned.emit(LookUpState.Name())
		return
	if not player.is_on_floor():
		transitioned.emit(FallState.Name())
