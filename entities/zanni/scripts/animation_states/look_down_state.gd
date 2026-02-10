extends State
class_name LookDownState


var delay = 500.0
var start_state := 0.0

static func Name() -> String:
	return "look_down"


func Enter():
	player.anim.play("look_down")
	
	start_state = Time.get_ticks_msec()
func Exit():
	gc.camera.look_offset = 0

func Physics_Update(_delta: float):
	
	if player.going_into_door:
		transitioned.emit(RunState.Name())
	if player.jump_action():
		transitioned.emit(JumpState.Name())
		return
	
		
	
	var direction_y :=Input.get_axis("ui_up", "ui_down")
	if direction_y < 0:
		transitioned.emit(LookUpState.Name())
		return
	elif direction_y > 0 and Time.get_ticks_msec() -start_state > delay:
		gc.camera.look_offset = -direction_y * 70
	elif direction_y == 0:
		transitioned.emit(IdleState.Name())
	
	if player.velocity.x != 0:
		transitioned.emit(RunState.Name())
	
