extends StaticBody2D

class_name HelmConsole

@export var ship_movement_component: Node

var is_interacting: bool = false
var interacting_user: Node2D = null

func start_interact(user: Node2D = null) -> void:
	is_interacting = true
	interacting_user = user
	
	if user:
		var cam = _get_user_camera(user)
		if cam:
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(cam, "zoom", Vector2(0.5, 0.5), 0.5)
			tween.tween_property(cam, "global_rotation", 0.0, 0.5)
			# We want to ignore parent rotation so it stays north-up
			# But Camera2D "ignore_rotation" is a property.
			cam.ignore_rotation = true

func process_interact(_delta: float) -> void:
	if not is_interacting:
		return
		
	# Check for Click
	if Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Get Global Mouse Position
		var target_pos = get_global_mouse_position()
		if ship_movement_component:
			ship_movement_component.set_target(target_pos)

func stop_interact() -> void:
	if is_interacting and interacting_user:
		var cam = _get_user_camera(interacting_user)
		if cam:
			cam.ignore_rotation = false # Re-enable inheritance (snaps to parent rotation)
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(cam, "zoom", Vector2(1.0, 1.0), 0.5)
			# We don't tween rotation back because it will snap to parent rotation when ignore_rotation is false.
			# If we want smooth return, we'd need to tween `rotation` to 0 (relative).
			tween.tween_property(cam, "rotation", 0.0, 0.5)

	is_interacting = false
	interacting_user = null

func _get_user_camera(user: Node2D) -> Camera2D:
	# Try to find camera in standard location
	if user.has_node("CameraAnchor/Camera2D"):
		return user.get_node("CameraAnchor/Camera2D")
	return null
