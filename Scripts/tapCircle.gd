extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 50
const PRECISION_TEXT = ["SNAP", "NICE!", "GREAT", "WOW!", "PERFECT"]

var circlePos # Position of the circle
var area # Area2D of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var precision: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set animation speed of the circle
	area = $circleArea
	area.noteHitTimeout = noteHitTimeout

	# Set circle position
	while true:
		circlePos = Vector2(randf_range(0, VIEWPORT_X), randf_range(0, VIEWPORT_Y))
		if circlePos.distance_to(Vector2(VIEWPORT_X / 2.0, VIEWPORT_Y / 2.0)) < VIEWPORT_X / 2.0 - MAX_RADIUS:
			break
	self.position = circlePos

func _on_child_exiting_tree(node):
	# Check if the node removed is the circle area
	if node.get_name() == area.name:
		# Check if note was hit
		if node.noteIsHit:
			# Get hit precision
			var precisionLevel = round(node.precision * (PRECISION_TEXT.size() - 1))
			precision = PRECISION_TEXT[precisionLevel]

		queue_free()
