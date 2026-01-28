extends AnimatableBody2D


@onready var sprites :Array[Sprite2D] = [$Sprite1,$Sprite2]
@onready var colliders: Array[CollisionShape2D] =[$CollisionShape1,$CollisionShape2]
func _ready() -> void:
	var player :PlayerCharacter = %PlayerCharacter
	player.change_mask.connect(on_mask_change)
	call_deferred("on_mask_change",player.mask)
	pass

func on_mask_change(mask_num :int):
	for i in range(2):
		sprites[i].visible = mask_num == i+1
		colliders[i].disabled = not sprites[i].visible
		colliders[i].call_deferred("set_disabled",not sprites[i].visible)
		

	
		
	
