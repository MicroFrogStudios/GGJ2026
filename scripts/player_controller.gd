class_name PlayerCharacter
extends CharacterBody2D


@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var EffectsAnimator = %EffectsAnimator
@onready var PlayerAnimations = $PlayerAnimations


@export var speed := 300.0
@export var jump_velocity = -400.0
@export var initial_num_masks := 3


signal change_mask(new_mask_number: int)
signal mask_acquired(acquired_mask_number: int)
signal death()


var mask := 0
var num_masks := 0
var spawn_position: Vector2
var control_disabled := false # If true, player control is disabled


func spawn() -> void:
	position = spawn_position
	control_disabled = false
	visible = true
	EffectsAnimator.play("spotlight_spawn")


func _ready() -> void:
	spawn_position = position
	change_mask.emit(mask)
	num_masks = initial_num_masks
	spawn()


func _input(event: InputEvent) -> void:
	# Process mask related inputs
	if num_masks == 0:
		# Only allow changing masks if we have at least 1
		return
	if control_disabled:
		# Don't allow changing masks during cutscenes
		return
	var prev_mask = mask
	if event.is_action_pressed("prev_mask"):
		var new_mask = (num_masks + 1 + mask - 1) % (num_masks + 1)
		mask = new_mask
	elif event.is_action_pressed("next_mask"):
		var new_mask = (mask + 1) % (num_masks + 1)
		mask = new_mask
	elif event.is_action_pressed("gotomask1"):
		mask = 0
	elif event.is_action_pressed("gotomask2"):
		mask = 1
	elif event.is_action_pressed("gotomask3"):
		mask = 2
	elif event.is_action_pressed("gotomask4"):
		mask = 3

	if prev_mask != mask:
		print("Mask is ", mask)
		change_mask.emit(mask)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not control_disabled:
		velocity.y = jump_velocity

	## Sideways movement
	var direction_x :=Input.get_axis("move_left", "move_right")
	if direction_x and not control_disabled:
		anim.play("run")
		anim.flip_h = false
		if direction_x < 0:
			anim.flip_h = true
		velocity.x = direction_x * speed
	else:
		anim.play("idle")
		velocity.x = move_toward(velocity.x,0, speed)

	move_and_slide()


func _on_mask_pickup_got_mask(mask_number: int) -> void:
	if mask_number > num_masks:
		num_masks = mask_number
		mask_acquired.emit(mask_number)
		print("Increased num_masks to ", num_masks)


func die() -> void:
	control_disabled = true
	visible = false
	death.emit()


func _on_crush_hitbox_body_entered(body: Node2D) -> void:
	# Something entered the player's crush hitbox
	if body.name == "PlayerCharacter":
		# Don't trigger it by the player itself
		return
	die()


func _on_death_plane_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	die()


func _on_exit_door_player_reached_exit() -> void:
	control_disabled = true
	PlayerAnimations.play("enter_door")
