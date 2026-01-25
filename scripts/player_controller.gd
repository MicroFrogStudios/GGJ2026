extends CharacterBody2D

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 300.0
@export var jump_velocity = -100.0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x :=Input.get_axis("ui_left", "ui_right")
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
