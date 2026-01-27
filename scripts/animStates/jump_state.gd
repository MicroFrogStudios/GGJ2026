extends State
class_name JumpState


static func Name() -> String:
	return "jump"

func Enter():
	player.anim.speed_scale = 1
	player.anim.play("jumping")
	player.anim.animation_finished.connect(on_anim_finished)
func Exit():
	player.anim.animation_finished.disconnect(on_anim_finished)
	player.velocity.y = player.jump_velocity
	player.is_jumping = true
	
func Update(_delta: float):
	pass
func Physics_Update(_delta: float):
	pass

func on_anim_finished():
	transitioned.emit(FallState.Name())
	
