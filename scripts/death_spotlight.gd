extends ColorRect


@onready var Character = %PlayerCharacter
@onready var EffectsAnimator = get_parent().get_node("EffectsAnimator")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Get normalized char position & set center
	var player_transform: Transform2D = Character.get_global_transform_with_canvas()
	var player_viewport_pos = player_transform.origin
	var viewport_size: Vector2 = get_viewport().size
	var normalized_char_pos: Vector2 = Vector2(
		2 * player_viewport_pos.x / viewport_size.x,
		2 * player_viewport_pos.y / viewport_size.y,
	)
	if normalized_char_pos.y < 1.0:
		material.set_shader_parameter("center", normalized_char_pos)


func _on_player_character_death() -> void:
	EffectsAnimator.play("spotlight_death")
