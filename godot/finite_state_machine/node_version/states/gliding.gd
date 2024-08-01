extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = max(player.velocity.y, 0.0)


func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x += input_direction_x * player.glide_acceleration * delta
	player.velocity.x = min(player.velocity.x, player.glide_max_speed)
	player.velocity.y += player.glide_gravity * delta
	player.move_and_slide()

	if Input.is_action_just_pressed("move_up"):
		finished.emit(JUMPING)
	elif (
		player.get_slide_collision_count() > 0 or
		Input.is_action_just_pressed("glide")
	):
		finished.emit(FALLING)
	elif player.is_on_floor():
		if input_direction_x != 0.0:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
