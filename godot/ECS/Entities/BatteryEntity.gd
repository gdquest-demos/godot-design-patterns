extends Node2D


export var max_storage := 1000.0

var stored_power := 0.0 setget _set_stored_power

onready var receiver := $PowerReceiver
onready var source := $PowerSource
onready var indicator := $Indicator


func _set_stored_power(value: float) -> void:
	stored_power = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	receiver.efficiency = (
		0.0
		if stored_power >= max_storage
		else min((max_storage - stored_power) / receiver.power_required, 1.0)
	)
	
	source.efficiency = (0.0 if stored_power <= 0 else min(stored_power/source.power_amount, 1.0))

	indicator.material.set_shader_param("amount", stored_power / max_storage)


func _on_PowerSource_power_drawn(power, delta) -> void:
	self.stored_power = stored_power - min(power, source.power_amount * source.efficiency) * delta


func _on_PowerReceiver_power_received(power, delta) -> void:
	self.stored_power = stored_power + power * delta
