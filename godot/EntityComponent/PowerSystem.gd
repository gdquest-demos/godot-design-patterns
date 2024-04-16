class_name PowerSystem
extends Reference

var sources := {}
var receivers := {}

var paths := []

var receivers_already_provided := {}


func setup(power_sources: Array, power_receivers: Array, tilemap: TileMap) -> void:
	for source in power_sources:
		var location := tilemap.world_to_map(source.global_position)
		sources[location] = _find_power_source_child(source)
		paths.push_back([location])

	for receiver in power_receivers:
		var location := tilemap.world_to_map(receiver.global_position)
		receivers[location] = _find_power_receiver_child(receiver)

	for path in paths:
		for receiver in receivers:
			if receiver.x == path[0].x + 1:
				path.push_back(receiver)


func update(delta: float) -> void:
	receivers_already_provided.clear()

	for path in paths:
		var source: PowerSource = sources[path[0]]

		var available_power := source.power_amount * source.efficiency

		var power_draw := 0.0

		for cell in path.slice(1, path.size() - 1):
			if not receivers.has(cell):
				continue

			var receiver: PowerReceiver = receivers[cell]
			var power_required := receiver.power_required * receiver.efficiency

			if receivers_already_provided.has(cell):
				var receiver_total: float = receivers_already_provided[cell]
				if receiver_total >= power_required:
					continue
				else:
					power_required -= receiver_total

			receiver.emit_signal("power_received", min(available_power, power_required), delta)

			power_draw += power_required

			if not receivers_already_provided.has(cell):
				receivers_already_provided[cell] = min(available_power, power_required)
			else:
				receivers_already_provided[cell] += min(available_power, power_required)

			available_power -= power_required

		source.emit_signal("power_drawn", power_draw, delta)


func _find_power_source_child(parent: Node) -> PowerSource:
	for child in parent.get_children():
		if child is PowerSource:
			return child

	return null


func _find_power_receiver_child(parent: Node) -> PowerReceiver:
	for child in parent.get_children():
		if child is PowerReceiver:
			return child

	return null
