class_name CarrierComponent extends Node2D

@export var hold_point: Node2D

var carried_object: Node2D = null

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
	
	# Disable physics if applicable
	if object is CollisionObject2D:
		object.process_mode = Node.PROCESS_MODE_DISABLED

func drop() -> void:
	if not is_carrying():
		return
		
	var object = carried_object
	hold_point.remove_child(object)
	
	# Re-add to main scene (usually the parent of the character, or a specific container)
	# For now, adding to the character's parent (the world)
	get_owner().get_parent().add_child(object)
	object.global_position = global_position
	
	# Re-enable physics
	if object is CollisionObject2D:
		object.process_mode = Node.PROCESS_MODE_INHERIT
		
	carried_object = null

func get_carried_object() -> Node2D:
	return carried_object
