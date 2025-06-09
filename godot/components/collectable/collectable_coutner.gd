extends HBoxContainer

var count : int = 0 : set = _set_count

@onready var star_target = %StarCenter
@onready var count_label = %CountLabel
@onready var star_texture = %StarTexture

func _ready():
	star_texture.pivot_offset = star_texture.get_rect().size / 2.0

func _set_count(value):
	count = value
	count_label.text = str(value)
	
	var t = create_tween()
	t.tween_property(star_texture, "scale", Vector2.ONE * 1.4, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(star_texture, "scale", Vector2.ONE, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
