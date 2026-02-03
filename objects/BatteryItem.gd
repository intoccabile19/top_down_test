extends StaticBody2D

@onready var pickup_component: PickupableComponent = $PickupableComponent
@onready var power_component: PowerSourceComponent = $PowerSourceComponent
@onready var visual_body: ColorRect = $Visuals/Body

func _ready() -> void:
	if power_component:
		power_component.on_charge_changed.connect(_on_charge_changed)

func start_interact(user: Node = null) -> void:
	if user:
		try_pickup(user) 
	
# Temporarily, will rely on the Player's script to call pickup manually 
# OR distinct interact() logic on the player side.
# Actually, the player's InteractionComponent logic calls `target.start_interact()`.
# If I change `start_interact` to `start_interact(user)`, I break the interface unless I update everything.
# Alternative: The Player checks if target has `pickup` method?
# Let's add a `try_pickup(user)` method here.

func try_pickup(user: Node) -> void:
	var carrier = user.get_node_or_null("CarrierComponent")
	if carrier and pickup_component:
		pickup_component.interact_with_carrier(carrier)

func _on_charge_changed(current, max_val):
	# Dim color based on charge
	var ratio = current / max_val
	visual_body.color = Color(0.2 * ratio, 0.8 * ratio, 0.2 * ratio, 1.0)
