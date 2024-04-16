extends Node2D

onready var animation_player := $AnimationPlayer


func _ready() -> void:
	animation_player.play("Work")
	$PowerSource.efficiency = 1.0


## Respond to power draw by setting the animation speed to a percentage of
## the power taken vs amount of power it's able to output
func _on_PowerSource_power_drawn(power: float, _delta: float) -> void:
	var proportion: float = power / $PowerSource.power_amount
	animation_player.playback_speed = proportion
