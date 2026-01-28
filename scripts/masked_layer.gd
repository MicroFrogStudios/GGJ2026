class_name MaskedTileMapLayer
extends TileMapLayer


## Layer 0 is always visible
@export var mask_number: int = 0


@onready var PlayerChar = %PlayerCharacter
@onready var tileset = tile_set
@onready var multimask = get_parent()


func _ready() -> void:
	if mask_number != 0:
		visible = false
		collision_enabled = false


func _use_tile_data_runtime_update(_coords: Vector2i) -> bool:
	# This is commented because we could use it to make it more performant,
	# but it probably isn't worth it
	# if mask_number == 0:
	# 	return false
	# if mask_number != PlayerChar.mask:
	# 	return false
	# var player_pos = PlayerChar.position
	# var tilemap_pos = Vector2i(multimask.position.x, multimask.position.y)
	# var global_coords = tilemap_pos + coords * tile_set.tile_size
	# var distance = player_pos.distance_to(global_coords)
	# if distance > PlayerChar.mask_radius:
	# 	return true
	return true

# Starting from the player and for the exported radius, hide tiles beyond it
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if not PlayerChar.is_changing_mask:
		return
	var player_pos = PlayerChar.position
	var tilemap_pos = Vector2i(multimask.position.x, multimask.position.y)
	var global_coords = tilemap_pos + coords * tile_set.tile_size
	var distance = player_pos.distance_to(global_coords)
	if distance > PlayerChar.mask_radius:
		tile_data.modulate.a = 0.0
	else:
		tile_data.modulate.a = 1.0

func _process(_delta: float) -> void:
	if mask_number == 0:
		return
	if mask_number != PlayerChar.mask:
		return
	if not PlayerChar.is_changing_mask:
		return
	notify_runtime_tile_data_update()
