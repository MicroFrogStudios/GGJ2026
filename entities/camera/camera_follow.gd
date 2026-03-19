extends Camera2D


# Camera movement script
# Follows a target node, with special handling for dialogue scenes to frame both the player and NPC.

@export var following: Node2D
@export var follow_speed := 5
@export var effects: AnimationPlayer

@export var dialogue_zoom := Vector2(1.8, 1.8)
@export var dialogue_transition_speed := 1.5
@export var dialogue_vertical_offset := 15.0  # Pan downward to frame characters better

var initial_center: Vector2
var look_offset := 0.0

var _in_dialogue := false
var _dialogue_npc_pos := Vector2.ZERO
var _default_zoom := Vector2.ONE


func _ready() -> void:
	initial_center = get_screen_center_position()
	gc.camera = self
	_default_zoom = zoom


func start_dialogue_view(npc_global_position: Vector2) -> void:
	_dialogue_npc_pos = npc_global_position
	_in_dialogue = true


func end_dialogue_view() -> void:
	_in_dialogue = false


func _physics_process(delta: float) -> void:
	if _in_dialogue:
		var midpoint := (following.global_position + _dialogue_npc_pos) / 2.0
		var target_pos := midpoint + Vector2(0, dialogue_vertical_offset)
		position = position.lerp(target_pos, dialogue_transition_speed * delta)
		zoom = zoom.lerp(dialogue_zoom, dialogue_transition_speed * delta)
	else:
		if following.position.y < 100:
			position = position.lerp(following.position - Vector2(0, 10 + look_offset), follow_speed * delta)
		zoom = zoom.lerp(_default_zoom, 2 * dialogue_transition_speed * delta)
