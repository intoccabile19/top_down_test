class_name ShipGravityComponent extends Node

## Configuration
@export var gravity_area: Area2D
@export var ship_body: Node2D # The ship root to parent to. Defaults to parent if not set.

# We keep track of things on board just in case we need to force update
var onboard_bodies: Array[Node2D] = []

func _ready() -> void:
    if not gravity_area:
        push_warning("ShipGravityComponent: No gravity_area assigned!")
        return
        
    if not ship_body:
        ship_body = get_parent() as Node2D
        
    print("ShipGravityComponent Ready. Ship Body: ", ship_body.name if ship_body else "NULL")
        
    gravity_area.body_entered.connect(_on_body_entered)
    gravity_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
    # Check if it's something we want to carry (Player, NPC, Items)
    
    if body == ship_body:
        return # Don't reparent self
        
    print("Gravity Area Entered by: ", body.name, " (Type: ", body.get_class(), ")")
        
    # Allow CharacterBody2D, RigidBody2D, and StaticBody2D (for placing items)
    if body is CharacterBody2D or body is RigidBody2D or body is StaticBody2D: 
        
        if body.get_parent() != ship_body:
            print("Reparenting ", body.name, " to Ship (", ship_body.name, ")")
            # Use call_deferred to avoid physics locking
            body.call_deferred("reparent", ship_body, true)
            if not body in onboard_bodies:
                onboard_bodies.append(body)
        else:
            print("Skipping reparent: ", body.name, " is already a child of Ship.")
    else:
        print("Skipping reparent: ", body.name, " is not a valid physics body type.")

func _on_body_exited(body: Node2D) -> void:
    print("Gravity Area Exited by: ", body.name)
    if body in onboard_bodies:
        # Reparent to the main world scene.
        var world = get_tree().current_scene
        
        # If the ship is the scene root, this logic handles it gracefully usually
        if world and body.get_parent() == ship_body:
            print("Reparenting ", body.name, " to World")
            body.call_deferred("reparent", world, true)
            onboard_bodies.erase(body)

## Safety Check
# Sometimes triggers miss if moving fast?
# Periodic check could be added if needed.
