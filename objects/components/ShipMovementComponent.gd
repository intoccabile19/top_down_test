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

const MarkerScript = preload("res://objects/DestinationMarker.gd")

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
			
		var desired_velocity = direction * target_speed
		
		# Steering (Accelerate towards desired velocity)
		ship_body.velocity = ship_body.velocity.move_toward(desired_velocity, acceleration * delta)
		
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
