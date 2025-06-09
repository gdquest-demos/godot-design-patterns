@tool
class_name FallingPlatform
extends Platform

@onready var sprite_bg = %SpriteBG
@onready var gpu_particles_2d = %GPUParticles2D
@onready var visual_root = %VisualRoot
@onready var reappear_timer : Timer = %ReappearTimer

func _set_width(value : float):
	super(value)
	if !is_inside_tree(): return
	sprite_bg.position.x = -width / 2.0
	sprite_bg.size.x = width
	gpu_particles_2d.process_material.set("emission_box_extents:x", width)
	reappear_timer.timeout.connect(_reappear_timer_timeout)
	if Engine.is_editor_hint(): return
	var t = create_tween().set_loops(0).set_trans(Tween.TRANS_SINE).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_property(self, "position:y", -16.0, 1.0).as_relative()
	t.tween_property(self, "position:y", 16.0, 1.0).as_relative()

func _player_stepped_on(body : Node2D):
	if body != self: return
	
	gpu_particles_2d.emitting = false
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(visual_root, "modulate:a", 0.0, 1.0)
	t.tween_callback(collision_shape_2d.set_deferred.bind("disabled", true))
	
	reappear_timer.start(3.0)

func _reappear_timer_timeout():
	gpu_particles_2d.emitting = true
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(visual_root, "modulate:a", 1.0, 0.1)
	t.parallel().tween_callback(collision_shape_2d.set_deferred.bind("disabled", false))
