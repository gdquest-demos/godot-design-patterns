# Character that moves and jumps.
class_name Player
extends KinematicBody2D

var velocity

onready var fsm := $StateMachine
onready var label := $Label

func _process(delta: float) -> void:
	label.text = fsm.state.name

