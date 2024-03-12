extends Node2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const MAX_RADIUS = 50
const PRECISION_TEXT_ARRAY = ["SNAP", "NICE!", "GREAT", "WOW!", "PERFECT"]
const NOTE_TYPE = "tap"

var noteIsHit: bool = false
var circlePos # Position of the circle
var area # Area2D of the circle
var noteHitTimeout: int = 500 # Timer in milliseconds to hit the note (set by spawner)
var precisionLevel: int = 0
var precisionText: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set animation speed of the circle
	area = $circleArea
	area.noteHitTimeout = noteHitTimeout

	# Set circle position, not too close to the edges
	var margin = MAX_RADIUS * 2
	circlePos = Vector2(randf_range(margin, VIEWPORT_X - margin), randf_range(margin, VIEWPORT_Y - margin))
	self.position = circlePos

func _on_child_exiting_tree(node):
	# Check if the node removed is the circle area
	if node.get_name() == area.name:
		# Check if note was hit
		if node.noteIsHit:
			# Get hit precision
			precisionLevel = round(node.precision * (PRECISION_TEXT_ARRAY.size() - 1))
			precisionText = PRECISION_TEXT_ARRAY[precisionLevel]
			noteIsHit = true

		queue_free()
