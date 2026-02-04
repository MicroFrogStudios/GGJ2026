extends RigidBody2D


@export var mask := 0

@onready var player = gc.player
@onready var death_plane : Area2D = %DeathPlane
@onready var raycast_left : RayCast2D = $RayCastLeft
@onready var raycast_right : RayCast2D = $RayCastRight
# @onready var raycast_up : RayCast2D = $RayCastUp

@onready var rect_collision : CollisionShape2D = $RectangleCollision
@onready var floor_collision : CollisionShape2D = $FloorCollision
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
			call_deferred('respawn')
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
		floor_collision.disabled = not visible
		rect_collision.disabled = not visible
		freeze = not visible


func respawn() -> void:
	freeze = true # Need to freeze to avoid physics when changing position
	print('respawning', initial_position)
	position = initial_position
	freeze = false


func _process(_delta: float) -> void:
	if raycast_left.is_colliding() and Input.is_action_pressed("move_right") \
		or raycast_right.is_colliding() and Input.is_action_pressed("move_right"):
			player.is_pushing_box = true
