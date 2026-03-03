@tool
extends TextureButton

@export var text :String:
	get:
		if is_node_ready():
			return rich_text_label.text
		return ""
	set(value):
		if is_node_ready():
			rich_text_label.text = value
		
		
@export var font_size : int:
	get:
		if is_node_ready():
			return rich_text_label.get_theme_font_size("normal_font_size")
		return 0
	set(value):
		if is_node_ready():
			rich_text_label.add_theme_font_size_override("normal_font_size",value)
		
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _on_button_down() -> void:
	rich_text_label.add_theme_color_override("default_color",Color.BLACK)


func _on_button_up() -> void:
	rich_text_label.add_theme_color_override("default_color",Color.from_string("dfdfdf",Color.AQUA))
