extends Node

const PRECISION_MULTIPLIER_ADD = .2

var precisionTextNode
var scoreTextNode
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set precision text node
	precisionTextNode = $"../PrecisionText"
	precisionTextNode.text = ""

	# Set score text node
	scoreTextNode = $"../ScoreText"
	scoreTextNode.text = "Score: " + str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_circle_manager_child_exiting_tree(note):
	if note.noteIsHit:
		# Update score
		var precisionText = note.precisionText
		var precisionLevel = note.precisionLevel
		precisionTextNode.text = precisionText
		score += 10 * (precisionLevel + 1) * (1 + PRECISION_MULTIPLIER_ADD)
		scoreTextNode.text = "Score: " + str(score)
