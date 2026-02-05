extends StaticBody2D

@onready var receiver: ItemReceiverComponent = $ItemReceiverComponent
@onready var consumer: PowerConsumerComponent = $PowerConsumerComponent
@onready var switch_comp: SwitchComponent = $SwitchComponent
@onready var indicator: ColorRect = $Visuals/Indicator

var current_interactor : Node

func _ready() -> void:
	receiver.on_item_inserted.connect(_on_item_inserted)
	receiver.on_item_removed.connect(_on_item_removed)
	switch_comp.toggled.connect(_on_switched)

func _process(_delta: float) -> void:
	# Visual update for indicator
	if switch_comp.is_on and consumer.is_active:
		indicator.color = Color(0, 1, 0) # Green ON
	elif switch_comp.is_on and not consumer.is_active:
		indicator.color = Color(1, 0, 0) # Red Error/Empty
	else:
		indicator.color = Color(0.2, 0, 0) # Off

func start_interact(user: Node) -> void:
	current_interactor = user
	var carrier = user.get_node_or_null("CarrierComponent")
	
	# Priority 1: Insert Battery if holding one
	if receiver.try_insert_from(user):
		return
	
	# Priority 2: Toggle Switch if loaded
	if receiver.has_item():
		switch_comp.toggle()
		update_consumer_state()

var user_holding_interact_for: float = 0.0

func process_interact_logic(delta: float, user: Node) -> void:
	if not receiver.has_item():
		return
		
	user_holding_interact_for += delta
	if user_holding_interact_for > 0.5: # 0.5 sec hold to remove
		if receiver.try_take_by(user):
			user_holding_interact_for = 0.0
			# Turn off
			switch_comp.set_state(false)
			update_consumer_state()

func process_interact(delta: float) -> void:
	if current_interactor:
		process_interact_logic(delta, current_interactor)

func stop_interact() -> void:
	current_interactor = null

func _on_item_inserted(item):
	var power = item.get_node_or_null("PowerSourceComponent")
	consumer.power_source = power
	update_consumer_state()

func _on_item_removed(_item):
	consumer.power_source = null
	update_consumer_state()

func _on_switched(_state):
	update_consumer_state()

func update_consumer_state():
	if switch_comp.is_on and receiver.has_item():
		consumer.is_active = true
	else:
		consumer.is_active = false
