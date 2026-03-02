extends Node2D

# Dialogue is an array of objects, one of them a string
# { text: "Hello there!", portrait: some_texture, callback }
@export var dialogues : Array[NpcDialogue]


@onready var talk_hitbox : Area2D = $TalkHitbox
@onready var dialogue_ui : DialogueUI = %DialogueUI


var has_player_inside: bool = false


func _ready() -> void:
	talk_hitbox.body_entered.connect(_on_TalkHitbox_body_entered)
	talk_hitbox.body_exited.connect(_on_TalkHitbox_body_exited)


# If player inside hitbox and presses the talk button, start dialogue
func _process(_delta: float) -> void:
	if has_player_inside and Input.is_action_just_pressed("talk"):
		dialogue_ui.visible = true
		dialogue_ui.change_dialogue(dialogues[0])
		# TODO lock zani etc etc


func _on_TalkHitbox_body_entered(body: Node) -> void:
	if body == gc.player:
		has_player_inside = true

func _on_TalkHitbox_body_exited(body: Node) -> void:
	if body == gc.player:
		has_player_inside = false
