extends State

func physics_update(delta):
	# Ask the character for direction and sprint status
	var direction = character.get_movement_direction()
	var is_running = character.is_sprinting()
	
	var target_speed = character.SPEED * (character.SPRINT_MULTIPLIER if is_running else 1.0)
	
	if direction != Vector2.ZERO:
		character.velocity = character.velocity.move_toward(direction * target_speed, character.ACCELERATION * delta)
		
		# Rotate towards movement direction
		character.rotation = lerp_angle(character.rotation, direction.angle(), 0.15)
		character.play_animation("run" if is_running else "walk")
	else:
		character.velocity = character.velocity.move_toward(Vector2.ZERO, character.FRICTION * delta)
		character.play_animation("idle")

	character.move_and_slide()
	
	# Generic check: "Does this character (Player or NPC) want to interact?"
	if character.wants_to_interact():
		state_machine.transition_to("interact")
