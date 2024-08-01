extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("move_up"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(RUNNING)
