extends State
class_name TurnState

static func Name() -> String:
	return "turn"


func Enter():
	player.anim.speed_scale = 1
	player.anim.play("turning")


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if player.velocity.x == 0:
		transitioned.emit(IdleState.Name())
	if Input.is_action_just_pressed("jump") and player.is_on_floor() and not player.control_disabled:
		transitioned.emit(JumpState.Name())
	var direction_x :=Input.get_axis("move_left", "move_right")
	if direction_x * player.velocity.x > 0:
		transitioned.emit((RunState.Name()))
