class_name CompPlayer extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var interaction_component: InteractionComponent = %InteractionComponent
@onready var carrier_component: CarrierComponent = $CarrierComponent

func _ready() -> void:
	health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	#Read Input Controls
	input_component.update()
	
	#Read Movement Component
	movement_component.direction = input_component.move_dir
	movement_component.is_running = input_component.run_held
	movement_component.tick(delta)

	#handle heal and hurt
	if input_component.hurt_pressed:
		health_component.damage(10)
		
	if input_component.heal_pressed:
		health_component.heal(10)

	#handle interaction
	#handle interaction
	if input_component.interact_pressed:
		interaction_component.start_interact()
	elif input_component.interact_held:
		interaction_component.process_interact(delta)
	elif input_component.interact_released:
		interaction_component.stop_interact()
		
func _on_died() -> void:
	print("player died")
