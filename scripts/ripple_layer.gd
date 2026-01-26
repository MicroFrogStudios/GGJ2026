extends ColorRect


@onready var Character = %PlayerCharacter
@onready var EffectsAnimator = %EffectsAnimator


func _on_player_mask_change(_new_mask_number: int) -> void:
	if EffectsAnimator.is_playing():
		EffectsAnimator.seek(0.0)
		return
	EffectsAnimator.play("mask_ripple")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Character.connect("change_mask", Callable(self, "_on_player_mask_change"))
