extends State

func enter():
	character.velocity = Vector2.ZERO
	character.play_animation("interact")
	
	# Check for nearby interactables (Assumes a RayCast2D or Area2D on player)
	var interactable = character.get_current_interactable()
	if interactable:
		interactable.interact() # This triggers the Dialogue or Object logic
	
		# If the target starts a conversation, the Dialogue Manager 
		# will usually take control. If it's just a quick interaction:
		if not interactable.is_conversation:
			state_machine.transition_to("locomotion")
	else:
		state_machine.transition_to("locomotion")

func exit():
	# This clears the input buffer so Locomotion doesn't 
	# immediately think you clicked again.
	Input.action_release("interact")
