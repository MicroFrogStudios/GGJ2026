extends CharacterBody2D


@export var mask := 0

@onready var player = gc.player
@onready var death_plane : Area2D = %DeathPlane
@onready var raycast_left : RayCast2D = $RayCastLeft
@onready var raycast_right : RayCast2D = $RayCastRight
@onready var raycast_up : RayCast2D = $RayCastUp

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var hurtbox : Area2D = $Hurtbox


var initial_position: Vector2
var something_in_hurtbox := false


func _ready() -> void:
	initial_position = position

	# Connect to mask change
	player.change_mask.connect(_on_mask_change)
	_on_mask_change(player.mask)

	# Respawn if you touch the death plane
	death_plane.body_entered.connect(func(body):
		if body == self:
			respawn()
	)

	# Hurtbox logic
	# Anything except the box itself
	hurtbox.body_entered.connect(func(body):
		if body != self:
			something_in_hurtbox = true
		print('ENTERED: ', something_in_hurtbox)
	)
	hurtbox.body_exited.connect(func(body):
		if body != self:
			something_in_hurtbox = false
		print('exited: ', something_in_hurtbox)
	)


func _on_mask_change(new_mask: int) -> void:
	# Show/hide based on mask
	if mask != 0:
		if something_in_hurtbox:
			respawn()
		visible = (new_mask == mask)
		collision_shape.disabled = not visible


func respawn() -> void:
	position = initial_position
	velocity = Vector2.ZERO


func get_next_velocity_x() -> float:
	if raycast_left.is_colliding() and raycast_left.get_collider() == player:
		if Input.is_action_pressed("move_right"):
			return player.speed
	if raycast_right.is_colliding() and raycast_right.get_collider() == player:
		if Input.is_action_pressed("move_left"):
			return -player.speed
	return 0

func _physics_process(delta: float) -> void:
	if collision_shape.disabled or Engine.time_scale == 0.0:
		return

	# Add the gravity & process jump
	if not is_on_floor():
		velocity += get_gravity() * delta 
		velocity.y += 10 if velocity.y > 0 else 0 

	velocity.x = get_next_velocity_x()
	if velocity.x != 0:
		print('Pushing box with velocity: ', velocity.x)
		player.velocity.x = velocity.x
		player.is_pushing_box = true
	else:
		player.is_pushing_box = false

	# Move boxes on top
	position.x += velocity.x * delta
	velocity.x = 0
	move_and_slide()
