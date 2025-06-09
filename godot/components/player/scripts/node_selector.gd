@tool
extends Node2D

@export var node_idx : int = 0 : set = _set_node_idx
var max_idx : int = 0

func _ready():
	max_idx = get_child_count() - 1

func _set_node_idx(value : int):
	
	get_child(node_idx).hide()
	node_idx = clamp(value, 0, max_idx)
	get_child(node_idx).show()
