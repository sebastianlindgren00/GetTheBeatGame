extends ColorRect

const VIEWPORT_X = 1152
const VIEWPORT_Y = 648
const DOMINANT_HAND = "Right"

var handManager;
var handOrientation

# Called when the node enters the scene tree for the first time.
func _ready():
	handManager = $"../HandManager"
	handOrientation = handManager.orientation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Get hand data from the tracking
	var hand1 = handManager.hand1
	var hand2 = handManager.hand2
	#print(handOrientation[0])
	if handOrientation[1] != "":
		#print(handOrientation[1])
		pass
	
	# Get the dominant hand base and use it as pointer
	#TODO: Add failsafe for when hand1 or hand2 is empty
	if handOrientation[0] == DOMINANT_HAND:
		self.position = hand1[0] * Vector2(VIEWPORT_X, VIEWPORT_Y)
	else:
		self.position = hand2[0] * Vector2(VIEWPORT_X, VIEWPORT_Y)
	
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
	
# 	check_for_gesture(indexPointPos, indexBasePos, basePos)
	
# 	# Reset to default sprite
# 	if (!is_pinching&&!is_grabbing&&!is_patting):
# 		gestureText.text = ""
# 		_renderer.texture = defaultSprite
		
# func check_for_gesture(indexPointPos, indexBasePos, basePos):
# 	# Look for pat
# 	# Check the y-distance between point of index, base of index and base of hand
# 	if abs(indexPointPos.y - indexBasePos.y) < pat_dist&&abs(indexBasePos.y - basePos.y) < pat_dist:
# 		if !is_patting:
# 			is_patting = true
# 			gestureText.text = "PATTING"
# 			is_grabbing = false
# 			is_pinching = false
# 			_renderer.texture = patSprite
# 			if entered_balloon != null:
# 				if entered_balloon.is_selected:
# 					entered_balloon.unselect()
# 				else:
# 					entered_balloon.select()
# 		return
# 	else:
# 		if is_patting: is_patting = false
	
# 	# Look for grab
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
	
# 	# Look for pinch
# 	var thumbPointPos = ControlScript.index4
# 	# Check the distance between point of thumb and point of index
# 	if thumbPointPos.distance_to(indexPointPos) < pinch_dist&&!is_grabbing:
# 		if !is_pinching:
# 			is_pinching = true
# 			gestureText.text = "PINCHING"
# 			_renderer.texture = pinchSprite
# 	else:
# 		if is_pinching: is_pinching = false
