extends Node2D

@onready var back = %Back
@onready var back_2 = %Back2
@onready var front = %Front

var angle : float = 0.0 : set = set_angle

func set_angle(value : float):
	angle = value
	if !is_inside_tree(): return
	back.rotation = angle
	back_2.rotation = angle
	front.rotation = angle
