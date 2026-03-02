class_name DialogueUI
extends Control


@onready var text_label : Label = $DialogueBox/TextLabel
@onready var npc_name_label : Label = $DialogueBox/NpcNameLabel
@onready var npc_portrait : TextureRect = $DialogueBox/NpcPortrait


func change_npc_name(new_name: String) -> void:
	npc_name_label.text = new_name


func change_dialogue(dialogue: NpcDialogue) -> void:
	text_label.text = dialogue.text
	npc_portrait.texture = dialogue.portrait
	#TODO dialogue.callback.call()
