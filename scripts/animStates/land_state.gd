extends State
class_name LandState


static func Name() -> String:
	return "land"


func Enter():
	player.anim.play("landing")
	player.is_jumping = false
	player.anim.speed_scale = 1
	player.anim.animation_finished.connect(on_anim_finished)


func Exit():
	player.anim.animation_finished.disconnect(on_anim_finished)


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if player.going_into_door:
		transitioned.emit(RunState.Name())
	if player.velocity.x != 0:
		transitioned.emit(RunState.Name())
	if Input.is_action_pressed("jump") and player.is_on_floor() and not player.control_disabled:
		transitioned.emit(JumpState.Name())


func on_anim_finished():
	transitioned.emit(IdleState.Name())
