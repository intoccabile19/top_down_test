class_name TalkingComponent extends Node

@export var float_height: float = 50.0
@export var float_duration: float = 1.5
@export var font_color: Color = Color.WHITE
@export var outline_color: Color = Color.BLACK

func say(text: String) -> void:
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_color_override("font_outline_color", outline_color)
	label.add_theme_constant_override("outline_size", 4)
	
	# Position slightly above parent if possible
	var parent = get_parent()
	if parent is Node2D:
		label.position = Vector2(-label.size.x / 2, -50) # Initial offset guess, will center after size calc
		# Add to parent so it follows, or add to generic world/gui layer? 
		# For simple overhead, adding to parent is easiest.
		parent.add_child(label)
		
		# Center horizontally after adding (and sizing)
		label.force_update_transform() # Ensure size is calculated
		label.position.x = -label.size.x / 2
		label.position.y = -label.size.y # Move up by its own height
	else:
		return # Can't position if parent isn't Node2D

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - float_height, float_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, float_duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await tween.finished
	label.queue_free()
