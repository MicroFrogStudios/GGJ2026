extends State
class_name BowState


static func Name() -> String:
	return "bow"


func Enter():
	player.anim.play("bow")
	player.is_jumping = false
	player.anim.speed_scale = 1
	player.anim.animation_finished.connect(on_anim_finished)


func Exit():
	player.anim.animation_finished.disconnect(on_anim_finished)
	player.PlayerAnimations.play("enter_door")

func on_anim_finished():
	transitioned.emit(RunState.Name())
