extends Node2D


@export var mask_layer : int = 0
@export var down_speed : float = 30.0
@export var up_speed : float = 20.0
@export var max_descent : float = 50.0

@onready var collision : CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var sprite : TileMapLayer = $CharacterBody2D/MaskedTileMapLayer
@onready var player : PlayerCharacter = gc.player


var initial_y_position : float = 0.0
var is_descending := false


func _ready() -> void:
	initial_y_position = position.y
	sprite.mask_number = mask_layer
	if mask_layer != 0:
		player.change_mask.connect(on_mask_change)
		call_deferred("on_mask_change", player.mask)
	

func on_mask_change(mask:int):
	sprite.visible = mask == mask_layer
	collision.call_deferred("set_disabled", not sprite.visible)


func _physics_process(delta: float) -> void:
	if is_descending and position.y < initial_y_position + max_descent:
		position.y += down_speed * delta
	if not is_descending and position.y > initial_y_position:
		position.y -= up_speed * delta


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.name == "PlayerCharacter":
		is_descending = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _body.name == "PlayerCharacter":
		is_descending = false
