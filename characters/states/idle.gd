extends State

func enter():
	# Safety check to ensure character is there
	if character:
		character.play_animation("idle")

func physics_update(_delta): # Use physics_update for continuous movement checks
	var direction = character.get_movement_direction()
	var is_running = character.is_sprinting()
	
	if direction != Vector2.ZERO:
		if is_running:
			state_machine.transition_to("run")
		else:
			state_machine.transition_to("walk")
	elif character.wants_to_interact():
		state_machine.transition_to("interact")
