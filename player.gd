extends CharacterBody3D
signal hit

# How fast the player move in meters per second.
@export var speed = 14

# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impluse = 16

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

	# Normalize direction vector if needed
	if direction != Vector3.ZERO:
		direction =direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	
	set_animation_speed(direction)

	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	# Vertical velocity
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	for index in range(get_slide_collision_count()):
		var collision:KinematicCollision3D = get_slide_collision(index)
		
		# I cast this to node; which it should be, let's test it though
		var mob:Node = collision.get_collider()
		if mob == null:
			continue
		elif mob.is_in_group("mob") && Vector3.UP.dot(collision.get_normal()) > 0.1:
			mob.squash()
			target_velocity.y = bounce_impluse
			break

	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

	# Actually apply movement
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body: Node3D) -> void:
	# OMG I DIE 
	die()

func set_animation_speed(direction:Vector3) -> void:
	if direction != Vector3.ZERO && is_on_floor():
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1