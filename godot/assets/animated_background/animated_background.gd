extends ColorRect

func _process(_delta):
	material.set_shader_parameter("camera_offset", get_viewport().get_camera_2d().get_screen_center_position().x)
