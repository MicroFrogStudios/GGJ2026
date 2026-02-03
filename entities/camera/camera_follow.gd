extends Camera2D


@export var following :Node2D
@export var follow_speed := 5 
@export var effects : AnimationPlayer

var initial_center : Vector2
var look_offset := 0.0

func _ready() -> void:
	initial_center = get_screen_center_position()
	gc.camera = self


func _physics_process(delta: float) -> void:
	if following.position.y < 100:
		position = position.lerp(following.position - Vector2(0, 10 + look_offset ), follow_speed*delta)
