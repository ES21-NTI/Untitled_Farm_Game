extends Node2D

const SlotClass = preload("res://Scripts/Inventory/Slot.gd")

signal ItemPlaced

@onready var hotbar = $HotbarSlots
@onready var activeItemLabel = $ActiveItemLabel
@onready var slots = hotbar.get_children()

var mouseOnHotbar = false
var mouseOnInventory = false

var placable = false

func _ready():
	
	var callableUpdateItemLabel = Callable(self, "updateActiveItemLabel")
	PlayerInventory.activeItemUpdated.connect(callableUpdateItemLabel)
	for i in range(slots.size()):
		slots[i].gui_input.connect(slotGuiInput.bind(slots[i]))
		var callableRefreshStyle = Callable(slots[i], "refreshStyle")
		PlayerInventory.activeItemUpdated.connect(callableRefreshStyle)
		slots[i].slotIndex = i
		slots[i].slotType = SlotClass.SlotType.HOTBAR
	initializeHotbar()
	updateActiveItemLabel()



func updateActiveItemLabel():
	if slots[PlayerInventory.activeItemSlot].item != null: # Checks if there is an item
		activeItemLabel.text = slots[PlayerInventory.activeItemSlot].item.itemName
		print(slots[PlayerInventory.activeItemSlot].item.itemName)
		equipActiveItem()
	else:
		activeItemLabel.text = ""


func initializeHotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initializeItem(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])



func slotGuiInput(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			
			if find_parent("UserInterface").holdingItem != null: # Currently holding an item
				
				if !slot.item: # Empty slot
					leftClickEmptySlot(slot)
				
				else: # Slot already contains an item
					
					if find_parent("UserInterface").holdingItem.itemName != slot.item.itemName: # Different item, swap them
						leftClickDifferentItem(event, slot)
					
					else: # Same item, try to merge into one stack
						leftClickSameItem(slot)
			
			elif slot.item: # Not holding an item
				leftClickNotHolding(slot)
			updateActiveItemLabel()



func leftClickEmptySlot(slot: SlotClass):
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem, slot, true)
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = null


func leftClickDifferentItem(event: InputEvent, slot: SlotClass):
	PlayerInventory.removeItem(slot, true)
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem, slot, true)
	var tempItem = slot.item
	slot.pickFromSlot(tempItem)
	tempItem.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = tempItem


func leftClickSameItem(slot: SlotClass):
	var stackSize = int(JsonData.itemData[slot.item.itemName]["StackSize"])
	var ableToAdd = stackSize - slot.item.itemQuantity
	if ableToAdd >= find_parent("UserInterface").holdingItem.itemQuantity:
		PlayerInventory.addItemQuantity(slot, find_parent("UserInterface").holdingItem.itemQuantity, true)
		slot.item.increaseItemQuantity(find_parent("UserInterface").holdingItem.itemQuantity)
		find_parent("UserInterface").holdingItem.queue_free()
		find_parent("UserInterface").holdingItem = null
	else:
		PlayerInventory.addItemQuantity(slot, ableToAdd, true)
		slot.item.increaseItemQuantity(ableToAdd)
		find_parent("UserInterface").holdingItem.decreaseItemQuantity(ableToAdd)


func leftClickNotHolding(slot: SlotClass):
	PlayerInventory.removeItem(slot, true)
	find_parent("UserInterface").holdingItem = slot.item
	slot.pickFromSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem.global_position = get_global_mouse_position()




func equipActiveItem(): # Function for equipping the item in current activeItemSlot
	if slots[PlayerInventory.activeItemSlot].item != null: # Checks if there is an item in the active item slot
		activeItemLabel.visible = true # Shows the activeItemLabel
		var activeItemCategory = JsonData.itemData[slots[PlayerInventory.activeItemSlot].item.itemName]["ItemCategory"]
		print(activeItemCategory)
		
		if activeItemCategory == "Consumable":
			Global.farmingMode = Global.FARMING_MODES.NONE
		
		if activeItemCategory == "Tool":
			
			var activeToolType = JsonData.itemData[slots[PlayerInventory.activeItemSlot].item.itemName]["ToolType"]
			
			if activeToolType == "Hoe":
				Global.farmingMode = Global.FARMING_MODES.HOE
		
		if activeItemCategory == "Seeds":
			Global.farmingMode = Global.FARMING_MODES.SEEDS


func useItem(): # Function for using the current active item in activeItemSlot
	
	if slots[PlayerInventory.activeItemSlot].item.itemQuantity != 1: # Checks if there's more items left in the stack
		slots[PlayerInventory.activeItemSlot].item.decreaseItemQuantity(1) # Decreases the itemQuantity of the activeItemSlot by 1 
	
	else: # It's the last item left in the stack
		PlayerInventory.removeItem(slots[PlayerInventory.activeItemSlot], true) # Removes the active item from the PlayerInventory hotbar list
		slots[PlayerInventory.activeItemSlot].item.queue_free() # Deletes the Item node inside of the activeItem's HotbarSlot
		slots[PlayerInventory.activeItemSlot].item = null # Makes the slot empty
		activeItemLabel.visible = false # Hides the activeItemLabel



func _input(event):
	
	if slots[PlayerInventory.activeItemSlot].item != null: # Checks if there is an item in the active item slot
		
		var activeItemName = slots[PlayerInventory.activeItemSlot].item.itemName
		var activeItemCategory = JsonData.itemData[slots[PlayerInventory.activeItemSlot].item.itemName]["ItemCategory"]
		
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouseOnHotbar != true and mouseOnInventory != true: # Fixes a weird mouse movement bug causing multiple uses when using items 
				
				if activeItemCategory == "Consumable":
					
					if activeItemName == "Egg":
						useItem()
						print(slots[PlayerInventory.activeItemSlot].item.itemQuantity)
					
				if activeItemCategory == "Tool":
					
					var activeToolType = JsonData.itemData[slots[PlayerInventory.activeItemSlot].item.itemName]["ToolType"]
					
					if activeToolType == "Hoe":
						ItemPlaced.emit() # Is trying to be placed on the tilemap
					
				if activeItemCategory == "Seeds":
					ItemPlaced.emit() # Is trying to be placed on the tilemap
					if placable == true: #Checks if the item was placed
						useItem()
						placable = false #Makes sure the item can't be placed again
					else:
						pass
					
		else:
			pass


func _on_mouse_detection_mouse_entered():
	mouseOnHotbar = true


func _on_mouse_detection_mouse_exited():
	mouseOnHotbar = false


func _on_inventory_mouse_detection_mouse_entered():
	mouseOnInventory = true


func _on_inventory_mouse_detection_mouse_exited():
	mouseOnInventory = false


func _on_world_placeable():
	placable = true
