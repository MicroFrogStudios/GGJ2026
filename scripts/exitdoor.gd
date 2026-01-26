extends Node2D


@export var next_scene : String


func _on_door_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		print("Player has reached the exit door!")
		gc.load_next_scene()

		
