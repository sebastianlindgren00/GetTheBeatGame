extends AnimatedSprite2D

var ControlScript
const VIEWPORT_X = 1152;
const VIEWPORT_Y = 648;

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlScript = $"../..";


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rng = RandomNumberGenerator.new()
	var balloonX = rng.randi_range(0, VIEWPORT_X);
	var balloonY = rng.randi_range(0, VIEWPORT_Y);
	self.position = Vector2(balloonX, balloonY);
