extends Area2D

const VIEWPORT_X = 1152;
const VIEWPORT_Y = 648;
var ControlScript;


@onready var _renderer = $Sprite
@onready var defaultSprite = preload("res://sprites/pointer.png")
@onready var pinchSprite = preload("res://sprites/pointer(pinch).png")
@onready var closedSprite = preload("res://sprites/pointer(closed).png")
@onready var patSprite = preload("res://sprites/pointer(pat).png")
@onready var gestureText = $"../GestureText"

# Thresholds. Lesser values signals pinch, grab or pat.
const pinch_dist = 0.09
const grab_dist = 0.2
const pat_dist = 0.1

var is_pinching = false;
var is_grabbing = false;
var is_patting = false;

var entered_balloon = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlScript = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# World position
	var indexPointPos = ControlScript.index8 # Index finger point
	var indexPointPos2D = Vector2(indexPointPos.x, indexPointPos.y)
	self.position = indexPointPos2D
	self.position.x *= VIEWPORT_X;
	self.position.y *= VIEWPORT_Y;
	
	# Local Rotation
	var indexBasePos = ControlScript.index5 # Bottom of index finger
	var basePos = ControlScript.index0 # Anchor point in hand
	if is_patting:
		self.rotation = 0 # No rotation for patting
	# Angle between bottom of index finger and anchor point in hand.
	# Creates a rotation for the pointer sprite
	else:
		var indexBasePos2D = Vector2(indexBasePos.x, indexBasePos.y)
		var basePos2D = Vector2(basePos.x, basePos.y)
		var fingerRot = basePos2D.angle_to_point(indexBasePos2D) 
		self.rotation = fingerRot + PI/2;
	
	check_for_gesture(indexPointPos, indexBasePos, basePos)
	
	# Reset to default sprite
	if (!is_pinching && !is_grabbing && !is_patting):
		gestureText.text = ""
		_renderer.texture = defaultSprite
		
func check_for_gesture(indexPointPos, indexBasePos, basePos):
	# Look for pat
	# Check the y-distance between point of index, base of index and base of hand
	if abs(indexPointPos.y - indexBasePos.y) < pat_dist && abs(indexBasePos.y - basePos.y) < pat_dist:
		if !is_patting:
			is_patting = true
			gestureText.text = "PATTING"
			is_grabbing = false
			is_pinching = false
			_renderer.texture = patSprite
			if entered_balloon != null:
				if entered_balloon.is_selected:
					entered_balloon.unselect()
				else:
					entered_balloon.select()
		return
	else:
		if is_patting: is_patting = false
	
	# Look for grab
	var middleDipPos = ControlScript.index11
	# Check the distance between middle finger dip and hand base
	if basePos.distance_to(middleDipPos) < grab_dist:
		if !is_grabbing:
			is_grabbing = true
			gestureText.text = "GRABBING"
			is_pinching = false
			_renderer.texture = closedSprite
		return
	else:
		if is_grabbing: is_grabbing = false
	
	# Look for pinch
	var thumbPointPos = ControlScript.index4
	# Check the distance between point of thumb and point of index
	if thumbPointPos.distance_to(indexPointPos) < pinch_dist && !is_grabbing:
		if !is_pinching:
			is_pinching = true
			gestureText.text = "PINCHING"
			_renderer.texture = pinchSprite
	else:
		if is_pinching: is_pinching = false

func _on_area_entered(area):
	if area.name.contains("Balloon"):
		entered_balloon = area

func _on_area_exited(area):
	if area.name.contains("Balloon") and !is_patting:
		entered_balloon = null
