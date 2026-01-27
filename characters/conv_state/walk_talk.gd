extends convState

func enter():
	print("WALK TALKING")
	character.update_label("WIN")

	var wait_time = 1.3 # Default fallback

	# Use a one-shot timer to return to movement
	get_tree().create_timer(wait_time).timeout.connect(
		func(): conv_state_machine.transition_to("not_talk")
	)
