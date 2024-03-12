extends Node

const NOTE_MARGIN = 100 # Margin used to make sure the note is found (in ms)
const NOTE_HIT_TIMEOUT = 4000 # Time in ms to hit the note from the time it appears

var timeSpent = 0;
var notes = []
var notesArray = []
var noteIndex = 0
var sustainNotes = []
var sustainArray = []
var sustainIndex = 0

var tapCirclePrefab = preload ("res://Prefabs/tap_circle.tscn")
var sustainCirclePrefab = preload ("res://Prefabs/sustain_circle.tscn")
var precisionTextNode # Text node to display precision level

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the notes from the file and add the note timestamps to the array
	var songImport = NotesImport.noteFileData
	notes = songImport["difficulties"]["Easy"]["Single"]
	notesArray = []
	for noteKey in notes.keys():
		# Check that a note is always a second or more away from eachother
		if len(notesArray) == 0 or int(noteKey) - notesArray[- 1] > 1000:
			notesArray.append(int(noteKey))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timeSpent = Time.get_ticks_msec()

	# Clear all notes that are closer than 1 second to eachother
	if noteIndex < len(notesArray) and notesArray[noteIndex] - timeSpent < - 1000:
		# Check if the note is in the time range
		if notesArray[noteIndex] - timeSpent < NOTE_MARGIN:
			var note = notes[str(notesArray[noteIndex])][0]

			if note["lanes"].size() > 0:
				var lane_data = note["lanes"][0]
				var sustain_value = lane_data["sustain"]
				# Handle sustain or tap hit based on sustain_value
				var circ
				if sustain_value != 0:
					# Call sustain note
					print(notesArray[noteIndex], " Sustain note!")
					# Create a sustain circle
					circ = sustainCirclePrefab.instantiate()
					circ.sustainTime = sustain_value
				else:
					# Call tap note
					print(notesArray[noteIndex], " Tap note!")
					# Create a tap circle
					circ = tapCirclePrefab.instantiate()
				circ.noteHitTimeout = NOTE_HIT_TIMEOUT
				add_child(circ)
					
			noteIndex += 1
