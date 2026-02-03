extends Sprite2D

var initial_pos_y := 0.0


func _ready() -> void:
	initial_pos_y = position.y


func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec()
	var variance = sin(time / 900.0) * 5.0
	position.y = initial_pos_y + variance
