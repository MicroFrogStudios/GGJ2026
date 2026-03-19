class_name DialogueUI
extends Control


@onready var text_label : Label = $DialogueBox/TextLabel
@onready var npc_name_label : Label = $DialogueBox/NpcNameLabel
@onready var npc_portrait : TextureRect = $DialogueBox/NpcPortrait

@export var chars_per_second: float = 40.0

var _full_text: String = ""
var _elapsed: float = 0.0
var is_typing: bool = false


func change_npc_name(new_name: String) -> void:
	npc_name_label.text = new_name


func change_dialogue(dialogue: NpcDialogue) -> void:
	npc_portrait.texture = dialogue.portrait
	_full_text = dialogue.text
	_elapsed = 0.0
	is_typing = true
	text_label.text = ""
	text_label.visible_characters = 0
	#TODO dialogue.callback.call()


func finish_typing() -> void:
	is_typing = false
	text_label.text = _full_text
	text_label.visible_characters = -1


func _process(delta: float) -> void:
	if not is_typing:
		return
	_elapsed += delta
	var chars_to_show := int(_elapsed * chars_per_second)
	if chars_to_show >= _full_text.length():
		finish_typing()
	else:
		text_label.text = _full_text
		text_label.visible_characters = chars_to_show
