class_name PowerConsumerComponent extends Node

@export var drain_rate: float = 10.0
@export var is_active: bool = false

var power_source: PowerSourceComponent

func _process(delta: float) -> void:
	if is_active and power_source:
		power_source.drain(drain_rate * delta)
		if not power_source.has_charge():
			is_active = false
