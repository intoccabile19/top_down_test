class_name ManualGenerator extends StaticBody2D

@export var linked_components: Array[NodePath]
@onready var indicator: ColorRect = $Visuals/Indicator # Assuming a visual structure similar to others

var _linked_nodes: Array[Node] = []
var is_active: bool = false

func _ready() -> void:
	# Cache linked nodes
	for path in linked_components:
		var node = get_node_or_null(path)
		if node:
			_linked_nodes.append(node)

func start_interact(_user: Node) -> void:
	is_active = true
	_update_power(1.0)
	_update_visuals()

func stop_interact() -> void:
	is_active = false
	_update_power(0.0)
	_update_visuals()
	
func _update_power(level: float) -> void:
	for node in _linked_nodes:
		if node.has_method("update_power"):
			node.update_power(level)

func _update_visuals() -> void:
	if not indicator:
		return
		
	if is_active:
		indicator.color = Color(0, 1, 0) # Green
	else:
		indicator.color = Color(0.2, 0, 0) # Off
