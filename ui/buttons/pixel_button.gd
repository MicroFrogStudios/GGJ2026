@tool
extends TextureButton


var _text_offset :Vector2
@export var text_offset:Vector2:
	get:
		return _text_offset
	set(value):
		_text_offset = value
		if is_node_ready():
			rich_text_label.position = _text_offset


var _text :String = "text"
@export var text :String = "text":
	get:
		if is_node_ready():
			return rich_text_label.text
		return _text
	set(value):
		if is_node_ready():
			_text = value
			rich_text_label.text = value
		

var _font_size : int = 12
@export var font_size : int = 12:
	get:
		if is_node_ready():
			return rich_text_label.get_theme_font_size("normal_font_size")
		return font_size
	set(value):
		if is_node_ready():
			_font_size = value
			rich_text_label.add_theme_font_size_override("normal_font_size",value)
		
@onready var rich_text_label: RichTextLabel = $RichTextLabel
func _ready() -> void:
	
	pass

func _on_button_down() -> void:
	rich_text_label.add_theme_color_override("default_color",Color.BLACK)


func _on_button_up() -> void:
	rich_text_label.add_theme_color_override("default_color",Color.from_string("dfdfdf",Color.AQUA))
