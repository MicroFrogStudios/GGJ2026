extends State
class_name PushState


static func Name() -> String:
	return "push"


func Enter():
	player.anim.play("push")


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	
		
	if player.jump_action():
		transitioned.emit(JumpState.Name())
		return
	
	if not player.is_pushing_box:
		transitioned.emit(IdleState.Name())
		
	if not player.is_on_floor():
		transitioned.emit(FallState.Name())
	
