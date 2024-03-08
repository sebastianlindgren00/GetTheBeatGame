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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var hand1 = handManager.hand1 # Contains all landmarks for hand 1
	var hand2 = handManager.hand2 # Contains all landmarks for hand 2

	if handOrientation[1] != "":
		pass
	
	# Get the dominant hand base and use it as pointer if two hands are used. Resort to the only hand if only one is used	
	if handOrientation[0] == DOMINANT_HAND or hand2[0] == Vector2(0, 0):
		self.position = hand1[0] * Vector2(VIEWPORT_X, VIEWPORT_Y) # Attach hand to square
		dominantRightHand = true
		print("Dominant Right Hand")
	else:
		self.position = hand2[0] * Vector2(VIEWPORT_X, VIEWPORT_Y)
		dominantLeftHand = true
		print("Dominant Left Hand")
	
# 	# Local Rotation
# 	var indexBasePos = ControlScript.index5 # Bottom of index finger
# 	var basePos = ControlScript.index0 # Anchor point in hand
# 	if is_patting:
# 		self.rotation = 0 # No rotation for patting
# 	# Angle between bottom of index finger and anchor point in hand.
# 	# Creates a rotation for the pointer sprite
# 	else:
# 		var indexBasePos2D = Vector2(indexBasePos.x, indexBasePos.y)
# 		var basePos2D = Vector2(basePos.x, basePos.y)
# 		var fingerRot = basePos2D.angle_to_point(indexBasePos2D)
# 		self.rotation = fingerRot + PI / 2;
	
	check_for_gesture(hand1, hand2, dominantRightHand, dominantLeftHand)
	
# 	# Reset to default sprite
# 	if (!is_pinching&&!is_grabbing&&!is_patting):
# 		gestureText.text = ""
# 		_renderer.texture = defaultSprite
	
func check_for_gesture(hand1, hand2, dominantRightHand, dominantLeftHand):
# 	# https://www.ida.liu.se/~TDDD57/labb.sv.shtml
	var snap_dist = 0.001
	var is_snapping = false
# 	# Look for snap
	if dominantRightHand:
		# Check the x-distance between point of thumb and point of middle finger
		if abs(hand1[3].x - hand1[7].x) < snap_dist:
			if !is_snapping:
				is_snapping = true
				#gestureText.text = "SNAPPING"
				#_renderer.texture = snapSprite
				print("SNAPPING RIGHT HAND")
			return
		else:
			if is_snapping: is_snapping = false
	else:
		# Check the x-distance between point of thumb and point of middle finger
		if abs(hand2[3].x - hand2[7].x) < snap_dist:
			if !is_snapping:
				is_snapping = true
				#gestureText.text = "SNAPPING"
				#_renderer.texture = snapSprite
				print("SNAPPING LEFT HAND")
			return
		else:
			if is_snapping: is_snapping = false

# 	# Look for clap

# 	# Look for pat
# 	# Check the y-distance between point of index, base of index and base of hand
# 	if abs(indexPointPos.y - indexBasePos.y) < pat_dist&&abs(indexBasePos.y - basePos.y) < pat_dist:
# 		if !is_patting:
# 			is_patting = true
# 			gestureText.text = "PATTING"
# 			is_grabbing = false
# 			is_pinching = false
			
# 		return
# 	else:
# 		if is_patting: is_patting = false
	
# 	# Look for clap
# 	var middleDipPos = ControlScript.index11
# 	# Check the distance between middle finger dip and hand base
# 	if basePos.distance_to(middleDipPos) < grab_dist:
# 		if !is_grabbing:
# 			is_grabbing = true
# 			gestureText.text = "GRABBING"
# 			is_pinching = false
# 			_renderer.texture = closedSprite
# 		return
# 	else:
# 		if is_grabbing: is_grabbing = false
