extends Camera2D


@export var following :Node2D
@export var follow_speed := 5 


var initial_center : Vector2


func _ready() -> void:
	initial_center = get_screen_center_position()
	gc.camera = self


func _physics_process(delta: float) -> void:
	if following.position.y < 100:
		position = position.lerp(following.position - Vector2(0, 10), follow_speed*delta)
