class_name CrankComponent extends Node2D

## Signals
signal on_crank_update(current_value: float, normalized_value: float)
signal on_crank_complete()

## Configuration
@export var target_visual_node: Node2D
@export var min_angle: float = 0.0
@export var max_angle: float = 360.0
@export var rotation_speed: float = 180.0 # Degrees per second
@export var auto_return: bool = false
@export var return_speed: float = 90.0
@export var required_rotations: int = 1 # How many full circles (or equivalent angle) needed
@export var drag_sensitivity: float = 0.5 # Sensitivity of mouse/stick movement to rotation

## State
var current_angle: float = 0.0
var total_rotation: float = 0.0
var is_interacting: bool = false
var interacting_user: Node2D = null
var last_mouse_position: Vector2 = Vector2.ZERO
var original_speed_scale: float = 1.0

func _ready() -> void:
    if not target_visual_node:
        push_warning("CrankComponent: No target_visual_node assigned!")

func _process(delta: float) -> void:
    if not is_interacting and auto_return:
        _process_return(delta)

func start_interact(user: Node2D = null) -> void:
    is_interacting = true
    interacting_user = user
    if user:
         # Lock player movement
        var move_comp = user.get_node_or_null("MovementComponent")
        # Try to find it via unique name if not direct child (common in composition)
        if not move_comp and user.has_node("%MovementComponent"):
            move_comp = user.get_node("%MovementComponent")
            
        if move_comp and "speed_scale" in move_comp:
            original_speed_scale = move_comp.speed_scale
            move_comp.speed_scale = 0.0

func process_interact(delta: float) -> void:
    if not interacting_user:
        return
        
    var input_dir = Vector2.ZERO
    
    # Try to get input from user's InputComponent
    var input_comp = interacting_user.get_node_or_null("InputComponent")
    if not input_comp and interacting_user.has_node("InputComponent"):
         input_comp = interacting_user.get_node("InputComponent")
         
    if input_comp:
        input_dir = input_comp.move_dir
    else:
        # Fallback to global input if direct component access fails (less ideal)
        input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if input_dir.length_squared() > 0.01:
        # Calculate rotation based on input direction relative to crank center
        # OR just use left/right to rotate
        # Let's simple "Push" logic: Moving in the direction of the crank handle? 
        # Simpler for now: Left/Right or A/D rotates the crank
        
        var rotation_change = input_dir.x * rotation_speed * delta
        _rotate_crank(rotation_change)

func stop_interact() -> void:
    if is_interacting and interacting_user:
        # Restore speed
        var move_comp = interacting_user.get_node_or_null("MovementComponent")
        if not move_comp and interacting_user.has_node("%MovementComponent"):
            move_comp = interacting_user.get_node("%MovementComponent")
            
        if move_comp and "speed_scale" in move_comp:
            move_comp.speed_scale = original_speed_scale

    is_interacting = false
    interacting_user = null

func _rotate_crank(amount: float) -> void:
    current_angle += amount
    total_rotation += amount
    
    # Clamp if limits exist (e.g. valve that stops)
    if not required_rotations == 0: # 0 means infinite
         # Logic for limited rotation could go here
         pass
         
    if target_visual_node:
        target_visual_node.rotation_degrees = current_angle
        
    # Check completion
    var target_total = required_rotations * 360.0
    var progress = clamp(total_rotation / target_total, 0.0, 1.0) if target_total != 0 else 0.0
    
    on_crank_update.emit(total_rotation, progress)
    
    if abs(total_rotation) >= target_total and target_total > 0:
        on_crank_complete.emit()

func _process_return(delta: float) -> void:
    if abs(current_angle) > 0.1:
        var return_step = return_speed * delta * -sign(current_angle)
        
        # Don't overshoot 0
        if abs(return_step) > abs(current_angle):
            current_angle = 0
            total_rotation = 0 # Reset total on return? Depends on game logic.
        else:
             current_angle += return_step
             # Assuming total rotation tracks net rotation, we might not want to reset it fully if it's a "charge up"
             # But for a spring-loaded switch, yes.
             
        if target_visual_node:
            target_visual_node.rotation_degrees = current_angle
            
        on_crank_update.emit(current_angle, 0.0) # Reset progress
