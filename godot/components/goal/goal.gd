class_name Goal
extends Node2D

@onready var marker = %Marker
@onready var area_2d = %Area2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var flag = %Flag
@onready var flag_mat : ShaderMaterial = flag.material
@onready var stars_particles = %StarsParticles

signal goal_reached(end_position : Vector2)

func _ready():
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node2D):
	if body is Player:
		goal_reached.emit(marker.global_position)
		collision_shape_2d.set_deferred("disabled", true)
		
		stars_particles.emitting = true
		
		var t = create_tween()
		t.tween_property(flag_mat, "shader_parameter/bend", 0.7, 0.1)
		t.tween_property(flag_mat, "shader_parameter/bend", 0.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
