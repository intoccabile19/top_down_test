class_name TalkingComponent extends Node

@export var float_duration: float = 2.0
@export var timeline: DialogicTimeline

const BUBBLE_SCENE = preload("res://addons/dialogic/Modules/DefaultLayoutParts/Layer_Textbubble/text_bubble.tscn")

var _canvas_layer: CanvasLayer

func _ready() -> void:
	_canvas_layer = CanvasLayer.new()
	add_child(_canvas_layer)

func interact() -> void:
	if timeline:
		start_timeline(timeline)

func say(text: String) -> void:
	if not BUBBLE_SCENE:
		printerr("TalkingComponent: Could not load Dialogic Text Bubble scene.")
		return
		
	var bubble = BUBBLE_SCENE.instantiate()
	_canvas_layer.add_child(bubble)
	
	# Configure Bubble
	bubble.node_to_point_at = get_parent()
	
	if bubble.text:
		bubble.text.text = text
	
	# Trigger open animation
	bubble.open()
	
	# Wait and close
	await get_tree().create_timer(float_duration).timeout
	
	if is_instance_valid(bubble):
		bubble.close()
		await get_tree().create_timer(0.5).timeout # Wait for close anim
		if is_instance_valid(bubble):
			bubble.queue_free()

func start_timeline(timeline_resource: DialogicTimeline) -> void:
	# Process the timeline to ensure events are loaded
	timeline_resource.process()
	
	for event in timeline_resource.events:
		if event is DialogicTextEvent:
			# Parse text using Dialogic to handle variables
			var parsed_text = DialogicUtil.autoload().Text.parse_text(event.text)
			await say(parsed_text)
			# Small buffer between bubbles?
			await get_tree().create_timer(0.2).timeout
