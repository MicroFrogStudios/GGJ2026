class_name PlayerCharacter
extends CharacterBody2D


@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var EffectsAnimator = %EffectsAnimator
@onready var PlayerAnimations = $PlayerAnimations
@onready var VictoryPlayer = $VictoryPlayer
@onready var DeathPlayer = $DeathPlayer
@onready var MaskChangePlayer = $MaskChangePlayer


@export var speed := 150.0
@export var jump_velocity = -300.0
@export var initial_num_masks := 3
@export var jump_deccel := 100.0
@export var braking_speed = 15
@export var start_accel = 10
@export var initial_mask : int = 0
@export var mask_radius := 100.0 # Radius around player where layers are visible


signal change_mask(new_mask_number: int)
signal mask_acquired(acquired_mask_number: int)
signal death()


var is_jumping = false
var previous_frame_on_floor :bool
var mask := 0
var num_masks := 0
var spawn_position: Vector2
var control_disabled := false # If true, player control is disabled
var going_into_door := false
var is_changing_mask := false # True during the mask change shockwave
var prev_mask := 0
var previous_positions := [] # Position for past 5 frames
var previous_velocities := [] # Velocity for past 5 frames
var previous_pos := Vector2.ZERO
var min_displacement := 1.0
var death_toll := 0


func spawn() -> void:
	position = spawn_position
	control_disabled = false
	visible = true
	mask = initial_mask
	prev_mask = initial_mask
	is_changing_mask = true
	change_mask.emit(mask)
	EffectsAnimator.play("RESET") # Clear any possible effects
	EffectsAnimator.play("spotlight_spawn")
	


func _ready() -> void:
	spawn_position = position
	change_mask.emit(mask)
	num_masks = initial_num_masks
	spawn()
	anim.animation_finished.connect(on_animation_finish)
	gc.player = self


func on_animation_finish():
	pass


func _input(event: InputEvent) -> void:
	# Process mask related inputs
	if num_masks == 0:
		# Only allow changing masks if we have at least 1
		return
	if control_disabled:
		# Don't allow changing masks during cutscenes
		return
	var local_prev_mask = mask
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

	if local_prev_mask != mask:
		print("Mask is ", mask)
		is_changing_mask = true
		prev_mask = local_prev_mask
		PlayerAnimations.stop()
		PlayerAnimations.play("mask_change_radius_expansion")
		MaskChangePlayer.play_next()
		change_mask.emit(mask)


func finish_mask_change() -> void:
	is_changing_mask = false
	prev_mask = mask


func _should_crush(prev_pos: Array, curr_pos: Vector2, prev_vel: Array, vel: Vector2) -> bool:
	if prev_pos.size() < 5:
		return false
	if vel.y < 200:
		# Not falling fast enough
		return false

	if vel.y > 200:
		# Falling fast
		for index in prev_vel.size():
			if prev_vel[index].y <= 150:
				# Not fast enough
				return false
		for index in prev_pos.size():
			if prev_pos[index].y <= curr_pos.y - 5:
				return false
	return true


func _physics_process(delta: float) -> void:
	if visible == false or Engine.time_scale == 0.0:
		return
	# We check if it's moving fast in a direction and still not moving much (Manu's method)
	if previous_pos.distance_to(position) < min_displacement and not is_on_floor():
		death_toll+=1
	else:
		death_toll = 0
	if death_toll > 10:
		print('manu death')
		die()
		return
	previous_pos = position
	# Check crushes (Marah's method)
	if not is_on_floor() and _should_crush(previous_positions, position, previous_velocities, velocity):
		die()
		print('marah death')
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta 
		velocity.y += 10 if velocity.y > 0 else 0 
	else: is_jumping = false

		
	if Input. is_action_just_released("jump") and is_jumping and velocity.y < 0:
		velocity.y = clamp(velocity.y + jump_deccel,jump_velocity,0) 
		is_jumping = false
		
	## Sideways movement
	var direction_x := Input.get_axis("move_left", "move_right")
	if direction_x and not control_disabled:
		velocity.x = move_toward(velocity.x,direction_x * speed, start_accel)
		anim.flip_h = velocity.x < 0

	else:
		velocity.x = move_toward(velocity.x,0, braking_speed)

	previous_positions.append(position)
	previous_velocities.append(velocity)
	if previous_positions.size() > 5:
		previous_positions.pop_front()
		previous_velocities.pop_front()
	move_and_slide()


func _on_mask_pickup_got_mask(mask_number: int) -> void:
	if mask_number > num_masks:
		num_masks = mask_number
		mask_acquired.emit(mask_number)
		print("Increased num_masks to ", num_masks)


func die() -> void:
	control_disabled = true
	visible = false
	previous_positions.clear()
	previous_velocities.clear()
	DeathPlayer.play()
	death.emit()


func _on_death_plane_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	die()


func _on_exit_door_player_reached_exit() -> void:
	control_disabled = true
	going_into_door = true
	VictoryPlayer.play()
	PlayerAnimations.play("enter_door")
