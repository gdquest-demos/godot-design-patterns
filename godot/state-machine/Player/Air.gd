# Jump.gd
extends PlayerState

# Horizontal speed in pixels per second.
export var speed := 500.0
# Vertical acceleration in pixel per second squared.
export var gravity := 3500.0
# Vertical speed applied when jumping.
export var jump_impulse := 1200.0


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print()
	if msg.has("do_jump"):
		player.velocity.y = -jump_impulse


func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = speed * input_direction_x
	player.velocity.y += gravity * delta
	player.velocity = player.move_and_slide(player.velocity)
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
