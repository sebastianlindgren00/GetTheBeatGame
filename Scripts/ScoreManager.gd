extends Node

var precisionTextNode

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set precision text node
	precisionTextNode = $"../PrecisionText"
	precisionTextNode.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_circle_manager_child_exiting_tree(note):
	var precisionText = note.precision
	print("Note hit! ", precisionText)
	precisionTextNode.text = precisionText
