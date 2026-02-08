extends CharacterBody2D

@onready var drag_component: HeavyDragComponent = $HeavyDragComponent

# Forward interaction to component
func start_interact(user = null) -> void:
    if drag_component:
        drag_component.start_interact(user)

func process_interact(delta: float) -> void:
    if drag_component:
        drag_component.process_interact(delta)

func stop_interact() -> void:
    if drag_component:
        drag_component.stop_interact()
