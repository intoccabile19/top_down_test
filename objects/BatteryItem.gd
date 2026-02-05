extends StaticBody2D

@onready var pickup_component: PickupableComponent = $PickupableComponent
@onready var power_component: PowerSourceComponent = $PowerSourceComponent
@onready var visual_body: ColorRect = $Visuals/Body

func _ready() -> void:
	if power_component:
		power_component.on_charge_changed.connect(_on_charge_changed)

func start_interact(user: Node = null) -> void:
	if user:
		pickup_component.try_pickup(user)

func _on_charge_changed(current, max_val):
	# Dim color based on charge
	var ratio = current / max_val
	visual_body.color = Color(0.2 * ratio, 0.8 * ratio, 0.2 * ratio, 1.0)
