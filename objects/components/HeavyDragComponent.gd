class_name HeavyDragComponent extends Node2D

## Configuration
@export var parent_body: CharacterBody2D # The physics body to move
@export var drag_speed_multiplier: float = 0.5 # Slow down player to 50%
@export var drag_axis: Vector2 = Vector2.ZERO # If set, constrains movement to this axis (normalized)

# State
var is_dragging: bool = false
var dragging_user: Node2D = null
var original_speed_scale: float = 1.0

func _ready() -> void:
    if not parent_body:
        parent_body = get_parent() as CharacterBody2D
        if not parent_body:
             push_warning("HeavyDragComponent: Parent is not CharacterBody2D and no parent_body assigned!")

func start_interact(user: Node2D = null) -> void:
    if user and not is_dragging:
        is_dragging = true
        dragging_user = user
        
        # Slow down the user using MovementComponent
        var move_comp = user.get_node_or_null("MovementComponent") # Using %MovementComponent logic from player might be safer if exposed? 
        # But here we are external.
        if move_comp:
            # We assume we can access speed_scale or similar
            if "speed_scale" in move_comp:
                original_speed_scale = move_comp.speed_scale
                move_comp.speed_scale = drag_speed_multiplier
            
        # Optional: Parent the object to the player or use physics joints?
        # For a "Push/Pull" feel without physics joints, we can just move the object WITH the player
        # provided they are close enough.

func process_interact(delta: float) -> void:
    if not is_dragging or not dragging_user or not parent_body:
        return
        
    var input_comp = dragging_user.get_node_or_null("InputComponent")
    if not input_comp:
        return
        
    var move_dir = input_comp.move_dir
    
    if move_dir == Vector2.ZERO:
        return
        
    # Constrain axis if needed
    if drag_axis != Vector2.ZERO:
        # Project move_dir onto drag_axis
        var projected = move_dir.project(drag_axis)
        if projected.length() > 0:
             move_dir = projected.normalized() * move_dir.length() # Keep magnitude? or project fully?
        else:
             move_dir = Vector2.ZERO

    # Move the object
    # If we want the object to feel "heavy", it should lag or just move at the player's (reduced) speed.
    # Since we reduced player speed in start_interact, we can just match velocity?
    
    # 1. Direct Position (Telekinetic / Sticky)
    # parent_body.velocity = dragging_user.velocity 
    # parent_body.move_and_slide()
    
    # 2. Physics Push (Better for "Drag")
    # We apply a velocity to the object in the direction of the player's movement
    # But only if the player is moving "away" from it? 
    # Actually, for a simple implementation:
    # If the player moves, the object moves with them.
    
    # Let's try matching velocity for a "Grab and Drag" feel.
    if dragging_user is CharacterBody2D:
         parent_body.velocity = dragging_user.velocity
         parent_body.move_and_slide()
    
    # Ensure the player doesn't outrun the object if it hits a wall?
    # Complex physics. For now, simple velocity matching.

func stop_interact() -> void:
    if is_dragging and dragging_user:
        # Restore speed
        var move_comp = dragging_user.get_node_or_null("MovementComponent")
        if move_comp:
            if "speed_scale" in move_comp:
                move_comp.speed_scale = original_speed_scale # Restore
                
    is_dragging = false
    dragging_user = null
    if parent_body:
        parent_body.velocity = Vector2.ZERO
