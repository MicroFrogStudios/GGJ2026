extends Camera2D


@export var following :Node2D


func _process(_delta: float) -> void:
	if following.position.y < 100:
		position = following.position
