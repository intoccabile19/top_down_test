class_name PowerSourceComponent extends Node

signal on_charge_changed(current, max)
signal on_depleted()

@export var max_charge: float = 100.0
@export var current_charge: float = 100.0

func _ready() -> void:
	current_charge = max_charge
	
func has_charge() -> bool:
	return current_charge > 0

func drain(amount: float) -> float:
	var drained = min(current_charge, amount)
	current_charge -= drained
	on_charge_changed.emit(current_charge, max_charge)
	
	if current_charge <= 0:
		on_depleted.emit()
		
	return drained

func add_charge(amount: float) -> float:
	var missing = max_charge - current_charge
	var added = min(missing, amount)
	current_charge += added
	on_charge_changed.emit(current_charge, max_charge)
	return added
