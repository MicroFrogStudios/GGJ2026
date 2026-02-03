extends Sprite2D


@onready var player = gc.player


func _ready() -> void:
	player.change_mask.connect(on_mask_change)
	call_deferred("on_mask_change", player.mask)


func on_mask_change(mask:int):
	visible = mask == 0
