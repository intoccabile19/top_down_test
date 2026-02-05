extends StaticBody2D

@onready var receiver: ItemReceiverComponent = $ItemReceiverComponent
@onready var charger: PowerChargerComponent = $PowerChargerComponent
@onready var indicator: ColorRect = $Visuals/Indicator

func _ready() -> void:
	receiver.on_item_inserted.connect(_on_item_inserted)
	receiver.on_item_removed.connect(_on_item_removed)

func start_interact(user: Node) -> void:
	# Priority 1: Insert Battery if holding one
	if receiver.try_insert_from(user):
		return
	
	# Priority 2: Remove if loaded
	# Simple interact to remove for charger, or keep the hold logic?
	# User didn't specify hold for charger. I'll make it simple interact to remove for now.
	# Actually, to align with other machines preventing accidental removal, maybe hold is better?
	# For simplicity/speed of use, I'll use simple interact to take. 
	# If empty:
	if not receiver.has_item():
		return
		
	# If full:
	receiver.try_take_by(user)

func _process(_delta: float) -> void:
	if charger.target:
		# Visual feedback
		var ratio = charger.target.current_charge / charger.target.max_charge
		indicator.color = Color(0, 0.2 + (0.8 * ratio), 1.0, 1.0) # Blue-ish charging
	else:
		indicator.color = Color(0.1, 0.1, 0.1) # Off

func _on_item_inserted(item):
	var power = item.get_node_or_null("PowerSourceComponent")
	charger.target = power

func _on_item_removed(_item):
	charger.target = null
