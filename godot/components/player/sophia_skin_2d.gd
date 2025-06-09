extends Node2D

@onready var animation_tree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

var run_tilt : float = 0.0 : set = _set_tilt

func _set_tilt(value : float):
	run_tilt = clamp(value, 0.0, 1.0)
	animation_tree.set("parameters/AddTilt/add_amount", run_tilt)
	animation_tree.set("parameters/TimeScale/scale", remap(run_tilt, 0.0, 1.0, 1.0, 1.4))

func set_state(state : String):
	state_machine.travel(state)

func cheer():
	animation_tree.set("parameters/CheerOneShot/request", true)
