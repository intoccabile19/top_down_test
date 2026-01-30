extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var talking_component: TalkingComponent = $TalkingComponent
const TEST_BASIC_DIALOGUE = preload("uid://dugxqaxe1fqsk")

func _ready():
	animated_sprite_2d.play("idle")
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func interact():
	print("INTERACTION WORKED")
	if talking_component:
		talking_component.start_timeline(TEST_BASIC_DIALOGUE)
