class_name ConversationComponent extends Node

signal conversation_started(initiator)
signal conversation_ended

@export var conversation_id: String = ""

# This interact function allows the InteractionComponent to trigger this component
func interact() -> void:
	start_conversation()

func start_conversation(initiator = null) -> void:
	print("Starting conversation: ", conversation_id)
	conversation_started.emit(initiator)
	# Logic to lock player or show UI would typically be triggered by the signal
