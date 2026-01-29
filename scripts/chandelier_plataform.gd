extends Node2D

@export var mask_layer :int = 0

@onready var collision :CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var sprite: TileMapLayer = $AnimatableBody2D/TileMapLayer
@onready var player :PlayerCharacter = %PlayerCharacter

func _ready() -> void:
	if mask_layer != 0:
		player.change_mask.connect(on_mask_change)
		call_deferred("on_mask_change",player.mask)
	
func on_mask_change(mask:int):
	
	
	sprite.enabled = mask == mask_layer
	collision.call_deferred("set_disabled", not sprite.enabled)
	
