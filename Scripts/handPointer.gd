extends Area2D

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const DOMINANT_HAND = "Right"

var handManager;
var handOrientation
var dominantRightHand = false
var dominantLeftHand = false
var is_snapping = false
var is_jazzing = false

var gestureSprite
var snapGesture = preload ("res://Icons/PinchedFingers.png")
var jazzGesture = preload ("res://Icons/RaisingHands.png")
var defaultGesture = preload ("res://Icons/point.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	handManager = $"../HandManager"
	handOrientation = handManager.orientation
	# Set the origin position of the ColorRect to (0, 0)

	gestureSprite = Sprite2D.new()
	gestureSprite.scale = Vector2(0.3, 0.3)
	gestureSprite.texture = defaultGesture
	add_child(gestureSprite)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var hand1 = handManager.hand1 # Contains all landmarks for hand 1
	var hand2 = handManager.hand2 # Contains all landmarks for hand 2
	if handOrientation[1] != "":
		pass
	
	var handPos = Vector2(0, 0)
	# Get the dominant hand base and use it as pointer if two hands are used. Resort to the only hand if only one is used	
	if handOrientation[0] == DOMINANT_HAND or hand2[0] == Vector2(0, 0):
		# Scale the screen, to avoid the hand to be too close to the top
		handPos = (hand1[0] * Vector2(1.2, 1.2))
		#dominantRightHand = true
		#("Dominant Right Hand")
	else:
		handPos = (hand2[0] * Vector2(1.2, 1.2))
		#dominantLeftHand = true
		#("Dominant Left Hand")
	# Make a check to see if right hand or left hand is 
	#("Index point 4: ", hand1[4], " Index point 12: ", hand1[12])

	# Center the scaled screen on x-axis and move it down a bit on y-axis
	handPos.x -= (1 - handPos.x) / 2
	handPos.y -= 1 - handPos.y

	# Attach hand to square and scale it to the viewport
	self.position = handPos * Vector2(VIEWPORT_X, VIEWPORT_Y)

	# Check for gestures
	check_for_snap(hand1)
	check_for_jazz(hand1, hand2)
	
func check_for_snap(hand1):
	# Keyboard backup (x button)
	if Input.is_action_pressed("tap"):
		if !is_snapping:
			is_snapping = true
			gestureSprite.texture = snapGesture
		return

 	# https://www.ida.liu.se/~TDDD57/labb.sv.shtml
	const SNAP_DIST = 0.03
	is_snapping = false

 	# Look for snap
	if handOrientation[0] == DOMINANT_HAND:
		# Check the x-distance between point of thumb and point of middle finger
		if abs(hand1[4].x - hand1[12].x) < SNAP_DIST&&hand1[4] != Vector2(0.402248, 0.69363)&&hand1[12] != Vector2(0.383854, 0.707001):
			if !is_snapping:
				is_snapping = true
			gestureSprite.texture = snapGesture
			return
		else:
			if is_snapping:
				is_snapping = false
			gestureSprite.texture = defaultGesture
		# Check the x-distance between point of thumb and point of middle finger
	else:
		if abs(hand1[4].x - hand1[12].x) < SNAP_DIST&&hand1[4] != Vector2(0.402248, 0.69363)&&hand1[12] != Vector2(0.383854, 0.707001):
			if !is_snapping:
				is_snapping = true
				gestureSprite.texture = snapGesture
			return
		else:
			if is_snapping:
					is_snapping = false
			gestureSprite.texture = defaultGesture

func check_for_jazz(hand1, hand2):
	# Keyboard backup (z button)
	if Input.is_action_pressed("sustain"):
		if !is_jazzing:
			is_jazzing = true
			gestureSprite.texture = jazzGesture
		return

	var jazz_dist = 0.15
	is_jazzing = false

	if abs(hand1[4].x - hand2[4].x) < jazz_dist&&hand1[4] != Vector2(0.402248, 0.69363)&&hand1[12] != Vector2(0.383854, 0.707001):
		if !is_jazzing:
			is_jazzing = true
			gestureSprite.texture = jazzGesture
		return
	else:
		if is_jazzing:
			is_jazzing = false
			gestureSprite.texture = defaultGesture
