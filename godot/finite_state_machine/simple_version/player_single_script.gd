## Character that moves, jumps, and glides, using the simplest possible implementation of a state machine.
class_name PlayerStateMachineSimple extends CharacterBody2D

enum States {IDLE, RUNNING, JUMPING, FALLING, GLIDING}

var state: States = States.IDLE: set = set_state

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

	const GROUND_STATES := [States.IDLE, States.RUNNING]
	# In this code block, we handle state changes (also commonly called "transitions").
	# To change state, we change the value of the `state` variable.
	if state in GROUND_STATES and Input.is_action_just_pressed("move_up"):
		state = States.JUMPING
	elif (
		(state == States.JUMPING and velocity.y > 0.0) or
		(state in GROUND_STATES and not is_on_floor())
	):
		state = States.FALLING
	elif state in [States.JUMPING, States.FALLING] and Input.is_action_just_pressed("glide"):
		state = States.GLIDING
	elif state == States.GLIDING and Input.is_action_just_pressed("move_up"):
		state = States.JUMPING
	elif state == States.GLIDING and (
		get_slide_collision_count() > 0 or
		Input.is_action_just_pressed("glide")
	):
		state = States.FALLING
	elif is_on_floor():
		if input_direction_x != 0.0:
			state = States.RUNNING
		else:
			state = States.IDLE

	# In this code block, we update the character horizontal velocity based on its current state.
	if state == States.GLIDING:
		velocity.x += input_direction_x * glide_acceleration * delta
		velocity.x = min(velocity.x, glide_max_speed)
	elif state in [States.RUNNING, States.JUMPING, States.FALLING]:
		velocity.x = input_direction_x * speed
	else:
		velocity.x = 0.0

	velocity.y += current_gravity * delta
	move_and_slide()


func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	if previous_state == States.GLIDING:
		current_gravity = base_gravity

	# You can check both the previous and the new state to determine what to do
	# when the state changes.
	if state == States.IDLE:
		velocity.x = 0.0
	elif state == States.JUMPING:
		var impulse = glide_jump_impulse if state == States.GLIDING else jump_impulse
		if previous_state == States.GLIDING:
			velocity.y = -glide_jump_impulse
		else:
			velocity.y = -impulse
	elif state == States.GLIDING:
		current_gravity = glide_gravity
		# Ensure the character doesn't keep its upward momentum when starting
		# gliding.
		velocity.y = max(velocity.y, 0.0)
