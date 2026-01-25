extends Node2D

@export var mask_number = 1


@onready var mask_collision_shape: CollisionShape2D = $MaskArea2D/CollisionShape2D


signal got_mask(mask_number: int)


func _on_mask_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		print("Player has gotten mask!")
		got_mask.emit(mask_number)
		mask_collision_shape.disabled = true
		# TODO remove item and play anim or something
