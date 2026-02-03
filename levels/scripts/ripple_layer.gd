extends ColorRect


@onready var Character = %PlayerCharacter
@onready var EffectsAnimator = %EffectsAnimator


func _on_player_mask_change(_new_mask_number: int) -> void:
	# Get normalized char position & set center
	var vp := get_viewport()
	var player_canvas_pos: Vector2 = Character.get_global_transform_with_canvas().origin
	var viewport_rect: Rect2 = vp.get_visible_rect()
	var center := (player_canvas_pos - viewport_rect.position) / viewport_rect.size	
	
	material.set_shader_parameter("center", center)

	if EffectsAnimator.is_playing():
		EffectsAnimator.seek(0.0)
		return
	EffectsAnimator.play("mask_ripple")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Character.connect("change_mask", Callable(self, "_on_player_mask_change"))
