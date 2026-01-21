extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_query: RayCast2D = $RayCast2D # Or Area2D

@export var SPEED = 150.0
@export var SPRINT_MULTIPLIER = 2.0
@export var ACCELERATION = 2000.0
@export var FRICTION = 2000.0

func _ready() -> void:
# Wait for the Parent (the Player) to be ready
	await get_parent().ready
	animated_sprite.play("idle")

func play_animation(anim_name):
	if animated_sprite == null:
		return
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

func get_current_interactable():
	if interaction_query.is_colliding():
		return interaction_query.get_collider()
	return null

# Inside your Player script
func get_movement_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func is_sprinting() -> bool:
	return Input.is_action_pressed("run")
	
func wants_to_interact() -> bool:
	return Input.is_action_just_pressed("interact")
