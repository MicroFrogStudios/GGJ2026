extends Node2D


@export var mask_number = 1
@export var mask_texture : Texture2D

@onready var mask_collision_shape: CollisionShape2D = $MaskArea2D/CollisionShape2D

var initial_position: Vector2

signal got_mask(mask_number: int)


func _ready() -> void:
	initial_position = position
	$Sprite2D.texture = mask_texture
	$Sprite2D/SpriteAura.texture = mask_texture


func disable_mask() -> void:
	visible = false
	mask_collision_shape.disabled = true
	# TODO play anim or something


func _on_mask_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		print("Player has gotten mask!")
		got_mask.emit(mask_number)
		call_deferred("disable_mask")


func _physics_process(_delta: float) -> void:
	var time = Time.get_ticks_msec()
	var variance = sin(time / 400.0) * Vector2(0, 3)
	position = initial_position + variance
