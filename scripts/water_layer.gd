extends TileMapLayer


var base_position : Vector2


var period_modifier := 800.0 # Higher is slower


func _ready() -> void:
	base_position = position


func _process(_delta: float) -> void:
	var x_disp = cos(Time.get_ticks_msec() / period_modifier) * 8.0
	var y_disp = sin(Time.get_ticks_msec() / period_modifier) * 3.0
	position = base_position + Vector2(x_disp, y_disp)
