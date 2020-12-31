extends Node2D


onready var animation_player := $AnimationPlayer


func _ready() -> void:
	animation_player.play("Work")
	$PowerSource.efficiency = 1.0


func _on_PowerSource_power_drawn(power, delta) -> void:
	var proportion: float = power / $PowerSource.power_amount
	animation_player.playback_speed = proportion
