extends Control


@export var mask_textures : Dictionary[int,CompressedTexture2D]
@export var mask_names : Dictionary[int,String]


func _on_mask_pickup_got_mask(mask_number: int) -> void:
	$Label.text = "You got " + mask_names[mask_number] + "'s mask!\n Use J and K to reveal\nwhat is hidden."
	$TextureRect2.texture = mask_textures[mask_number]
	visible = true


func _on_mask_pickup_finished_pickup() -> void:
	visible = false
