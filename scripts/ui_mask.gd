extends TextureRect


@export var mask_number: int = 0


@onready var GameUi = get_parent().get_parent()


func _on_change_mask(new_mask_number: int) -> void:
	if new_mask_number == mask_number:
		visible = true
		modulate.a = 1.0
	else:
		modulate.a = 0.5

func _on_mask_acquired(acquired_mask_number: int) -> void:
	if mask_number == 0:
		visible = true
	if acquired_mask_number == mask_number:
		visible = true


func _ready() -> void:
  # Connect to mask change signal
	var player_character = GameUi.player_character
	player_character.connect("change_mask", Callable(self, "_on_change_mask"))
	player_character.connect("mask_acquired", Callable(self, "_on_mask_acquired"))

	var num_masks = player_character.num_masks
	if num_masks == 0:
		visible = false
	if mask_number > num_masks:
		visible = false

	if mask_number != player_character.mask:
		# CHange opacity
		modulate.a = 0.5
