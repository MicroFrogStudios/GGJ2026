extends Node2D


@export var mask_number = 1
@export var mask_texture : Texture2D

@onready var mask_collision_shape: CollisionShape2D = $MaskArea2D/CollisionShape2D
@onready var MaskPickupPlayer = $MaskPickupPlayer

var initial_position: Vector2
var textbox_up := false

signal got_mask(mask_number: int)
signal finished_pickup


func _ready() -> void:
	initial_position = position
	$Sprite2D.texture = mask_texture
	$Sprite2D/SpriteAura.texture = mask_texture


func disable_mask() -> void:
	visible = false
	mask_collision_shape.disabled = true
	# TODO play anim or something
	#

func _input(event: InputEvent) -> void:
	if not textbox_up:
		return
	if event.is_action_pressed("prev_mask") \
	or event.is_action_pressed("next_mask") \
	or event.is_action_pressed("gotomask1") \
	or event.is_action_pressed("gotomask2") \
	or event.is_action_pressed("gotomask3") \
	or event.is_action_pressed("gotomask4"):
		%PlayerCharacter.control_disabled = false
		finished_pickup.emit()
		queue_free()
		music_manager.resume_music()
		Engine.time_scale = 1.0   # resume game
		textbox_up = false


func _on_mask_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		got_mask.emit(mask_number)
		call_deferred("disable_mask")
		body.control_disabled = true
		Engine.time_scale = 0.0   # freeze the game
		music_manager.stop_music()
		MaskPickupPlayer.play()
		textbox_up = true


func _physics_process(_delta: float) -> void:
	var time = Time.get_ticks_msec()
	var variance = sin(time / 400.0) * Vector2(0, 3)
	position = initial_position + variance
