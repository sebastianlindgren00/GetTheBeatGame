extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 50

var circlePos # Position of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var currentRadius: float = 0 # Current radius of the circle
var animCircle: Node2D # Reference to the child circle node
var spawnTime: int = 0 # Time when the note was spawned

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Note ready ", noteHitTimeout, " ms to hit!")
	spawnTime = Time.get_ticks_msec()

	# Set circle position
	while true:
		circlePos = Vector2(randf_range(0, VIEWPORT_X), randf_range(0, VIEWPORT_Y))
		if circlePos.distance_to(Vector2(VIEWPORT_X / 2.0, VIEWPORT_Y / 2.0)) < VIEWPORT_X / 2.0 - MAX_RADIUS:
			break
	self.position = circlePos

	# Get child circle node to animate and set its radius
	animCircle = $AnimCircle
	animCircle.maxRadius = MAX_RADIUS

func _draw():
	draw_circle(Vector2(0, 0), MAX_RADIUS, Color(0.8, 0.8, 0.8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var timeToHit: float = noteHitTimeout - (Time.get_ticks_msec() - spawnTime)
	if timeToHit < 0:
		queue_free()
		print("Missed!")
	else:
		currentRadius = MAX_RADIUS - MAX_RADIUS * (timeToHit / float(noteHitTimeout))
		animCircle.scale = Vector2(currentRadius / MAX_RADIUS, currentRadius / MAX_RADIUS)
