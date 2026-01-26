extends ColorRect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(' wat ', material.shader)
	material.shader.get_shader_parameter("center")
