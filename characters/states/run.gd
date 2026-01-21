extends State

func physics_update(delta):
	# Ask the character for direction and sprint status
	var direction = character.get_movement_direction()
	var is_running = character.is_sprinting()
	
	var target_speed = character.SPEED * (character.SPRINT_MULTIPLIER)
	
	if direction != Vector2.ZERO and is_running:
		character.velocity = character.velocity.move_toward(direction * target_speed, character.ACCELERATION * delta)
		
		# Rotate towards movement direction
		character.rotation = lerp_angle(character.rotation, direction.angle(), 0.15)
		character.play_animation("run")
	elif direction != Vector2.ZERO and not is_running:
		state_machine.transition_to("walk")
	else:
		character.velocity = character.velocity.move_toward(Vector2.ZERO, character.FRICTION * delta)
		state_machine.transition_to("idle")

	character.move_and_slide()
	
	# Generic check: "Does this character (Player or NPC) want to interact?"
	if character.wants_to_interact():
		state_machine.transition_to("interact")
