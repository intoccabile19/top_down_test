extends StaticBody2D

enum ChargeMode { CRANK, SPRING }

@export var current_mode: ChargeMode = ChargeMode.CRANK
@export var crank_decay: float = 0.5
@export var crank_charge_multiplier: float = 20.0
@export var spring_charge_amount: float = 5.0

# Component Links
@export var crank_component_path: NodePath
@export var spring_component_path: NodePath

@onready var receiver: ItemReceiverComponent = $ItemReceiverComponent
# We don't strictly need PowerChargerComponent if we implement custom logic here, 
# but we can keep it for the base rate if we want. 
# For now, I'll implement custom logic for the modes.
@onready var indicator: ColorRect = $Visuals/Indicator

var current_crank_level: float = 0.0
var external_power_level: float = 0.0

var _crank_node: CrankComponent
var _spring_node: SpringPushComponent

func _ready() -> void:
	receiver.on_item_inserted.connect(_on_item_inserted)
	receiver.on_item_removed.connect(_on_item_removed)
	
	if crank_component_path:
		_crank_node = get_node_or_null(crank_component_path)
		if _crank_node:
			_crank_node.on_crank_update.connect(_on_crank_updated)
			
	if spring_component_path:
		_spring_node = get_node_or_null(spring_component_path)
		if _spring_node:
			_spring_node.on_pulse.connect(_on_spring_pulse)

func _on_crank_updated(_total_rot, _progress):
	if current_mode == ChargeMode.CRANK:
		# Increase crank level (Momentum) based on activity
		# We don't get delta here, but we get updates. 
		# Let's say every update adds a bit of momentum
		current_crank_level = min(1.0, current_crank_level + 0.1)

func _on_spring_pulse():
	if current_mode == ChargeMode.SPRING:
		var target = _get_battery_power_comp()
		if target:
			target.add_charge(spring_charge_amount)
			_update_visuals(target) # Force visual update

func update_power(level: float) -> void:
	external_power_level = level

func _process(delta: float) -> void:
	# Crank Decay
	if current_mode == ChargeMode.CRANK:
		current_crank_level = max(0.0, current_crank_level - (crank_decay * delta))
	
	# Calculate total charging power
	var total_power = external_power_level
	if current_mode == ChargeMode.CRANK:
		total_power += current_crank_level
		
	# Apply charge to battery
	var target_battery = _get_battery_power_comp()
	if target_battery and total_power > 0:
		target_battery.add_charge(total_power * crank_charge_multiplier * delta)
		
	# Visuals
	_update_visuals(target_battery)

func start_interact(user: Node) -> void:
	# Priority 1: Insert Battery if holding one
	if receiver.try_insert_from(user):
		return
		
	# Priority 2: Take Battery if loaded
	if receiver.has_item():
		receiver.try_take_by(user)
		return

func stop_interact() -> void:
	# No internal interaction state to stop
	pass

# Helper to get the battery component
func _get_battery_power_comp() -> PowerSourceComponent:
	if receiver.has_item():
		var item = receiver.current_item
		return item.get_node_or_null("PowerSourceComponent")
	return null

func process_interact(_delta: float) -> void:
	pass

func _update_visuals(target: PowerSourceComponent) -> void:
	if target:
		var ratio = target.current_charge / target.max_charge
		var brightness = 0.2 + (0.8 * ratio)
		
		if current_mode == ChargeMode.CRANK and current_crank_level > 0:
			# Flash or brighten when cranking
			brightness += current_crank_level * 0.5
			
		indicator.color = Color(0, brightness, 1.0, 1.0) 
	else:
		indicator.color = Color(0.1, 0.1, 0.1)

func _on_item_inserted(_item):
	pass

func _on_item_removed(_item):
	pass
