extends Node


var power_system := PowerSystem.new()


func _ready() -> void:
	power_system.setup(get_tree().get_nodes_in_group("power_sources"), get_tree().get_nodes_in_group("power_receivers"), $TileMap)


func _physics_process(delta: float) -> void:
	power_system.update(delta)
