extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 50
const PRECISION_TEXT = ["JAAAZZZ", "COOOOOOL", "AMAAAAAAZING", "PERFECT JAAAAAAZZ"]
const E = 2.71828182846
const MOVEMENT_SPEED = 10
const STARTUP_ANIM_TIME = 2000 # Time in milliseconds for the startup animation

var direction # Direction of the sustain path
var circleShapePrefab
var t = 0
var noteIsHit = false # If the note was hit
var sustainTime = 200 # Time the note was sustained

var circlePos # Position of the circle
var area # Area2D of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var precision: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set animation speed of the circle
	area = $circleArea
	area.noteHitTimeout = noteHitTimeout
	area.noteType = "sustain"

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
	if t < STARTUP_ANIM_TIME:
		# Animate the circle towards the direciton of the sustain path
		const TIME_SCALE = 2
		const ANIMATION_SCALE = 10
		t += delta * TIME_SCALE
		self.position = circlePos + direction * pow(E, -t) * abs(4 * cos(5 * t)) * ANIMATION_SCALE

	if noteIsHit:
		t += delta

		# Animate the sustain circle
		if t < sustainTime:
			# Move the circle towards its direction
			self.position += direction * MOVEMENT_SPEED
			# If the circle hits the edge of the screen, make it bounce
			if self.position.x < 0 or self.position.x > VIEWPORT_X:
				direction.x *= - 1
			if self.position.y < 0 or self.position.y > VIEWPORT_Y:
				direction.y *= - 1
		else:
			# Remove the circle
			self.queue_free()

func _on_child_exiting_tree(node):
	print("area ", area)
	# Check if the node removed is the circle area
	if area != null and node.get_name() == area.name:
		# Check if note was hit
		if node.noteIsHit:
			# Get hit precision
			var precisionLevel = round(node.precision * (PRECISION_TEXT.size() - 1))
			precision = PRECISION_TEXT[precisionLevel]
			noteIsHit = true
			t = 0
			# # Draw the sustain circle
			# var circ = circleShapePrefab.instance()
			# circ.position = self.position
			# circ.color = area.color
			# circ.radius = MAX_RADIUS
			# self.add_child(circ)
