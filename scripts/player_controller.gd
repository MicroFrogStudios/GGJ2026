class_name PlayerCharacter
extends CharacterBody2D

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 300.0
@export var jump_velocity = -400.0
@export var initial_num_masks := 3


signal change_mask(new_mask_number: int)


var mask := 0
var num_masks := 0


func _ready() -> void:
	change_mask.emit(mask)
	num_masks = initial_num_masks
	print("Initial num_masks is ", num_masks)


func _input(event: InputEvent) -> void:
	if num_masks == 0:
		# Only allow changing masks if we have at least 1
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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x :=Input.get_axis("move_left", "move_right")
	if direction_x:
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
		print("Increased num_masks to ", num_masks)


func _on_crush_hitbox_body_entered(body: Node2D) -> void:
	if body.name != "knight":
		print('CRUSHED ', body)
