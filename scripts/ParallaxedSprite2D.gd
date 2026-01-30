class_name ParallaxedSprite2D
extends Sprite2D


@onready var Camera = %CameraFollow


@export var parallax_factor: Vector2 = Vector2(1.0, 1.0)


var original_position: Vector2


func _ready() -> void:
	original_position = position


func _process(_delta: float) -> void:
	var camera_center = Camera.get_screen_center_position()
	var camera_displacement = camera_center - Camera.initial_center
	position = original_position + camera_displacement * parallax_factor
