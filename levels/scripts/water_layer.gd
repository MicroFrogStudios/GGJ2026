extends TileMapLayer


@export var is_bg := false


var base_position : Vector2


var period_modifier := 800.0 # Higher is slower


func _ready() -> void:
	base_position = position


func _process(_delta: float) -> void:
	var period_offset = 0.0 if not is_bg else period_modifier / 2.0
	var x_disp = cos(Time.get_ticks_msec() / period_modifier + period_offset) * 8.0
	var y_disp = sin(Time.get_ticks_msec() / period_modifier + period_offset) * 3.0
	position = base_position + Vector2(x_disp, y_disp)
