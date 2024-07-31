## Character that moves, jumps, and glides, using the simplest possible implementation of a state machine.
class_name PlayerStateMachineSimple extends CharacterBody2D

enum States {ON_GROUND, JUMPING, FALLING, GLIDING}

var state: int = States.ON_GROUND: set = set_state

var speed := 500.0
var jump_impulse := 1200.0
var base_gravity := 4000.0

var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 400.0
var glide_jump_impulse := 300.0


func _physics_process(delta: float) -> void:
	# Starting with input.
	var input_direction_x := Input.get_axis("move_left", "move_right")

	var is_initiating_jump := state == States.ON_GROUND and Input.is_action_just_pressed("move_up")

	# In this code block, we handle state changes (also commonly called "transitions").
	# To change state, we change the value of the `state` variable.
	if is_initiating_jump:
		state = States.JUMPING
	elif state in [States.JUMPING, States.FALLING] and Input.is_action_just_pressed("glide"):
		state = States.GLIDING
	elif state == States.GLIDING and Input.is_action_just_pressed("move_up"):
		state = States.JUMPING
	elif state == States.GLIDING and (
		get_slide_collision_count() > 0 or
		not Input.is_action_pressed("glide")
	):
		state = States.FALLING
	elif is_on_floor():
		state = States.ON_GROUND

	# In this code block, we update the character movement based on its current state.
	# TODO: fix gravity when gliding
	if state == States.GLIDING:
		velocity.x += input_direction_x * glide_acceleration * delta
		velocity.x = min(velocity.x, glide_max_speed)
		velocity.y += glide_gravity * delta
	elif state in [States.ON_GROUND, States.JUMPING]:
		velocity.x = input_direction_x * speed
		velocity.y += base_gravity * delta

	move_and_slide()


# This function is used to change the state of the character. It also updates the velocity when the state changes.
func set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	# You can check both the previous and the new state to determine what to do when the state changes.
	if state == States.JUMPING:
		var impulse = glide_jump_impulse if state == States.GLIDING else jump_impulse
		velocity.y = -impulse
