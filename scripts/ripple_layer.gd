extends ColorRect


@onready var Character = %PlayerCharacter
@onready var EffectsAnimator = %EffectsAnimator


func _on_player_mask_change(_new_mask_number: int) -> void:

	# Get normalized char position & set center
	var player_transform: Transform2D = Character.get_global_transform_with_canvas()
	var player_viewport_pos = player_transform.origin
	var viewport_size: Vector2 = get_viewport().size
	var normalized_char_pos: Vector2 = Vector2(
		4 * player_viewport_pos.x / viewport_size.x,
		4 * player_viewport_pos.y / viewport_size.y,
	)
	material.set_shader_parameter("center", normalized_char_pos)

	if EffectsAnimator.is_playing():
		EffectsAnimator.seek(0.0)
		return
	EffectsAnimator.play("mask_ripple")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Character.connect("change_mask", Callable(self, "_on_player_mask_change"))
