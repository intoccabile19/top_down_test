extends CharacterBody2D

# Simple glue script, components handle the rest.
# We verify setup here.

@onready var gravity_component = $ShipGravityComponent
@onready var movement_component = $ShipMovementComponent

func _ready() -> void:
	pass
