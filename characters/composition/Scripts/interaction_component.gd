class_name InteractionComponent extends Node

@export var interaction_source: RayCast2D

signal on_interact(target)

func interact() -> void:
	if interaction_source and interaction_source.is_colliding():
		var target = interaction_source.get_collider()
		if target.has_method("interact"):
			target.interact()
			on_interact.emit(target)
