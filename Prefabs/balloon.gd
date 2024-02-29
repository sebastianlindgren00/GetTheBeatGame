extends Area2D

@onready var _animation_player = $Sprite
@onready var _container = get_parent()
@onready var innerArea = $Inner
@onready var balloonContainer = $BalloonContainer
@onready var Pointer = $"../../Pointer"
var shake = false
var rng
var isPopping = false
var color # Yellow and Red Balloons
var is_entered = false
var is_selected = false
var at_dropoff = false

# Called when the node enters the scene tree for the first time.
# Spawns a yellow balloon
func _ready():
	_animation_player.play("default(yellow)")
	rng = RandomNumberGenerator.new() 
	self.name = "Balloon"

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Only allows grabbing/pinching if the user selected the balloon.
# Also handles the visual shake if the pointer enters the outer area.
func _process(delta):
	if is_entered:
		if (Pointer.is_pinching or Pointer.is_grabbing) and is_selected :
			self.position = Pointer.position
		elif at_dropoff:	# pop balloon when dropping at dropoff area
			_pop_balloon()
	
	if shake:
		# Offsets to create a shake animation
		self.position += Vector2(rng.randf_range(-2, 2), rng.randf_range(-2, 2))

# Play pop animation and pop balloon.
func _pop_balloon():
	isPopping = true
	_animation_player.play("pop")

# +1 point for popping red and -1 point for popping yellow
func _on_sprite_animation_finished():
	if color == "RED":
		_container.score_manager(1)
	elif color == "YELLOW":
		_container.score_manager(-1)
	_container.spawn_balloon()

# When pointer enters the inner area the balloon should pop
func _on_inner_area_entered(area):
	if area.name.contains("Pointer"): is_entered = true

# When pointer enters the outer area the balloon shakes to visually
# demonstrate almost call to action. Lets the user avoid popping when it's
# unwanted
func _on_outer_area_entered(area):
	shake = true
	if area.name == "DropOff":
		at_dropoff = true;

# Stop shake whenthe pointer is outside the outer area
func _on_area_exited(area):
	shake = false
	is_entered = false
	if area.name == "DropOff":
		at_dropoff = false;
	
func select():
	is_selected = true
	_animation_player.play("default")
	
func unselect():
	is_selected = false
	_animation_player.play("default(yellow)")
