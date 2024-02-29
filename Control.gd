extends Control

var json = JSON.new()
var index0 = Vector3(0, 0, 0); # Basis of hand
var index4 = Vector3(0, 0, 0); # Thumb point
var index5 = Vector3(0, 0, 0); # Basis of index finger
var index8 = Vector3(0, 0, 0); # Index finger point
var index11 = Vector3(0, 0, 0); # Middle of middle finger, used in grab

func get_data():
	var file = FileAccess.open("res://hands_data.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
	

func _process(_delta):
	var error = json.parse(str(get_data()))
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			index0 = copy_to_vector(data_received[0].landmark_data[0]) # Index 0
			index4 = copy_to_vector(data_received[0].landmark_data[4]) # Index 4
			index5 = copy_to_vector(data_received[0].landmark_data[5]) # Index 5
			index8 = copy_to_vector(data_received[0].landmark_data[8]) # Index 8
			index11 = copy_to_vector(data_received[0].landmark_data[11]) # Index 11
		else:
			print("Unexpected data")
	
#USe this data to copy the text-data in the landmarks into vectors and numbers to use in the game 
func copy_to_vector(data): 
	return Vector3(data.x, data.y, data.z)

"""
Data provided in the following format example: 
	
[
  {
	"index": 1,
	"category_name": "Left",
	"landmark_data": [
	  {
		"x": 0.38289719820022583,
		"y": 0.9964441061019897,
		"z": -8.995270661671384e-8
	  },
	  {
		"x": 0.36539900302886963,
		"y": 0.914076030254364,
		"z": 0.0016398814041167498
	  },
	  {
		"x": 0.3429528474807739,
		"y": 0.8407158851623535,
		"z": -0.004274684004485607
	  },
	  {
		"x": 0.3310786485671997,
		"y": 0.7692688703536987,
		"z": -0.011766311712563038
	  },
	  {
		"x": 0.3216681480407715,
		"y": 0.7194703817367554,
		"z": -0.021171865984797478
	  },
	  {
		"x": 0.2848520874977112,
		"y": 0.8517749905586243,
		"z": 0.004237827844917774
	  },
	  {
		"x": 0.22518910467624664,
		"y": 0.8881287574768066,
		"z": 0.0018946918426081538
	  },
	  {
		"x": 0.20345810055732727,
		"y": 0.9215715527534485,
		"z": -0.003800006117671728
	  },
	  {
		"x": 0.1916199028491974,
		"y": 0.9448983669281006,
		"z": -0.00818819273263216
	  },
	  {
		"x": 0.2780856490135193,
		"y": 0.8888314366340637,
		"z": 0.0004897714243270457
	  },
	  {
		"x": 0.2182680368423462,
		"y": 0.9548459053039551,
		"z": 0.0032318236771970987
	  },
	  {
		"x": 0.22066940367221832,
		"y": 0.9921168684959412,
		"z": -0.0000933257833821699
	  },
	  {
		"x": 0.22900739312171936,
		"y": 1.0052422285079956,
		"z": -0.00566145870834589
	  },
	  {
		"x": 0.2763236165046692,
		"y": 0.9325353503227234,
		"z": -0.0029403376393020153
	  },
	  {
		"x": 0.2246023714542389,
		"y": 0.9930145740509033,
		"z": 0.0006624021334573627
	  },
	  {
		"x": 0.2324281632900238,
		"y": 1.0203421115875244,
		"z": 0.0026590991765260696
	  },
	  {
		"x": 0.24469077587127686,
		"y": 1.029341697692871,
		"z": 0.0007048335974104702
	  },
	  {
		"x": 0.27878549695014954,
		"y": 0.9741102457046509,
		"z": -0.006493720225989819
	  },
	  {
		"x": 0.24092279374599457,
		"y": 1.0199483633041382,
		"z": -0.004244396463036537
	  },
	  {
		"x": 0.2489931583404541,
		"y": 1.0413811206817627,
		"z": 0.0005919900722801685
	  },
	  {
		"x": 0.2601984739303589,
		"y": 1.048858642578125,
		"z": 0.00355530995875597
	  }
	],
	"time": "1704919249.9480598"
  }
]
"""
