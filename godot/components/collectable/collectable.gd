class_name Collectable
extends Area2D

@onready var collision_shape_2d : CollisionShape2D = %CollisionShape2D
signal picked_up
signal animation_finished

@onready var star_sprite = %StarSprite
@onready var animation_player = %AnimationPlayer
@onready var visual_anchor = %VisualAnchor
@onready var gpu_particles_2d = %GPUParticles2D
@onready var circle = %Circle

func _ready():
	body_entered.connect(func(node : Node2D):
		if node is Player:
			picked_up.emit()
			collision_shape_2d.set_deferred("disabled", true)
		)
	animation_player.play("idle")

func go_to(target_node : Control):
	gpu_particles_2d.emitting = false
	var t = create_tween()
	t.parallel().tween_property(circle, "scale", Vector2.ONE * 1.4, 0.1).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(circle, "modulate:a", 0.0, 0.1).set_ease(Tween.EASE_OUT)
	var start_position : Vector2 = global_position
	t.tween_method(func(progress : float):
		var camera : Camera2D = get_viewport().get_camera_2d()
		var target_position = camera.get_screen_center_position() - get_viewport().get_visible_rect().size / 2.0 + target_node.global_position
		global_position = lerp(start_position, target_position, progress)
		, 0.0, 1.0, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	t.parallel().tween_property(visual_anchor, "scale", Vector2.ZERO, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	t.parallel().tween_property(visual_anchor, "rotation_degrees", 360.0, 0.8)
	t.tween_callback(func(): animation_finished.emit())
	t.tween_callback(queue_free).set_delay(gpu_particles_2d.lifetime)
