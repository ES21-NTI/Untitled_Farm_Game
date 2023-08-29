extends Node2D

const SlotClass = preload("res://Scripts/Inventory/Slot.gd")
@onready var inventorySlots = $GridContainer
var holdingItem = null

func _ready():
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		slots[i].gui_input.connect(slotGuiInput.bind(slots[i]))
		slots[i].slotIndex = i
	initializeInventory()


func initializeInventory():
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initializeItem(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])



func slotGuiInput(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			
			if holdingItem != null: # Currently holding an item
				
				if !slot.item: # Empty slot
					leftClickEmptySlot(slot)
				
				else: # Slot already contains an item
					
					if holdingItem.itemName != slot.item.itemName: # Different item, swap them
						leftClickDifferentItem(event, slot)
					
					else: # Same item, try to merge into one stack
						leftClickSameItem(slot)
			
			elif slot.item: # Not holding an item
				leftClickNotHolding(slot)


func _input(_event):
	if holdingItem:
		holdingItem.global_position = get_global_mouse_position()


func leftClickEmptySlot(slot: SlotClass):
	PlayerInventory.addItemToEmptySlot(holdingItem, slot)
	slot.putIntoSlot(holdingItem)
	holdingItem = null


func leftClickDifferentItem(event: InputEvent, slot: SlotClass):
	PlayerInventory.removeItem(slot)
	PlayerInventory.addItemToEmptySlot(holdingItem, slot)
	var tempItem = slot.item
	slot.pickFromSlot(tempItem)
	tempItem.global_position = event.global_position
	slot.putIntoSlot(holdingItem)
	holdingItem = tempItem


func leftClickSameItem(slot: SlotClass):
	var stackSize = int(JsonData.itemData[slot.item.itemName]["StackSize"])
	var ableToAdd = stackSize - slot.item.itemQuantity
	if ableToAdd >= holdingItem.itemQuantity:
		PlayerInventory.addItemQuantity(slot, holdingItem.itemQuantity)
		slot.item.increaseItemQuantity(holdingItem.itemQuantity)
		holdingItem.queue_free()
		holdingItem = null
	else:
		PlayerInventory.addItemQuantity(slot, ableToAdd)
		slot.item.increaseItemQuantity(ableToAdd)
		holdingItem.decreaseItemQuantity(ableToAdd)


func leftClickNotHolding(slot: SlotClass):
	PlayerInventory.removeItem(slot)
	holdingItem = slot.item
	slot.pickFromSlot(holdingItem)
	holdingItem.global_position = get_global_mouse_position()
