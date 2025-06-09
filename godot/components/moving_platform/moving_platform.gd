@tool
extends Platform

@export var platform_speed : float = 100.0
@export var back_and_forth : bool = true

var curve_length : float = 1.0
var path : Path2D

func _ready():
	super()
	set_process(!Engine.is_editor_hint())
	if Engine.is_editor_hint(): return
	path = get_parent() as Path2D
	if path == null && path.curve == null: return
	_interpolate_position(0.0)
	curve_length = path.curve.get_baked_length()
	var duration = curve_length / platform_speed
	var t = create_tween().set_loops(0).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.tween_method(_interpolate_position, 0.0, 1.0, duration).set_delay(1.0)
	if back_and_forth: t.tween_method(_interpolate_position, 1.0, 0.0, duration).set_delay(1.0)
	

func _interpolate_position(offset: float):
	position = path.curve.sample_baked(offset * curve_length)
