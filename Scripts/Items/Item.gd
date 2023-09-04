extends Node2D

var itemName
var itemQuantity


@onready var label = $Label


func _ready():
	var randVal = randi() % 3
	if randVal == 0:
		itemName = "Iron Sword"
	elif randVal == 1:
		itemName = "Stick"
	else:
		itemName = "Egg"
	
	$TextureRect.texture = load("res://Assets/item_icons/" + itemName + ".png")
	var stackSize = int(JsonData.itemData[itemName]["StackSize"])
	itemQuantity = randi() % stackSize + 1
	
	if stackSize == 1:
		label.visible = false
	else: 
		label.text = str(itemQuantity)



func setItem(nm, qt): # nm = name, qt = quantity
	itemName = nm
	itemQuantity = qt
	$TextureRect.texture = load("res://Assets/item_icons/" + itemName + ".png")
	
	var stackSize = int(JsonData.itemData[itemName]["StackSize"])
	if stackSize == 1:
		label.visible = false
	else: 
		label.visible = true
		label.text = str(itemQuantity)



func increaseItemQuantity(amountToAdd):
	itemQuantity += amountToAdd
	label.text = str(itemQuantity)


func decreaseItemQuantity(amountToRemove):
	itemQuantity -= amountToRemove
	label.text = str(itemQuantity)
