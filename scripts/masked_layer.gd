class_name MaskedTileMapLayer
extends TileMapLayer

## Layer 0 is always visible
@export var mask_number: int = 0

func _ready() -> void:
	if mask_number != 0:
		visible = false
		collision_enabled = false
