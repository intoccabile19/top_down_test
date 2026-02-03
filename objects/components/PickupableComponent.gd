class_name PickupableComponent extends Node

@export var object_root: Node2D

func start_interact() -> void:
    # This will be called by interaction component
    # We need to find who interacted. 
    # Current interaction system emits 'target' but the caller is the player.
    # The player calls 'start_interact' on THIS object.
    # We need a way to reference the interact-er.
    pass
    
func interact_with_carrier(carrier: CarrierComponent) -> void:
    if carrier and not carrier.is_carrying():
        carrier.pickup(object_root)
