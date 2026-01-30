extends Node2D


@export var mask_layer : int = 0


func on_mask_change(mask:int):
	visible = mask != mask_layer
