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
	if body == ship_body:
		return # Don't reparent self

	# Allow CharacterBody2D, RigidBody2D, and StaticBody2D (for placing items)
	if body is CharacterBody2D or body is RigidBody2D or body is StaticBody2D: 
		
		# PASSIVE ADOPTION RULE:
		# Only take objects that are floating in the "World" (child of current scene or ship's parent).
		# If an object is child of something else (like a Player's hand), LEAVE IT ALONE.
		
		var parent = body.get_parent()
		var world = get_tree().current_scene
		
		# Check if parent is the world or the space the ship is in
		if parent == world or parent == ship_body.get_parent():
			print("Reparenting ", body.name, " to Ship (", ship_body.name, ") - Was child of ", parent.name)
			# Use call_deferred to avoid physics locking
			body.call_deferred("reparent", ship_body, true)
			if not body in onboard_bodies:
				onboard_bodies.append(body)
		else:
			# It's parented to something else (e.g. Player, another container), so we respect that.
			print("Skipping reparent: ", body.name, " is attached to ", parent.name)
			
	else:
		print("Skipping reparent: ", body.name, " is not a valid physics body type.")

func _on_body_exited(body: Node2D) -> void:
	# If the body is disabled, it means it's likely being picked up or managed by another system.
	# We should NOT eject it to the world in this case.
	if body.process_mode == Node.PROCESS_MODE_DISABLED:
		return
		
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
