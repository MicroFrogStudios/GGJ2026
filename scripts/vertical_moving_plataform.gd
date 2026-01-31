extends Node2D


@export var mask_layer : int = 0
@export var movement_offset := 0

@onready var collision : CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var player : PlayerCharacter = gc.player
@onready var chain : TileMapLayer = $CharacterBody2D/CollisionShape2D/Chain
@onready var sprite : TileMapLayer = $CharacterBody2D/MaskedTileMapLayer

var initial_y_position : float = 0.0
var coll_sprite_diff : float = 0.0
var time_count : float = 0

func _ready() -> void:
	initial_y_position = collision.position.y
	sprite.mask_number = mask_layer
	var round_x = round(position.x)
	var round_y = round(position.y)
	sprite.parent_offset = Vector2i(round_x, round_y)
	coll_sprite_diff = sprite.position.y - collision.position.y
	if mask_layer != 0:
		player.change_mask.connect(on_mask_change)
		call_deferred("on_mask_change", player.mask)
	

func on_mask_change(mask:int):
	sprite.visible = mask == mask_layer
	chain.visible = sprite.visible
	collision.call_deferred("set_disabled", not sprite.visible)


func _physics_process(_delta: float) -> void:
	time_count+= _delta
	 #collision.position.y = initial_y_position + sin((Time.get_ticks_msec()- pause_offset) / 500.0 + movement_offset ) * 10.0
	print(time_count)
	collision.position.y = initial_y_position + sin(time_count*2 + movement_offset ) * 10.0
	sprite.position.y = collision.position.y + coll_sprite_diff
