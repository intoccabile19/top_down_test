extends CharacterBody2D

@export var SPEED = 150.0
@export var SPRINT_MULTIPLIER = 2.0
@export var ACCELERATION = 2000.0
@export var FRICTION = 2000.0

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_state

func _ready():
	change_state("idle")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(new_state_name)
	if current_state:
		current_state.enter_state(self)

func _physics_process(delta: float) -> void:
	
	
	var target_speed = SPEED * (SPRINT_MULTIPLIER if is_running else 1.0)
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * target_speed, ACCELERATION * delta)
		
		# Rotate towards movement direction
		rotation = lerp_angle(rotation, direction.angle(), 0.15)
		player_sprite.play_animation("run" if is_running else "walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		player_sprite.play_animation("idle")

	move_and_slide()
