# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends State

var player: Player


func _ready() -> void:
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)
