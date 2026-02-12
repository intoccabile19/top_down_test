class_name LightController extends Node

@export var target_light: Light2D
@export var min_energy: float = 0.0
@export var max_energy: float = 1.0

var current_power_level: float = 0.0

func _ready() -> void:
	if not target_light and get_parent() is Light2D:
		target_light = get_parent()

func update_power(level: float) -> void:
	current_power_level = level
	_update_light_behavior()

func _process(delta: float) -> void:
	if current_power_level > 0 and current_power_level <= 0.25:
		_flicker_logic(delta)
	
func _update_light_behavior() -> void:
	if not target_light:
		return
		
	if current_power_level <= 0:
		target_light.energy = min_energy
	elif current_power_level > 0.5:
		target_light.energy = max_energy
	elif current_power_level > 0.25:
		target_light.energy = max_energy * 0.5
	# Else (0 < level <= 0.25) handled in _process for flickering

var flicker_timer: float = 0.0
func _flicker_logic(delta: float) -> void:
	if not target_light:
		return
		
	flicker_timer -= delta
	if flicker_timer <= 0:
		flicker_timer = randf_range(0.05, 0.2)
		target_light.energy = randf_range(min_energy, max_energy * 0.5)
