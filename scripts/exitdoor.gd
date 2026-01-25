extends Node2D


@export var next_scene : String


func change_scene() -> void:
	get_tree().change_scene_to_file(next_scene)


func _on_door_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		print("Player has reached the exit door!")
		var current_level_name = get_tree().current_scene.name
		print("Current level: ", current_level_name)
		
		call_deferred("change_scene")
		
