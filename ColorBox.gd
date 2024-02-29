extends ColorRect

# Adjusted for screen
const VIEWPORT_X = 1152; 
const VIEWPORT_Y = 648;
var ControlScript;

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlScript = $"../..";


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = ControlScript.index1
	self.position = Vector2(pos.x, pos.y)
	self.position.x *= VIEWPORT_X;
	self.position.y *= VIEWPORT_Y;
