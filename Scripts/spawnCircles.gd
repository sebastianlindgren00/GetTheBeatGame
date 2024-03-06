extends Node

const NOTE_MARGIN = 10 # Margin for the notes to be hit (in ms)

var timeSpent = 0;
var notes = []
var notesArray = []
var noteIndex = 0
var sustainNotes = []
var sustainArray = []
var sustainIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the notes from the file and add the note timestamps to the array
	var songImport = NotesImport.noteFileData
	notes = songImport["difficulties"]["Easy"]["Single"]
	notesArray = []
	for noteKey in notes.keys():
		# Check that a note is always a second or more away from eachother
		if len(notesArray) == 0 or int(noteKey) - notesArray[-1] > 1000: 
			notesArray.append(int(noteKey))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timeSpent = Time.get_ticks_msec()

	# Print out the time spent each second
	if timeSpent % 1000 <= NOTE_MARGIN:
		print(float(timeSpent) / 1000)

	# Clear all notes that are closer than 1 second to eachother
	while noteIndex < len(notesArray) and notesArray[noteIndex] - timeSpent < -1000:
		# Check if the note is in the time range
		if notesArray[noteIndex] - timeSpent < NOTE_MARGIN:
			var note = notes[str(notesArray[noteIndex])][0]

			var lane_data = note["lanes"][0]

			var sustain_value = lane_data["sustain"]

			# Handle sustain or tap hit based on sustain_value
			if sustain_value != 0:
				print(notesArray[noteIndex], " Sustain hit!")
			else:
				print(notesArray[noteIndex], " Tap Hit!")
			
			noteIndex += 1