extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 100
const NOTE_HIT_MARGIN = 50

var baseIsDrawn = false
var circlePos
var current_radius : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	circlePos = Vector2(randf_range(0, VIEWPORT_X), randf_range(0, VIEWPORT_Y))
	_draw()

func _draw():
	if !baseIsDrawn:
		draw_circle(circlePos, MAX_RADIUS, Color(0.8, 0.8, 0.8))
		baseIsDrawn = true
		return
	
	draw_circle(circlePos, current_radius, Color(1, 1, 1))
	print(current_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var timeToHit = NOTE_HIT_MARGIN - Time.get_ticks_msec()
	if timeToHit < 0:
		queue_free()
	else:
		current_radius = MAX_RADIUS * (timeToHit / NOTE_HIT_MARGIN)
		_draw()
