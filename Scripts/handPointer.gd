extends ColorRect

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const DOMINANT_HAND = "Right"

var handManager;
var handOrientation
var dominantRightHand = false
var dominantLeftHand = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	handManager = $"../HandManager"
	handOrientation = handManager.orientation
	# Set the origin position of the ColorRect to (0, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var hand1 = handManager.hand1 # Contains all landmarks for hand 1
	var hand2 = handManager.hand2 # Contains all landmarks for hand 2
	#print (handOrientation)
	if handOrientation[1] != "":
		pass
	
	# Get the dominant hand base and use it as pointer if two hands are used. Resort to the only hand if only one is used	
	if handOrientation[0] == DOMINANT_HAND or hand2[0] == Vector2(0, 0):
		self.position = hand1[0] * Vector2(VIEWPORT_X, VIEWPORT_Y) # Attach hand to square
		#dominantRightHand = true
		#print("Dominant Right Hand")
	else:
		self.position = hand2[0] * Vector2(VIEWPORT_X, VIEWPORT_Y)
		#dominantLeftHand = true
		#print("Dominant Left Hand")
	# Make a check to see if right hand or left hand is 
	#print("Index point 4: ", hand1[4], " Index point 12: ", hand1[12])
	check_for_snap(hand1)
	check_for_jazz(hand1, hand2)
	
func check_for_snap(hand1):
# 	# https://www.ida.liu.se/~TDDD57/labb.sv.shtml
	var snap_dist = 0.001
	var is_snapping = false
# 	# Look for snap
	if handOrientation[0] == DOMINANT_HAND:
		# Check the x-distance between point of thumb and point of middle finger
		if abs(hand1[4].x - hand1[12].x) < snap_dist && hand1[4] != Vector2(0.402248, 0.69363) && hand1[12] != Vector2(0.383854, 0.707001):
			if !is_snapping:
				is_snapping = true
				#gestureText.text = "SNAPPING"
				#_renderer.texture = snapSprite
				print("SNAPPING RIGHT HAND")
			return
		else:
			if is_snapping: is_snapping = false
		# Check the x-distance between point of thumb and point of middle finger
	else:
		if abs(hand1[4].x - hand1[12].x) < snap_dist && hand1[4] != Vector2(0.402248, 0.69363) && hand1[12] != Vector2(0.383854, 0.707001):
			if !is_snapping:
				is_snapping = true
				#gestureText.text = "SNAPPING"
				#_renderer.texture = snapSprite
				print("SNAPPING LEFT HAND")
			return
		else:
			if is_snapping: is_snapping = false

func check_for_jazz(hand1, hand2):
	var jazz_dist = 0.001
	var is_jazzing = false

	if abs(hand1[20].x - hand1[12].x) < jazz_dist && hand1[4] != Vector2(0.402248, 0.69363) && hand1[12] != Vector2(0.383854, 0.707001):
		if !is_jazzing:
			is_jazzing = true
			#gestureText.text = "SNAPPING"
			#_renderer.texture = snapSprite
			print("JAZZ HAND")
		return
	else:
		if is_jazzing: is_jazzing = false