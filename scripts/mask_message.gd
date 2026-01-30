extends Control


@export var mask_textures : Dictionary[int,CompressedTexture2D]
@export var mask_names : Dictionary[int,String]


func _on_mask_pickup_got_mask(mask_number: int) -> void:
	$Label2.text = mask_names[mask_number]
	$TextureRect2.texture = mask_textures[mask_number]
	visible = true


func _on_mask_pickup_finished_pickup() -> void:
	visible = false
