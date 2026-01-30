extends Node2D


@export var mask_layer : int = 0
@export var movement_offset := 0

@onready var collision : CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var sprite : Sprite2D = $CharacterBody2D/CollisionShape2D/Sprite2D
@onready var player : PlayerCharacter = %PlayerCharacter
@onready var chain : TileMapLayer = $CharacterBody2D/CollisionShape2D/Chain

var initial_y_position : float = 0.0


func _ready() -> void:
	initial_y_position = collision.position.y
	if mask_layer != 0:
		player.change_mask.connect(on_mask_change)
		call_deferred("on_mask_change", player.mask)
	

func on_mask_change(mask:int):
	sprite.visible = mask == mask_layer
	chain.visible = sprite.visible
	collision.call_deferred("set_disabled", not sprite.visible)


func _physics_process(_delta: float) -> void:
	collision.position.y = initial_y_position + sin(Time.get_ticks_msec() / 500.0 + movement_offset) * 10.0
	
