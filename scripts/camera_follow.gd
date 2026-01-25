extends Camera2D


@export var following :Node2D
@export var follow_speed := 100


func _process(delta: float) -> void:
	position = position.lerp(following.position, follow_speed*delta)
