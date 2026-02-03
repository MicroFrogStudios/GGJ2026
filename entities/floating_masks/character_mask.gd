extends Node2D


@export var follow_speed := 120
@export var player : PlayerCharacter
@export var mask_dict : Dictionary[int,CompressedTexture2D]


@onready var sprite : Sprite2D = $MaskSprite
@onready var player_sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")


func _ready() -> void:
	player.change_mask.connect(on_mask_changed)

	
func on_mask_changed(new_mask :int):
	sprite.texture = mask_dict[new_mask]


func _physics_process(_delta: float) -> void:
	var facing_left = player_sprite.flip_h
	var time = Time.get_ticks_msec()
	var variance = Vector2(15, 0) + sin(time / 200.0) * Vector2(0, 3) + cos(time / 300.0) * Vector2(2, 0)
	var target_position = player.position + (1 if facing_left else -1) * variance
	position = position.lerp(target_position, 0.1)
