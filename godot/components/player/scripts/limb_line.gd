@tool
extends Line2D

@export var nodes : Array[Node2D]

func _process(_delta):
	var p = []
	for node in nodes:
		p.append(node.global_position)
	points = p
