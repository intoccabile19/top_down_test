class_name InteractionComponent extends Node

@export var interaction_source: RayCast2D

signal on_interact(target)

var current_target: Node

func interact() -> void:
	# Legacy support for just pressed
	start_interact()
	stop_interact()

func start_interact() -> void:
	if interaction_source and interaction_source.is_colliding():
		var target = interaction_source.get_collider()
		
		# If we are already interacting with this target, ignore
		if current_target == target:
			return
			
		current_target = target
		
		# Try start_interact first, fallback to interact
		if target.has_method("start_interact"):
			target.start_interact()
			on_interact.emit(target)
		elif target.has_method("interact"):
			target.interact()
			on_interact.emit(target)
	else:
		current_target = null

func process_interact(delta: float) -> void:
	if is_instance_valid(current_target) and current_target.has_method("process_interact"):
		current_target.process_interact(delta)

func stop_interact() -> void:
	if is_instance_valid(current_target):
		if current_target.has_method("stop_interact"):
			current_target.stop_interact()
	
	current_target = null
