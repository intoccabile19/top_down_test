extends convState

func enter():
	print("NOT TALKING")
	character.update_label("")
	
	var wait_time = 2 # Default fallback

	# Use a one-shot timer to return to movement
	get_tree().create_timer(wait_time).timeout.connect(
		func(): conv_state_machine.transition_to("walk_talk")
	)
