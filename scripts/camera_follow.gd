extends Camera2D

@export var following :Node2D
@export var follow_speed := 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position = position.lerp(following.position,follow_speed*delta)
