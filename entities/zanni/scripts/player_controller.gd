class_name PlayerCharacter
extends CharacterBody2D


@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var EffectsAnimator = %EffectsAnimator
@onready var PlayerAnimations = $PlayerAnimations
@onready var VictoryPlayer = $VictoryPlayer
@onready var DeathPlayer = $DeathPlayer
@onready var MaskChangePlayer = $MaskChangePlayer
@onready var state_machine: StateMachine = $State_Machine
@onready var raycast_left : RayCast2D = $RayCastLeft
@onready var raycast_right : RayCast2D = $RayCastRight
@onready var raycast_up : RayCast2D = $RayCastUp
@onready var collision : CollisionShape2D = $CollisionShape2D


@export var speed := 150.0
@export var jump_velocity = -300.0
@export var jump_deccel := 100.0
@export var braking_speed = 30
@export var start_accel = 50
@export var initial_mask : int = 0
@export var initial_num_masks := 2
@export var mask_radius := 100.0 # Radius around player where layers are visible
@export var push_force := 50
@export var max_velocity_pusing := 80.0


signal change_mask(new_mask_number: int)
signal mask_acquired(acquired_mask_number: int)
signal death()


var is_jumping := false
var just_jumped := false
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
var pausing_enabled = true
var is_pushing_box := false


### Spawning logic & physics ###

func _ready() -> void:
	spawn_position = position
	change_mask.emit(mask)
	num_masks = initial_num_masks
	spawn()
	gc.player = self


func spawn() -> void:
	position = spawn_position
	collision.disabled = false
	control_disabled = false
	visible = true
	mask = initial_mask
	prev_mask = initial_mask
	is_changing_mask = true
	change_mask.emit(mask)
	EffectsAnimator.play("RESET") # Clear any possible effects
	EffectsAnimator.play("spotlight_spawn")


func _process(_delta: float) -> void:
	# Check if pushing box
	if is_on_floor() and (
		raycast_left.is_colliding() and Input.is_action_pressed("move_left") \
			or raycast_right.is_colliding() and Input.is_action_pressed("move_right")):
				is_pushing_box = true
	else:
		is_pushing_box = false

	# Check if crushed by box
	if _check_crushed_by_box():
		collision.disabled = true
		die()


func _physics_process(delta: float) -> void:
	# Checks
	if visible == false or Engine.time_scale == 0.0:
		return
	if _should_crush():
		die()
		return

	# Add the gravity & process jump
	if not is_on_floor():
		velocity += get_gravity() * delta 
		velocity.y += 10 if velocity.y > 0 else 0 
	else: is_jumping = false

	if Input. is_action_just_released("jump"):
		just_jumped = false
		if is_jumping and velocity.y < 0:
			velocity.y = clamp(velocity.y + jump_deccel, jump_velocity, 0) 
			is_jumping = false
		
	# Sideways movement
	var direction_x := Input.get_axis("move_left", "move_right")
	if direction_x and not control_disabled:
		if is_pushing_box:
			velocity.x = direction_x * speed
		else:
			velocity.x = move_toward(velocity.x, direction_x * speed, start_accel)
		anim.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, braking_speed)

	# Update past frames info
	previous_pos = position
	previous_positions.append(position)
	previous_velocities.append(velocity)
	if previous_positions.size() > 5:
		previous_positions.pop_front()
		previous_velocities.pop_front()

	# Box push logic
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().is_in_group("boxes"):
			var box = c.get_collider() as RigidBody2D
			if abs(box.get_linear_velocity().x) < max_velocity_pusing and is_pushing_box:
				box.apply_central_impulse(c.get_normal() * -push_force)

	move_and_slide()

	# Post move collisions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if _check_collision_damaging(c):
			die()


### Events & interactions ###
func _on_mask_pickup_got_mask(mask_number: int) -> void:
	if mask_number > num_masks:
		num_masks = mask_number
		mask_acquired.emit(mask_number)
		print("Increased num_masks to ", num_masks)


func _on_exit_door_player_reached_exit() -> void:
	control_disabled = true
	state_machine.on_state_transition(BowState.Name())
	VictoryPlayer.play()


### Death ###

# On death play spotlight anim & respawn
func die() -> void:
	control_disabled = true
	visible = false
	velocity = Vector2.ZERO
	previous_positions.clear()
	previous_velocities.clear()
	DeathPlayer.play()
	death.emit()


func _on_death_plane_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		die()


var min_displacement := 1.0
var death_toll := 0

func _should_crush() -> bool:
	if is_on_floor():
		return false
	# We check if we have great velocity but aren't moving
	# Manu method
	if previous_pos.distance_to(position) < min_displacement:
		death_toll += 1
	else:
		death_toll = 0
	if death_toll > 10:
		print('manu death')
		return true
		
	# Marah method
	if previous_positions.size() < 5:
		return false
	if velocity.y < 200:
		# Not falling fast enough
		return false
	# Falling fast
	for index in previous_velocities.size():
		if previous_velocities[index].y <= 150:
			# Not fast enough
			return false
	for index in previous_positions.size():
		if previous_positions[index].y <= position.y - 5:
			return false
	print('marah death')
	return true


func _check_collision_damaging(c : KinematicCollision2D) -> bool:
	if c.get_collider() is TileMapLayer:
		var tile_collided := c.get_collider() as TileMapLayer
		var local_pos := tile_collided.to_local(c.get_position())
		var tile_data = tile_collided.get_cell_tile_data(tile_collided.local_to_map(local_pos))
		if tile_data and tile_data.get_custom_data("damaging"):
			print("spiked")
			return true
	return false


func _check_crushed_by_box() -> bool:
	if raycast_up.is_colliding():
		var collider := raycast_up.get_collider()
		if collider.is_in_group("boxes") and collider.get_linear_velocity().y > 0:
			print("crushed by box")
			return true
	return false


### Input management & mask changes ###
func _input(event: InputEvent) -> void:
	# Process mask related inputs
	
	if event.is_action_pressed("gotoingamemenu") and pausing_enabled:
		print("menu")
		gc.toggle_game_menu()
	if num_masks == 0:
		# Only allow changing masks if we have at least 1
		return
	if Engine.time_scale == 0.0:
		# Don't allow changing masks when game is paused
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
	elif event.is_action_pressed("gotomask2") and num_masks >= 1:
		mask = 1
	elif event.is_action_pressed("gotomask3") and num_masks >= 2:
		mask = 2
	elif event.is_action_pressed("gotomask4") and num_masks >= 3:
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


func jump_action():
	var jumping := Input.is_action_pressed("jump") and is_on_floor() and not control_disabled and not just_jumped
	if jumping: 
		just_jumped = true
		print("should_jump ", Time.get_ticks_msec())
	return jumping
