extends Node2D

var maxRadius
const COLOR = Color(1, 1, 1)

func _draw():
		draw_circle(Vector2(0, 0), maxRadius, COLOR)
