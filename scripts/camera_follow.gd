extends Camera2D


@export var following :Node2D
@export var follow_speed := 100


func _process(delta: float) -> void:
	if following.position.y < 100:
		position = position.lerp(following.position, follow_speed*delta)
