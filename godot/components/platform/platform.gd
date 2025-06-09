@tool
class_name Platform
extends AnimatableBody2D

@export_range(64.0, 512.0, 32.0) var width : float = 128.0 : set = _set_width
@onready var collision_shape_2d = %CollisionShape2D
@onready var shape : RectangleShape2D = collision_shape_2d.shape
@onready var sprite = %Sprite

func _set_width(value : float):
	width = value
	if !is_inside_tree(): return
	shape.size.x = width
	sprite.position.x = -width / 2.0
	sprite.size.x = width
	
func _ready():
	_set_width(width)
