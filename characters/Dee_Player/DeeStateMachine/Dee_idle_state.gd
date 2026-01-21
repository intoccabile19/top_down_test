extends DeePlayerState

func enter_state(player_node):
	super(player_node)
	player.velocity = 0

func handle_input(_delta):
	var direction = get_movement_direction()
	var is_running = is_sprinting()
	
	if direction and not is_running:
		player.change_state("walk")
	elif direction and is_running:
		player.change_state("run")
	
func get_movement_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func is_sprinting() -> bool:
	return Input.is_action_pressed("run")
