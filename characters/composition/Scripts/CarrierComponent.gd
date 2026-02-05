class_name CarrierComponent extends Node2D

@export var hold_point: Node2D
@export var drop_distance: float = 50.0

signal on_weight_changed(weight)

var carried_object: Node2D = null
var current_weight: float = 0.0

func _ready() -> void:
	if not hold_point:
		hold_point = self

func is_carrying() -> bool:
	return carried_object != null

func pickup(object: Node2D) -> void:
	if is_carrying():
		return
	
	# Reparent object to hold point
	if object.get_parent():
		object.get_parent().remove_child(object)
	hold_point.add_child(object)
	object.position = Vector2.ZERO
	object.rotation = 0
	carried_object = object
	
	# Handle Weight
	current_weight = 0.0
	# Try to find PickupableComponent on the object or its children
	# Simplest way: Check if object has 'pickup_component' property or find child
	# Current BatteryItem has $PickupableComponent.
	var pickup_comp = object.get_node_or_null("PickupableComponent")
	if pickup_comp and "weight" in pickup_comp:
		current_weight = pickup_comp.weight
		
	on_weight_changed.emit(current_weight)
	
	# Disable physics if applicable
	if object is CollisionObject2D:
		object.process_mode = Node.PROCESS_MODE_DISABLED

func drop() -> void:
	if not is_carrying():
		return
		
	var object = carried_object
	
	# Reset Weight
	current_weight = 0.0
	on_weight_changed.emit(0.0)
	
	hold_point.remove_child(object)
	
	# Re-add to main scene (usually the parent of the character, or a specific container)
	# For now, adding to the character's parent (the world)
	get_owner().get_parent().add_child(object)
	
	# Calculate drop position interact front of the character
	var drop_vector = Vector2.RIGHT.rotated(get_owner().global_rotation)
	object.global_position = global_position + (drop_vector * drop_distance)
	
	# Re-enable physics
	if object is CollisionObject2D:
		object.process_mode = Node.PROCESS_MODE_INHERIT
		
	carried_object = null

func get_carried_object() -> Node2D:
	return carried_object
