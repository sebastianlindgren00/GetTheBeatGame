extends Node2D

var maxRadius
var color

func _draw():
		draw_circle(Vector2(0, 0), maxRadius, color)
