extends CharacterBody3D

# How fast the player move in meters per second.
@export var speed = 14

# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# Process inputs
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	# if Input.is_action_pressed("jump"):
	# 	direction.y -= speed

	# Normalize direction vector if needed
	if direction != Vector3.ZERO:
		direction =direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# TODO For some reason, the ground speed is normalized with the delta, which could be inconsistent.
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical velocity
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	# Actually apply movement
	velocity = target_velocity
	move_and_slide()
