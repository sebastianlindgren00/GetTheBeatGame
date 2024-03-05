extends Node

var noteFileData = {}
func _ready():
	var noteFile = FileAccess.open("res://FileData/notes.json", FileAccess.READ)
	# 05/07/2021 - Fixed error by changong JSON.parse to JSON.parse_string
	noteFileData = JSON.parse_string(noteFile.get_as_text()) 
	noteFile.close()
	print(noteFileData)
