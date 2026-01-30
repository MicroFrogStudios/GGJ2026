extends Node2D

@export var mask_layer : int = 0

@onready var collision : CollisionShape2D = $Hitbox/CollisionShape2D
@onready var player : PlayerCharacter = gc.player


func _ready() -> void:
	if mask_layer != 0:
		player.change_mask.connect(on_mask_change)
		call_deferred("on_mask_change", player.mask)


func on_mask_change(mask:int):
	var disabled = mask != mask_layer and mask_layer != 0
	visible = not disabled
	collision.call_deferred("set_disabled", disabled)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	print("Trampolin hit ", body.velocity.y, " ")
	if body.velocity.y > 0 and body.velocity.y < 400:
		body.velocity.y = clamp(-800, -body.velocity.y * 0.8,  0)


func _on_speedy_hitbox_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	print("Trampolin hit ", body.velocity.y, " ")
	if body.velocity.y > 400:
		body.velocity.y = clamp(-800, -body.velocity.y * 0.8,  0)
