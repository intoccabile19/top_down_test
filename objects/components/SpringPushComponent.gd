class_name SpringPushComponent extends Node2D

@export var target_visual_node: Node2D
@export var push_axis: Vector2 = Vector2(0, -1) # Default push up
@export var max_push_distance: float = 32.0
@export var push_speed: float = 100.0
@export var spring_stiffness: float = 200.0
@export var damping: float = 10.0

signal on_pulse()

var current_displacement: float = 0.0
var velocity: float = 0.0
var is_being_pushed: bool = false
var has_pulsed: bool = false

func _ready() -> void:
	if not target_visual_node:
		push_warning("SpringPushComponent: No target_visual_node assigned!")

func _physics_process(delta: float) -> void:
	if is_being_pushed:
		# Pushing logic
		current_displacement = move_toward(current_displacement, max_push_distance, push_speed * delta)
		
		# Check for pulse check (e.g. at 90% throw)
		if not has_pulsed and abs(current_displacement) >= max_push_distance * 0.9:
			on_pulse.emit()
			has_pulsed = true
			
	else:
		# Spring physics logic (Hooke's Law with damping)
		var force = -spring_stiffness * current_displacement - damping * velocity
		velocity += force * delta
		current_displacement += velocity * delta
		
		# Reset pulse flag when returned near 0
		if abs(current_displacement) < max_push_distance * 0.1:
			has_pulsed = false
		
		# Stop small oscillations
		if abs(current_displacement) < 0.1 and abs(velocity) < 1.0:
			current_displacement = 0.0
			velocity = 0.0

	# Apply position
	if target_visual_node:
		target_visual_node.position = push_axis.normalized() * current_displacement

func start_interact() -> void:
	is_being_pushed = true
	# Reset velocity when starting to push? Or keep momentum? 
	# Resetting feels more "controlled" for a push.
	velocity = 0.0 

func process_interact(_delta: float) -> void:
	# Taking delta here if needed, but managing state in _physics_process 
	# allows for consistent spring physics in one place.
	pass

func stop_interact() -> void:
	is_being_pushed = false
