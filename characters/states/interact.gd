extends State

func enter():
	character.velocity = Vector2.ZERO
	character.play_animation("interact")
	
	var target = character.get_current_interactable()
	var wait_time = 1.3 # Default fallback
	
	if target:
		target.interact()
		if target.is_conversation:
			return # Let dialogue manager handle the exit
		wait_time = target.interaction_time
	
	# Use a one-shot timer to return to movement
	get_tree().create_timer(wait_time).timeout.connect(
		func(): state_machine.transition_to("idle")
	)

func exit():
	# This clears the input buffer so Locomotion doesn't 
	# immediately think you clicked again.
	Input.action_release("interact")
