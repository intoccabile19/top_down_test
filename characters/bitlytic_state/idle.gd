extends Bitlytic_State
class_name idle

@export var enemy : CharacterBody2D
@export var move_speed:= 100.0
@onready var nav2d = $"../../NavigationAgent2D"

var move_direction : Vector2
var wander_time : float


func randomize_wander():
	move_direction = Vector2(randf_range(-5, 5), randf_range(-5, 5)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
		enemy.rotation = lerp_angle(enemy.rotation, move_direction.angle(), 0.15)
	else:
		randomize_wander()

func Physics_Update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
