extends Node2D


func change_scene(next_level_path: String) -> void:
	get_tree().change_scene_to_file(next_level_path)


func _on_door_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		print("Player has reached the exit door!")
		var current_level_name = get_tree().current_scene.name
		print("Current level: ", current_level_name)
		var level_prefix = current_level_name.split("_")[0]
		var level_number = int(current_level_name.split("_")[1])
		var next_level_name = level_prefix + "_" + str(level_number + 1)
		print("Loading next level: ", next_level_name)

		# Check that the next level exists
		var next_level_path = "res://scenes/levels/" + next_level_name + ".tscn"
		if ResourceLoader.exists(next_level_path):
			call_deferred("change_scene", next_level_path)
		else:
			print("Next level does not exist. Game completed!")
			print(next_level_path)
		# get_tree().change_scene_to_file("res://scenes/next_level.tscn")
