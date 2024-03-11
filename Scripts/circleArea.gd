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

# Called when the node enters the scene tree for the first time.
func _ready():
	pointer = $"pointer"
	print("Note ready ", noteHitTimeout, " ms to hit!")
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
	if timeToHit < 0:
		queue_free()
		print("Missed!")
	else:
		currentRadius = MAX_RADIUS - MAX_RADIUS * (timeToHit / float(noteHitTimeout))
		animCircle.scale = Vector2(currentRadius / MAX_RADIUS, currentRadius / MAX_RADIUS)

	# See if snapping is active, 0.1second window untill circle is gone
	# Using is_snapping from handpointer.gd
	if pointer != null and pointer.is_snapping and timeToHit > - 100:
		queue_free()
		print("Hit!")

func _on_area_entered(area):
	if area.name == "Pointer":
		pointer = area
