extends StaticBody2D

@onready var spring_component: SpringPushComponent = $SpringPushComponent

func start_interact(_user = null) -> void:
	if spring_component:
		spring_component.start_interact()

func process_interact(delta: float) -> void:
	if spring_component:
		spring_component.process_interact(delta)

func stop_interact() -> void:
	if spring_component:
		spring_component.stop_interact()
