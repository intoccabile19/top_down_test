class_name InputComponent extends Node

@export var debugOn := false

var move_dir: Vector2 = Vector2.ZERO
var run_held := false
var interact_pressed := false
var interact_held := false
var interact_released := false
var heal_pressed := false
var hurt_pressed := false

func update() -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	run_held = Input.is_action_pressed("run")
	interact_pressed = Input.is_action_just_pressed("interact")
	# Add held and released states
	if Input.is_action_pressed("interact"):
		run_held = false # Cannot run while interacting? Optional design choice, keeping it simple for now
	
	interact_held = Input.is_action_pressed("interact")
	interact_released = Input.is_action_just_released("interact")

	heal_pressed = Input.is_action_just_pressed("heal_button")
	hurt_pressed = Input.is_action_just_pressed("hurt_button")
	debug()

func debug() -> void:
	if debugOn == true:
		print(move_dir)
		print(interact_pressed)
