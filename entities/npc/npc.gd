extends Node2D

# Dialogue is an array of objects, one of them a string
# { text: "Hello there!", portrait: some_texture, callback }
@export var dialogues : Array[NpcDialogue]


@onready var talk_hitbox : Area2D = $TalkHitbox
@onready var dialogue_ui : DialogueUI = %DialogueUI


var has_player_inside: bool = false
var current_dialogue_index: int = -1  # -1 = not in dialogue


func _ready() -> void:
	talk_hitbox.body_entered.connect(_on_TalkHitbox_body_entered)
	talk_hitbox.body_exited.connect(_on_TalkHitbox_body_exited)


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("talk"):
		return

	if current_dialogue_index >= 0:
		# Already in dialogue — advance or close
		current_dialogue_index += 1
		if current_dialogue_index < dialogues.size():
			dialogue_ui.change_dialogue(dialogues[current_dialogue_index])
		else:
			_end_dialogue()
	elif has_player_inside and dialogues.size() > 0:
		_start_dialogue()


func _start_dialogue() -> void:
	current_dialogue_index = 0
	gc.player.control_disabled = true
	dialogue_ui.visible = true
	dialogue_ui.change_dialogue(dialogues[0])


func _end_dialogue() -> void:
	current_dialogue_index = -1
	dialogue_ui.visible = false
	gc.player.control_disabled = false


func _on_TalkHitbox_body_entered(body: Node) -> void:
	if body == gc.player:
		has_player_inside = true

func _on_TalkHitbox_body_exited(body: Node) -> void:
	if body == gc.player:
		has_player_inside = false
		if current_dialogue_index >= 0:
			_end_dialogue()  # Cancel dialogue if player walks away
