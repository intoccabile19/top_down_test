extends Node

@export var initial_state: convState
var current_state: convState
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is convState:
			states[child.name.to_lower()] = child
			child.character = get_parent()
			child.conv_state_machine = self
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func transition_to(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
		
	current_state.exit()
	new_state.enter()
	current_state = new_state
	print(current_state)
