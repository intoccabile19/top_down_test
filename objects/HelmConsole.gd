extends StaticBody2D

class_name HelmConsole

@export var ship_movement_component: Node

var is_interacting: bool = false
var interacting_user: Node2D = null

func start_interact(user: Node2D = null) -> void:
	is_interacting = true
	interacting_user = user
	# print("Helm Activated. Click to set destination.")
	
	# Optional: Show UI or Cursor

func process_interact(_delta: float) -> void:
	if not is_interacting:
		return
		
	# Check for Click
	if Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Get Global Mouse Position
		var target_pos = get_global_mouse_position()
		if ship_movement_component:
			ship_movement_component.set_target(target_pos)
			 
		# Visual Feedback?
		 
func stop_interact() -> void:
	is_interacting = false
	interacting_user = null
	# print("Helm Deactivated.")
