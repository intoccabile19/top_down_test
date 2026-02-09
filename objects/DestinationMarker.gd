extends Node2D

func _draw() -> void:
    draw_circle(Vector2.ZERO, 10, Color.RED)
    draw_arc(Vector2.ZERO, 15, 0, TAU, 32, Color.WHITE, 2.0)
