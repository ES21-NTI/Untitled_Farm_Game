extends Panel

var defaultTex = preload("res://Assets/UI/item_slot_default_background.png")
var emptyTex = preload("res://Assets/UI/item_slot_empty_background.png")
var selectedTex = preload("res://Assets/images/item_slot_selected_background.png")

var defaultStyle : StyleBoxTexture = null
var emptyStyle : StyleBoxTexture = null
var selectedStyle : StyleBoxTexture = null

var itemClass = preload("res://Scenes/Items/item.tscn")
var item = null
var slotIndex
var slotType


enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}


func _ready():
	
	defaultStyle = StyleBoxTexture.new()
	emptyStyle = StyleBoxTexture.new()
	selectedStyle = StyleBoxTexture.new()
	defaultStyle.texture = defaultTex
	emptyStyle.texture = emptyTex
	selectedStyle.texture = selectedTex
	
	# Randomizes the inventory
#	if randi() % 2 == 0:
#		item = itemClass.instantiate()
#		add_child(item)
	refreshStyle()


func refreshStyle():
	if SlotType.HOTBAR == slotType and PlayerInventory.activeItemSlot == slotIndex:
		set('theme_override_styles/panel', selectedStyle)
	elif item == null:
		set('theme_override_styles/panel', emptyStyle)
	else:
		set('theme_override_styles/panel', defaultStyle)


func pickFromSlot(newItem):
	remove_child(item)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.add_child(item)
	item = null
	refreshStyle()


func putIntoSlot(newItem):
	item = newItem
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.remove_child(item)
	add_child(item)
	refreshStyle()


func initializeItem(itemName, itemQuantity):
	if item == null:
		item = itemClass.instantiate()
		add_child(item)
		item.setItem(itemName, itemQuantity)
	else:
		item.setItem(itemName, itemQuantity)
	refreshStyle()
