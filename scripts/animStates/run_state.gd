extends State
class_name RunState


static func Name() -> String:
	return "run"


func Enter():
	player.anim.play("run")


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if not player.going_into_door:
		player.anim.speed_scale = player.velocity.x/100
	else:
		player.anim.speed_scale = 1

	if player.velocity.x == 0 and not player.going_into_door:
		transitioned.emit(IdleState.Name())
	if Input.is_action_pressed("jump") and player.is_on_floor() and not player.control_disabled:
		transitioned.emit(JumpState.Name())
	var direction_x :=Input.get_axis("move_left", "move_right")
	if direction_x * player.velocity.x < 0:
		transitioned.emit((TurnState.Name()))
