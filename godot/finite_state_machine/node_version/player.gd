# Character that moves and jumps.
class_name Player
extends CharacterBody2D

## Horizontal speed in pixels per second.
var speed := 500.0
## Vertical acceleration in pixel per second squared.
var gravity := 4000.0
## Vertical speed applied when jumping.
var jump_impulse := 1800.0

var glide_max_speed := 1000.0
var glide_acceleration := 1000.0
var glide_gravity := 400.0
var glide_jump_impulse := 800.0


@onready var fsm := $StateMachine
@onready var label := $Label


func _process(_delta: float) -> void:
	label.text = fsm.state.name
