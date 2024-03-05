extends Node

const NOTE_MARGIN = 10 # Margin for the notes to be hit (in ms)

var timeSpent = 0;
var notes = []
var notesArray = []
var noteIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the notes from the file and add the note timestamps to the array
	var songImport = NotesImport.noteFileData
	notes = songImport["difficulties"]["Expert"]["Single"]

	notesArray = []
	for noteKey in notes.keys():
		notesArray.append(int(noteKey))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timeSpent = Time.get_ticks_msec()

	# Print out the time spent each second
	if timeSpent % 1000 <= NOTE_MARGIN:
		print(timeSpent / 1000)

	# print(timeSpent)

	# Check if the note is in the time range
	if notesArray[noteIndex] - timeSpent < NOTE_MARGIN:
		print(notesArray[noteIndex], " Note hit!")
		noteIndex += 1