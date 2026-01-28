extends Node2D


signal player_reached_exit()


func _on_door_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_reached_exit.emit()
		$victory_particles.emitting = true
		$victory_particles2.emitting = true

func go_to_next_level() -> void:
	gc.load_next_scene()
