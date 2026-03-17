class_name State extends Node

# Set by the state machine so each state can access the player
var player: Player

# So that every state can tell other states when it is finished.
signal Transitioned 
# What happens when you enter the state
func enter() -> void:
	pass

# What happens when you leave the state
func exit() -> void:
	pass

# How does it update the animations
func update( _delta : float ) -> void:
	pass

# How does the character move
func physics( _delta : float ) -> void:
	pass

func handle_input( _event : Input ) -> void:
	pass
