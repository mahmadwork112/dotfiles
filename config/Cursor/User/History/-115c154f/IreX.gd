class_name PlayerStateMachine extends Node

@export var initial_state: State

var player: Player
var current_state: State
var states: Dictionary = {}

# Player reference - we are always a child of Player, so get it from the tree
func _ready() -> void:
	player = get_parent() as Player
	if not player:
		push_error("PlayerStateMachine must be a child of Player")
		return

	for child in get_children():
		if child is State:
			child.player = player
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)

	if initial_state:
		initial_state.enter()
		current_state = initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	pass

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics(delta)	
	pass

func change_state() -> void:
	pass
	
func _on_child_transition(state , new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get( new_state_name.to_lower() )
	if !new_state:
		return 
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
