# Character that moves, jumps, and glides.
class_name PlayerNoStates
extends KinematicBody2D

enum States {ON_GROUND, IN_AIR, GLIDING}

var _state: int = States.ON_GROUND


var speed := 500.0
var jump_impulse := 1200.0
var base_gravity := 4000.0

# Here are the new variables for gliding.
var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 400.0
var glide_jump_impulse := 300.0

var _velocity := Vector2.ZERO
# There's also a new boolean value to keep track of the gliding state.
var _is_gliding := false


func _physics_process(delta: float) -> void:
	# Starting with input.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var is_jumping: bool = _state == States.ON_GROUND and Input.is_action_just_pressed("move_up")

	# To change state, we change the value of the `_state` variable
	if Input.is_action_just_pressed("glide") and _state == States.IN_AIR:
		_state = States.GLIDING

	# Canceling gliding.
	if _state == States.GLIDING and Input.is_action_just_pressed("move_up"):
		_state = States.IN_AIR

	# Calculating horizontal velocity.
	if _state == States.GLIDING:
		_velocity.x += input_direction_x * glide_acceleration * delta
		_velocity.x = min(_velocity.x, glide_max_speed)
	else:
		_velocity.x = input_direction_x * speed

	# Calculating vertical velocity.
	var gravity := glide_gravity if _state == States.GLIDING else base_gravity
	_velocity.y += gravity * delta
	if is_jumping:
		var impulse = glide_jump_impulse if _state == States.GLIDING else jump_impulse
		_velocity.y = -jump_impulse
		_state = States.IN_AIR

	# Moving the character.
	_velocity = move_and_slide(_velocity, Vector2.UP)

	# If we're gliding and we collide with something, we turn gliding off and the character falls.
	if _state == States.GLIDING and get_slide_count() > 0:
		_state = States.IN_AIR

	if is_on_floor():
		_state = States.ON_GROUND
