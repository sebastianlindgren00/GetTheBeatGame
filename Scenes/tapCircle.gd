extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const RADIUS = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	_draw()

func _draw():

	var circlePos = Vector2(randf_range(0, VIEWPORT_X), randf_range(0, VIEWPORT_Y))
	draw_circle(circlePos, RADIUS, Color(0.8, 0.8, 0.8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
