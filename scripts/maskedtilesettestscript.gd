extends Node2D

signal change_mask(new_mask_number: int)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_mask"):
		var new_mask = randi() % 3  # Random mask number between 0 and 2
		print("Changing mask", new_mask)
		change_mask.emit(new_mask)  # Random mask number between 0 and 2
