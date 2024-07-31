extends PlayerState


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		finished.emit("Air")
		return

	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity

	if Input.is_action_just_pressed("move_up"):
		finished.emit("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit("Idle")
