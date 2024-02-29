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

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new() 
	self.name = "Balloon"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if shake:
		# Offsets to create a shake animation
		self.position += Vector2(rng.randf_range(-2, 2), rng.randf_range(-2, 2))

# Play pop animation
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
	#if area.name.contains("Pointer"): is_entered = true
	if isPopping:	#Prevent the pointer from exiting and re-entering when it's popping
		return
	_pop_balloon()

# When pointer enters the outer area the balloon shakes to visually
# demonstrate almost call to action. Lets the user avoid popping when it's
# unwanted
func _on_outer_area_entered(area):
	shake = true

# Stop shake whenthe pointer is outside the outer area
func _on_area_exited(area):
	shake = false
