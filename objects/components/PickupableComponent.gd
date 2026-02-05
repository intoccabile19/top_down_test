class_name PickupableComponent extends Node

@export var object_root: Node2D

func start_interact() -> void:
	pass
	
func interact_with_carrier(carrier: CarrierComponent) -> bool:
	if carrier and not carrier.is_carrying():
		carrier.pickup(object_root)
		return true
	return false

func try_pickup(user: Node) -> bool:
	var carrier = user.get_node_or_null("CarrierComponent")
	# If 'CarrierComponent' is not the exact name, this might fail, but consistent with existing code.
	# Safe to assume standard naming for now based on user context.
	if carrier:
		return interact_with_carrier(carrier)
	return false
