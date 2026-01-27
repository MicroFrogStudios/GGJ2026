extends State
class_name FallState


static func Name() -> String:
	return "fall"


func Enter():
	pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if player.velocity.y > 0:
		player.anim.play("falling")
	else:
		player.anim.play("going_up_air")
	if player.is_on_floor():
		transitioned.emit(LandState.Name())
