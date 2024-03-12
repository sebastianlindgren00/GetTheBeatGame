extends Area2D

const JAZZ_TIMEOUT = 100 # Time the user are allowed to be outside the jazz area

var isActive = false
var pointer
var noteIsHit = false
var jazzTimeoutCountdown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isActive:
		if (noteIsHit and pointer == null) or (pointer != null and !pointer.is_jazzing):
			jazzTimeoutCountdown -= delta * 1000 # Convert to milliseconds
			if jazzTimeoutCountdown < 0: noteIsHit = false

func _on_area_entered(area):
	if area.name == "Pointer":
		pointer = area

func _on_area_exited(area):
	if area.name == "Pointer":
		pointer = null
		if noteIsHit:
			jazzTimeoutCountdown = JAZZ_TIMEOUT
