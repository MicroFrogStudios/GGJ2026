extends Node2D

# Called when the node enters the scene tree for the first time.

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim_sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	
