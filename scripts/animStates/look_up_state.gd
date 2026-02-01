extends State
class_name LookUpState


var delay = 500.0
var start_state := 0.0

static func Name() -> String:
	return "look_up"


func Enter():
	start_state = Time.get_ticks_msec()
func Exit():
	gc.camera.look_offset = 0

func Physics_Update(_delta: float):
	
	if player.going_into_door:
		transitioned.emit(RunState.Name())
	if player.jump_action():
		transitioned.emit(JumpState.Name())
		return
		
	if Time.get_ticks_msec() -start_state > delay:
		var direction_y :=Input.get_axis("ui_up", "ui_down")
		gc.camera.look_offset = -direction_y * 70
	
	if player.velocity.x != 0:
		transitioned.emit(RunState.Name())
	


func on_anim_finished():
	transitioned.emit(IdleState.Name())
