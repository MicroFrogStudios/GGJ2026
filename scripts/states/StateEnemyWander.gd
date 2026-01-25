extends State
class_name StateEnemyWander

@export var distance_to_follow := 30
static func Name() -> String:
	return "EnemyWander"
	
func Update(_delta: float):
	
	
	if context.parent.position.distance_to(%knight.position)< distance_to_follow:
		transitioned.emit(StateEnemyFollow.Name())
