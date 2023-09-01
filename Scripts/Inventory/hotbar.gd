extends Node2D

const SlotClass = preload("res://Scripts/Inventory/Slot.gd")

@onready var hotbar = $HotbarSlots
@onready var slots = hotbar.get_children()

func _ready():
	for i in range(slots.size()):
		slots[i].gui_input.connect(slotGuiInput.bind(slots[i]))
		var callable = Callable(slots[i], "refreshStyle")
		PlayerInventory.activeItemUpdated.connect(callable)
		slots[i].slotIndex = i
		slots[i].slotType = SlotClass.SlotType.HOTBAR
	initializeHotbar()


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
