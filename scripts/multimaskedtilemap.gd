class_name MultiMaskedTileMap
extends Node2D

@export var player: PlayerCharacter

@onready var layers: Array[Node] = get_children().filter(is_masked_layer)


func is_masked_layer(child: Node) -> bool:
	return child is MaskedTileMapLayer


func _on_mask_changed(new_mask_number: int) -> void:
	for layer in layers:
		layer.visible = (new_mask_number == layer.mask_number)
		layer.collision_enabled = layer.visible


func _ready() -> void:
	if player.has_signal("change_mask"):
		player.connect("change_mask", Callable(self, "_on_mask_changed"))
