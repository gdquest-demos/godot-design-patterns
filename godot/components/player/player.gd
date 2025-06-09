extends CharacterBody2D

@export var jump_height := 256.0
@export var jump_time_to_peak := 0.4
@export var jump_time_to_descent := 0.35
@export var speed = 500.0

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity := ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var sophia_skin_2d = %SophiaSkin2D
@onready var sprite_viewport = %SpriteViewport
@onready var dust = %Dust
@onready var visual_root = %VisualRoot

var movement_x := 0.0

var double_jump_count : int = 1
var is_floating : bool = false
@export var float_max_velocity_y := 300.0

enum STATES {GROUND, AIR, LOCKED}
var state : STATES = STATES.GROUND

var listen_to_input : bool = true

var last_stepped : Node2D = null
signal stepped_on(body : Node2D)

func set_state(new_state : STATES, msg : Dictionary = {}):
	var previous_state : STATES = state
	state = new_state
	# Enter State
	match state:
		STATES.GROUND:
			do_s_s(0.8)
		STATES.AIR:
			is_floating = false
			double_jump_count = 1
			var jump : bool = msg.has("jump") && msg.jump
			if jump:
				velocity.y = jump_velocity
				do_s_s(1.2, 0.2)
			sophia_skin_2d.set_state("up" if jump else "down")
	# Exit State
	match previous_state:
		STATES.GROUND:
			dust.emitting = false
		STATES.AIR:
			is_floating = false

func _physics_process(delta):
	movement_x = Input.get_axis("left", "right")
	var is_moving : bool = !is_zero_approx(movement_x)
	
	match state:
		STATES.GROUND:
			apply_gravity(delta)
			dust.emitting = is_moving
			if is_moving:
				apply_movement(delta, 1.0)
				sophia_skin_2d.set_state("run")
			else:
				apply_x_friction(delta, 1.0)
				sophia_skin_2d.set_state("idle")
			sophia_skin_2d.run_tilt = move_toward(sophia_skin_2d.run_tilt, abs(velocity.x) / speed, 1.0 * delta)
			move_and_slide()
			if !is_on_floor():
				set_state(STATES.AIR)
				return
			if Input.is_action_pressed("jump"):
				set_state(STATES.AIR, {"jump": true})
				return
		STATES.AIR:
			sophia_skin_2d.run_tilt = move_toward(sophia_skin_2d.run_tilt, 0.0, 1.0 * delta)
			apply_gravity(delta, 0.1 if is_floating else 1.0)
			check_jump()
			if is_floating:
				sophia_skin_2d.set_state("float")
				if velocity.y > float_max_velocity_y: velocity.y = float_max_velocity_y
			else: sophia_skin_2d.set_state("up" if velocity.y < 0.0 else "down")
			if is_moving: apply_movement(delta, 0.8)
			else: apply_x_friction(delta, 0.5)
			move_and_slide()
			if is_on_floor(): set_state(STATES.GROUND)
	_check_stepped()
	
func _check_stepped():
	if !is_on_floor(): return
	var last_slide = get_last_slide_collision()
	if last_slide == null: return
	var current_stepped = get_last_slide_collision().get_collider()
	if current_stepped != last_stepped:
		last_stepped = current_stepped
		if last_stepped != null: stepped_on.emit(current_stepped)
	
func check_jump():
	if double_jump_count != 0 && Input.is_action_just_pressed("jump"):
		double_jump_count = max(0, double_jump_count - 1)
		velocity.y = jump_velocity * 0.8
		do_s_s(1.2, 0.2)
		return
	
	is_floating = Input.is_action_pressed("jump") && velocity.y > 0.0
	
	if velocity.y < 0.0 && Input.is_action_just_released("jump"):
		velocity.y *= 0.6

func apply_movement(delta, factor := 1.0) -> void:
	velocity.x = move_toward(velocity.x, movement_x * speed, speed * 10.0 * factor * delta)
	sprite_viewport.scale.x = -1.0 if movement_x > 0.0 else 1.0
	
func apply_x_friction(delta, factor := 1.0) -> void:
	velocity.x = move_toward(velocity.x, 0, speed * 2.0 * factor * delta)

func apply_gravity(delta, factor := 1.0) -> void:
	var gravity = jump_gravity if velocity.y < 0.0 else fall_gravity
	velocity.y += gravity * factor * delta

func do_s_s(value : float, timing := 0.1):
	var t = create_tween()
	t.tween_method(squash_stretch, 1.0, value, timing)
	t.tween_method(squash_stretch, value, 1.0, timing * 1.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func squash_stretch(value : float) -> void:
	visual_root.scale = Vector2(1.0 + (1.0 - value), value)

func reached_goal(target : Vector2):
	set_state(STATES.LOCKED)
	
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "global_position:x", target.x, 0.8)
	t.tween_property(sophia_skin_2d, "run_tilt", 0.0, 0.2)
	var dist_to_ground: float = abs(global_position.y - target.y)
	var fall_duration = 0.0
	if dist_to_ground > 1.0:
		fall_duration = dist_to_ground / max(speed, velocity.y)
		t.tween_callback(sophia_skin_2d.set_state.bind("down"))
		t.tween_property(self, "global_position:y", target.y, fall_duration)
	
	t.tween_callback(sophia_skin_2d.set_state.bind("run")).set_delay(fall_duration)
	
	t.chain().tween_callback(func():
		sophia_skin_2d.set_state("idle")
		sophia_skin_2d.cheer()
		)
	
