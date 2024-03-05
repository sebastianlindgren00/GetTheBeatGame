extends Node

var json = JSON.new()
const ORIENTATION_KEYS = ["Left", "Right"]
var orientation = ["", ""]
var hand1 = []	# The first hand array
var hand2 = []	# The second hand array

# Get hand data from the JSON file
func get_data():
	var file = FileAccess.open("res://hands_data.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
	
#Use this data to copy the text-data in the landmarks into vectors and numbers to use in the game 
func copy_to_vector(data: Dictionary): 
	return Vector2(data.x, data.y)
	
func base_vector(): 
	return Vector2(0, 0)

func mirror_orientation(word: String):
	if word == ORIENTATION_KEYS[0]:
		return ORIENTATION_KEYS[1]
	else:
		return ORIENTATION_KEYS[0]

func _ready():
	for i in 21:
		hand1.push_back(base_vector())
		hand2.push_back(base_vector())

func _process(_delta):
	var error = json.parse(str(get_data()))
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			for index in hand1.size():
				# Get hand orientation and its data
				orientation[0] = mirror_orientation(data_received[0].category_name)
				hand1[index] = copy_to_vector(data_received[0].landmark_data[index])
				if data_received.size() > 1: 
					orientation[1] = mirror_orientation(data_received[1].category_name)
					hand2[index] = copy_to_vector(data_received[1].landmark_data[index])
				else:
					hand2[index] = base_vector()
		else:
			print("Unexpected data")
			
	# Print the data
	# print("Hand 1: ", orientation[0], hand1)
	# print("Hand 2: ", orientation[1], hand2)
		
