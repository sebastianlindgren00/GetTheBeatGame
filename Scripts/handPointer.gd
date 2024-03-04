extends Node
var handManager;

# Called when the node enters the scene tree for the first time.
func _ready():
	handManager = $"../HandManager"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get hand data from the tracking
	var handOrientation = handManager.orientation
	var hand1 = handManager.hand1
	var hand2 = handManager.hand2
	#print(handOrientation[0])
	if handOrientation[1] != "":
		#print(handOrientation[1])
		pass
