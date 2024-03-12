extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 50
const PRECISION_TEXT_ARRAY = ["JAAAZZZ", "COOOOOOL", "AMAAAAAAZING", "PERFECT JAAAAAAZZ"]
const E = 2.71828182846
const MOVEMENT_SPEED = 1
const STARTUP_ANIM_TIME = 2000 # Time in milliseconds for the startup animation
const NOTE_TYPE = "sustain"

var direction # Direction of the sustain path
var circleShapePrefab
var t = 0
var noteIsHit = false # If the note was hit
var sustainTime = 200 # Time the note was sustained

var circlePos # Position of the circle
var area # Area2D of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var precisionText: String = ""
var precisionLevel: int = 0
var circleColor = Color(1, 1, 1, 1)
var circleIsDrawn = false # Ugly solution because we had to draw the circle in the procces function instead of the child exited tree function :(
var jazzCircArea: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set animation speed of the circle
	area = $circleArea
	area.noteHitTimeout = noteHitTimeout
	area.noteType = "sustain"

	# Set jazz circle area
	jazzCircArea = $jazzArea

	# Set circle position
	while true:
		circlePos = Vector2(randf_range(0, VIEWPORT_X), randf_range(0, VIEWPORT_Y))
		if circlePos.distance_to(Vector2(VIEWPORT_X / 2.0, VIEWPORT_Y / 2.0)) < VIEWPORT_X / 2.0 - MAX_RADIUS:
			break
	self.position = circlePos

	# Load the circle shapes, used to draw the path of the sustain note
	circleShapePrefab = preload ("res://Prefabs/circle_shape.tscn")
	# Set direction
	direction = Vector2(randf_range( - 1, 1), randf_range( - 1, 1)).normalized()
	# Animate bounce in towards direction

func _process(delta):

	if t < STARTUP_ANIM_TIME and !noteIsHit:
		# Animate the circle towards the direciton of the sustain path
		const TIME_SCALE = 2
		const ANIMATION_SCALE = 10
		t += delta * TIME_SCALE
		self.position = circlePos - direction * pow(E, -t) * abs(4 * cos(5 * t)) * ANIMATION_SCALE

	if noteIsHit:
		if !circleIsDrawn:
			drawCircle()
			circleIsDrawn = true

		t += delta * 1000 # Convert to milliseconds

		# Animate the sustain circle
		if t < sustainTime:
			# Check if user is acticly jazzing inside the circle
			if !jazzCircArea.noteIsHit:
				# Remove the circle
				print("Note missed")
				noteIsHit = false
				self.queue_free()

			# Move the circle towards its direction
			self.position += direction * MOVEMENT_SPEED
			# If the circle hits the edge of the screen, make it bounce
			if self.position.x < MAX_RADIUS or self.position.x > VIEWPORT_X - MAX_RADIUS:
				direction.x *= - 1
			if self.position.y < MAX_RADIUS or self.position.y > VIEWPORT_Y - MAX_RADIUS:
				direction.y *= - 1
		else:
			# Remove the circle
			self.queue_free()

func drawCircle():
	var circ = circleShapePrefab.instantiate()
	circ.color = circleColor
	circ.maxRadius = MAX_RADIUS
	self.add_child(circ)

func _on_child_exiting_tree(node):
	# Check if the node removed is the circle area
	if area != null and node.get_name() == area.name:
		# Check if note was hit
		if node.noteIsHit:
			# Get hit precision
			precisionLevel = round(node.precision * (PRECISION_TEXT_ARRAY.size() - 1))
			precisionText = PRECISION_TEXT_ARRAY[precisionLevel]
			noteIsHit = true
			circleColor = area.color
			jazzCircArea.noteIsHit = true
			jazzCircArea.isActive = true
			t = 0
