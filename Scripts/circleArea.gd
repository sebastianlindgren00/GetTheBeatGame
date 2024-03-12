extends Node2D

const MAX_RADIUS = 50 # Max radius of the circle
const JAZZ_TIMEOUT = 500 # Time the user are allowed to be outside the jazz area

var circlePos # Position of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var currentRadius: float = 0 # Current radius of the circle
var animCircle: Node2D # Reference to the child circle node
var spawnTime: int = 0 # Time when the note was spawned
var color: Color # Color of the circle
var pointer: Node2D # Reference to the pointer node

var tapTexture = preload ("res://Icons/PinchedFingers.png")
var sustainTexture = preload ("res://Icons/ClappingHands.png")

var noteType = "tap" # Type of the note, can be "tap" or "sustain"
var noteIsHit = false # If the note is hit or not
var precision = 0 # Level of precision when hitting the note (timeToHit / noteHitTimeout)

var jazzTimeoutCountdown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnTime = Time.get_ticks_msec()

	# Generate a random color
	color = Color(randf(), randf(), randf())

	# Get child circle node to animate and set its radius
	animCircle = $AnimCircle
	animCircle.maxRadius = MAX_RADIUS
	animCircle.color = color

	var sprite = Sprite2D.new()
	sprite.position = animCircle.position
	sprite.scale = Vector2(0.3, 0.3)
	
	if noteType == "sustain":
		sprite.texture = sustainTexture
		
	else:
		sprite.texture = tapTexture
	
	add_child(sprite)

#draw() function for drawing the outer circle, gets called every frame
func _draw():
	draw_circle(Vector2(0, 0), MAX_RADIUS, color * Color(1, 1, 1, 0.2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timeToHit: float = noteHitTimeout - (Time.get_ticks_msec() - spawnTime)

	if !noteIsHit:
		if pointer != null: checkGesture(timeToHit)
		scaleCircle(timeToHit)
	else:
		jazzTimeoutCountdown -= delta
		if jazzTimeoutCountdown < 0: noteIsHit = false

func scaleCircle(timeToHit):
	# Give the player som extra time to hit the note
	if timeToHit > - 100:
		# Animate the circle to grow
		currentRadius = MAX_RADIUS - MAX_RADIUS * (timeToHit / float(noteHitTimeout))
		animCircle.scale = Vector2(currentRadius / MAX_RADIUS, currentRadius / MAX_RADIUS)
	else:
		# Missed the note
		queue_free()
		print("Missed!")

# Check if the note is hit by using the pointer
func checkGesture(timeToHit):
	# See if snapping is active, using is_snapping from handpointer.gd
	match noteType:
		"tap":
			if pointer.is_snapping:
				noteIsHit = true
				precision = 1 - timeToHit / noteHitTimeout
				queue_free()
		"sustain":
			if pointer.is_jazzing:
				noteIsHit = true
				if timeToHit > 0: precision = 1 - timeToHit / noteHitTimeout
				noteHitTimeout = 0

func _on_area_entered(area):
	if area.name == "Pointer":
		pointer = area

func _on_area_exited(area):
	if area.name == "Pointer":
		pointer = null
		if noteIsHit:
			jazzTimeoutCountdown = JAZZ_TIMEOUT
