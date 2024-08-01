## Character that moves, jumps, and glides, using the simplest possible implementation of a state machine.
extends CharacterBody2D

var is_idle = true
var is_running = false
var is_jumping = false
var is_falling = false
var is_gliding = false

var speed := 500.0
var jump_impulse := 1800.0
var base_gravity := 4000.0

var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 400.0
var glide_jump_impulse := 800.0

var current_gravity := base_gravity


func _physics_process(delta: float) -> void:
	# Starting with input.
	var input_direction_x := Input.get_axis("move_left", "move_right")

	# Initiating a jump.
	if (is_idle or is_running or is_gliding) and Input.is_action_just_pressed("move_up"):
		var impulse := jump_impulse
		velocity.y = -jump_impulse
		if is_gliding:
			current_gravity = base_gravity

		is_idle = false
		is_running = false
		is_gliding = false
		is_jumping = true
	elif (is_jumping and velocity.y > 0.0) or ((is_idle or is_running) and not is_on_floor()):
		is_idle = false
		is_running = false
		is_jumping = false
		is_falling = true
	elif (is_jumping or is_falling) and Input.is_action_just_pressed("glide"):
		# Set gliding state
		is_jumping = false
		is_falling = false
		is_gliding = true
		current_gravity = glide_gravity
		velocity.y = max(velocity.y, 0.0)
	elif is_gliding and Input.is_action_just_pressed("move_up"):
		# Set jumping state from gliding
		is_jumping = true
		is_gliding = false
		velocity.y = -glide_jump_impulse
		current_gravity = base_gravity
	elif is_gliding and (get_slide_collision_count() > 0 or Input.is_action_just_pressed("glide")):
		is_falling = true
		is_gliding = false
		current_gravity = base_gravity
	elif is_on_floor():
		is_jumping = false
		is_falling = false
		is_gliding = false
		if input_direction_x != 0.0:
			is_running = true
		else:
			is_idle = true
			velocity.x = 0.0

	# Update character horizontal velocity based on the current state.
	if is_gliding:
		velocity.x += input_direction_x * glide_acceleration * delta
		velocity.x = min(velocity.x, glide_max_speed)
	elif is_running or is_jumping or is_falling:
		velocity.x = input_direction_x * speed
	else:
		velocity.x = 0.0

	velocity.y += current_gravity * delta
	move_and_slide()
