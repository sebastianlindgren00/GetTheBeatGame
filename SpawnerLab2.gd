extends Control

var ballonRedPrefab = preload("res://Prefabs/balloonRedPop.tscn")
var ballonYellowPrefab = preload("res://Prefabs/balloonYellowPop.tscn")
var rng
var nr_of_balloons = 1
var score = 0;

@onready var scoreBoard = $"../ScoreBoard"

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	spawn_balloon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_balloon():
	# Remove all connected childs to prevent duplicated balloons from spawning
	for i in range(0, get_child_count()):
		get_child(i).queue_free()
	# Make sure one red balloon spawns
	var balloonType = 1
	for i in floor(nr_of_balloons):
		# Set the balloon
		var ballonPrefab = ballonRedPrefab
		var balloonColor = "RED"
		if balloonType == 0:
			ballonPrefab = ballonYellowPrefab
			balloonColor = "YELLOW"
	
		var balloonInst = ballonPrefab.instantiate()
		balloonInst.position = Vector2(rng.randf_range(0, get_viewport().size.x - 50), rng.randf_range(0, get_viewport().size.y - 50))
		balloonInst.color = balloonColor
		balloonInst.name = "Balloon"
		add_child(balloonInst) 
		balloonType = rng.randi_range(0,1) # 50/50 yellow or red
	nr_of_balloons += 0.3 # Every fourth spawns

# Handles scoreboard
func score_manager(point):
	score += point
	scoreBoard.text = "SCORE: " + str(score)
