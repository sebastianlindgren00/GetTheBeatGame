extends Node2D

const MAX_RADIUS = 50 # Max radius of the circle

var circlePos # Position of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var currentRadius: float = 0 # Current radius of the circle
var animCircle: Node2D # Reference to the child circle node
var spawnTime: int = 0 # Time when the note was spawned
var color: Color # Color of the circle
var pointer: Node2D # Reference to the pointer node

var noteType = "tap" # Type of the note, can be "tap" or "sustain"
var noteIsHit = false # If the note is hit or not
var precision = 0 # Level of precision when hitting the note (timeToHit / noteHitTimeout)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnTime = Time.get_ticks_msec()

	# Generate a random color
	color = Color(randf(), randf(), randf())

	# Get child circle node to animate and set its radius
	animCircle = $AnimCircle
	animCircle.maxRadius = MAX_RADIUS
	animCircle.color = color

func _draw():
	draw_circle(Vector2(0, 0), MAX_RADIUS, color * Color(1, 1, 1, 0.2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var timeToHit: float = noteHitTimeout - (Time.get_ticks_msec() - spawnTime)

	# Give the player som extra time to hit the note
	if timeToHit > - 100:
		# Animate the circle to grow
		currentRadius = MAX_RADIUS - MAX_RADIUS * (timeToHit / float(noteHitTimeout))
		animCircle.scale = Vector2(currentRadius / MAX_RADIUS, currentRadius / MAX_RADIUS)
	else:
		# Missed the note
		queue_free()
		print("Missed!")

	if pointer != null:
		checkGesture(timeToHit)

# Check if the note is hit by using the pointer
func checkGesture(timeToHit):
	# See if snapping is active, using is_snapping from handpointer.gd
	if noteType == "tap":
		if pointer.is_snapping:
			noteIsHit = true
			precision = 1 - timeToHit / noteHitTimeout
			queue_free()
	elif noteType == "sustain":
		pass

func _on_area_entered(area):
	if area.name == "Pointer":
		pointer = area
