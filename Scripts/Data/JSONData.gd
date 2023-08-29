extends Node

var itemData: Dictionary

func _ready():
	itemData = loadData("res://Scripts/Data/ItemData.json")

func loadData(filePath):
	var fileData = FileAccess.open(filePath, FileAccess.READ)
	var jsonData = JSON.new()
	jsonData.parse(fileData.get_as_text())
	fileData.close()
	return jsonData.get_data()
