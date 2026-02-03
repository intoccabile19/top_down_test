class_name SwitchComponent extends Node

signal toggled(is_on)

@export var is_on: bool = false

func toggle() -> void:
	is_on = not is_on
	toggled.emit(is_on)

func set_state(state: bool) -> void:
	if is_on != state:
		is_on = state
		toggled.emit(is_on)
