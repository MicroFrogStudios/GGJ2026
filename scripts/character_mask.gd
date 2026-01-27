extends Node2D

@export var follow_speed := 200
@export var player : PlayerCharacter
@export var mask_dict :Dictionary[int,CompressedTexture2D]
@onready var sprite :Sprite2D = $MaskSprite

func _ready() -> void:
	player.change_mask.connect(on_mask_changed)
	
func on_mask_changed(new_mask :int):
	sprite.texture = mask_dict[new_mask]

func _physics_process(delta: float) -> void:
	position = position.move_toward(player.position,follow_speed*delta)
