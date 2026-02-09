class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var speed := 150
@export var speed_mult := 2.0
@export var acceleration := 2000

@export var speed_scale: float = 1.0

var direction: Vector2 = Vector2.ZERO
var is_running := false

func tick(delta: float) -> void:
	if body == null:
		return
	
	var target_speed = speed * (speed_mult if is_running else 1.0) * speed_scale
	
	if direction != Vector2.ZERO:
		#Move on x and z plane
		body.velocity = body.velocity.move_toward(direction * target_speed, acceleration * delta)
			
		# Rotate towards movement direction
		body.global_rotation = lerp_angle(body.global_rotation, direction.angle(), 0.15)
		if is_running:
			sprite.play("run")
		else:
			sprite.play("walk")
		
		body.move_and_slide()
	else:
		sprite.play("idle")
