extends State
class_name StateEnemyFollow

@export var speed := 10.0

static func Name() -> String:
	return "EnemyFollow"


func Update(_delta: float):
	context.parent.position = context.parent.position.move_toward(%knight.position,_delta*speed)
	if context.parent.position.distance_to(%knight.position) > 200:
		transitioned.emit(StateEnemyWander.Name())
