extends Line2D

var path_2d : Path2D = null

func _ready():
	path_2d = get_parent() as Path2D
	if path_2d && path_2d.curve:
		points = path_2d.curve.get_baked_points()
