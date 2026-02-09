extends StaticBody2D

@onready var crank_component: CrankComponent = $CrankComponent
@onready var label: Label = $Label # Optional, for feedback

func _ready() -> void:
	if crank_component:
		crank_component.on_crank_update.connect(_on_crank_update)
		crank_component.on_crank_complete.connect(_on_crank_complete)

func _on_crank_update(_total_val: float, progress: float) -> void:
	if label:
		label.text = "Crank: %.0f%%" % (progress * 100)
	# Can also drive other things here, e.g. a gate opening

func _on_crank_complete() -> void:
	if label:
		label.text = "OPEN!"
	# Trigger event
	print("Crank completed!")

# Forward interaction to component
func start_interact(user = null) -> void:
	if crank_component:
		crank_component.start_interact(user)

func process_interact(delta: float) -> void:
	if crank_component:
		crank_component.process_interact(delta)

func stop_interact() -> void:
	if crank_component:
		crank_component.stop_interact()
