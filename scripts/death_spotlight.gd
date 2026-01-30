extends ColorRect


@onready var Character = %PlayerCharacter
@onready var EffectsAnimator = %EffectsAnimator


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Get normalized char position & set center
	var vp := get_viewport()
	var player_canvas_pos: Vector2 = Character.get_global_transform_with_canvas().origin
	var viewport_rect: Rect2 = vp.get_visible_rect()
	var center := (player_canvas_pos - viewport_rect.position) / viewport_rect.size	
	
	if center.y < 1.0:
		material.set_shader_parameter("center", center)


func _on_player_character_death() -> void:
	EffectsAnimator.stop()
	EffectsAnimator.play("spotlight_death")


func _on_exit_door_player_reached_exit() -> void:
	EffectsAnimator.stop()
	EffectsAnimator.play("spotlight_exit")
