class_name ShipMovementComponent extends Node

## Configuration
@export var ship_body: CharacterBody2D
@export var max_speed: float = 200.0
@export var acceleration: float = 100.0
@export var rotation_speed: float = 1.0 # Radians per second
@export var arrival_tolerance: float = 10.0
@export var slow_radius: float = 200.0

## State
var target_position: Vector2 = Vector2.ZERO
var has_target: bool = false
var current_marker: Node2D = null

var current_power_level: float = 0.0 # Default to 0, needs power to move? Or 1.0 for backwards compatibility? 
# Requirement implied "movement... affected". I'll default to 0.0 effectively stopping the ship if no power.

const MarkerScript = preload("res://objects/DestinationMarker.gd")

func update_power(level: float) -> void:
	current_power_level = level

func _ready() -> void:
	if not ship_body:
		ship_body = get_parent() as CharacterBody2D
		
func _exit_tree() -> void:
	_cleanup_marker()

func set_target(world_pos: Vector2) -> void:
	target_position = world_pos
	has_target = true
	_update_marker()

func clear_target() -> void:
	has_target = false
	_cleanup_marker()

func _update_marker() -> void:
	if not is_instance_valid(current_marker):
		current_marker = Node2D.new()
		current_marker.set_script(MarkerScript)
		ship_body.get_parent().add_child(current_marker)
		
	current_marker.global_position = target_position

func _cleanup_marker() -> void:
	if is_instance_valid(current_marker):
		current_marker.queue_free()
	current_marker = null

func _physics_process(delta: float) -> void:
	if not ship_body:
		return
		
	if has_target:
		var current_pos = ship_body.global_position
		var direction = current_pos.direction_to(target_position)
		var distance = current_pos.distance_to(target_position)
		
		# Stop completely if very close
		if distance < arrival_tolerance:
			ship_body.velocity = Vector2.ZERO
			has_target = false
			_cleanup_marker()
			return

		# Arrive Behavior (Slow down)
		var target_speed = max_speed
		if distance < slow_radius:
			target_speed = max_speed * (distance / slow_radius)
			
		# Apply power scaling
		# Logic: 
		# > 25% Power: 100% Speed
		# <= 25% Power: 50% Speed
		# 0% Power: 0% Speed
		
		var power_factor = 0.0
		if current_power_level > 0.25:
			power_factor = 1.0
		elif current_power_level > 0.0:
			power_factor = 0.5
		else:
			power_factor = 0.0
			
		target_speed *= power_factor
			
		var desired_velocity = direction * target_speed
		
		# Steering (Accelerate towards desired velocity)
		# Also scale acceleration by power factor to make it feel sluggish when low power
		ship_body.velocity = ship_body.velocity.move_toward(desired_velocity, acceleration * power_factor * delta)
		
		# Rotation
		# Only rotate if we are moving significantly or far enough away
		# This prevents spinning when very close or slow
		if direction.length_squared() > 0.001 and (distance > arrival_tolerance * 2.0 or ship_body.velocity.length() > 10.0):
			var desired_angle = direction.angle()
			ship_body.rotation = rotate_toward(ship_body.rotation, desired_angle, rotation_speed * delta)
			
	else:
		# Decelerate if no target
		ship_body.velocity = ship_body.velocity.move_toward(Vector2.ZERO, acceleration * delta)
		
	ship_body.move_and_slide()
