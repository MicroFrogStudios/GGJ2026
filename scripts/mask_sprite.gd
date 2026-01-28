extends Sprite2D


@onready var mask_pickup : Node = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = mask_pickup.mask_texture
