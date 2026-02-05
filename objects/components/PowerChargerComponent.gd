class_name PowerChargerComponent extends Node

@export var charge_rate: float = 10.0

var target: PowerSourceComponent

func _process(delta: float) -> void:
	if target and target.current_charge < target.max_charge:
		target.add_charge(charge_rate * delta)
