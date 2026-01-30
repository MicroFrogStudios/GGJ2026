class_name ParallaxedSprite2D
extends Sprite2D


@onready var PlayerChar = %PlayerCharacter


@export var parallax_factor: Vector2 = Vector2(1.0, 1.0)


var original_position: Vector2


func _ready() -> void:
	original_position = position


func _process(_delta: float) -> void:
	var char_displacement = PlayerChar.position - PlayerChar.spawn_position
	position = original_position + char_displacement * parallax_factor
