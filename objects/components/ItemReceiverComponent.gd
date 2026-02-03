class_name ItemReceiverComponent extends Node2D

signal on_item_inserted(item)
signal on_item_removed(item)

@export var accepted_group: String = "battery"
@export var visual_socket: Node2D

var current_item: Node2D

func has_item() -> bool:
	return current_item != null

func insert_item(item: Node2D) -> bool:
	if has_item():
		return false
		
	if not item.is_in_group(accepted_group):
		return false
		
	current_item = item
	
	# Reparent
	item.get_parent().remove_child(item)
	(visual_socket if visual_socket else self).add_child(item)
	item.position = Vector2.ZERO
	item.rotation = 0
	
	# Disable physics
	if item is CollisionObject2D:
		item.process_mode = Node.PROCESS_MODE_DISABLED
		
	on_item_inserted.emit(item)
	return true

func remove_item() -> Node2D:
	if not has_item():
		return null
		
	var item = current_item
	(visual_socket if visual_socket else self).remove_child(item)
	current_item = null
	
	on_item_removed.emit(item)
	return item
