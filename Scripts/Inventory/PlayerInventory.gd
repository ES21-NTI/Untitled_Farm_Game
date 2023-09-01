extends Node

signal activeItemUpdated

const ItemClass = preload("res://Scripts/Items/Item.gd")
const SlotClass = preload("res://Scripts/Inventory/Slot.gd")
const NUM_INVENTORY_SLOTS = 28
const NUM_HOTBAR_SLOTS = 9

var inventory = {
	0: ["Iron Sword", 1],  # slotIndex: [itemName, itemQuantity]
	1: ["Iron Sword", 1],
	2: ["Egg", 98],
	3: ["Egg", 45],
	4: ["Stick", 69],
}


var hotbar = {
	0: ["Iron Sword", 1],  # slotIndex: [itemName, itemQuantity]
	1: ["Hoe", 1],
	2: ["Egg", 98],
	3: ["Egg", 45],
	4: ["Stick", 69],
	5: ["Seeds", 13],
}


var activeItemSlot = 0 # Index of the first slot in the hotbar 


func addItem(itemName, itemQuantity):
	for item in inventory:
		if inventory[item][0] == itemName:
			var stackSize = int(JsonData.itemData[itemName]["StackSize"]) # Finds out the stack size by acessing the json data
			var ableToAdd = stackSize - inventory[item][1] # Checks if able to add by subtracting the item quantity in slot from stack size
			if ableToAdd >= itemQuantity: # If ableToAdd is greater then the amount we want to add
				inventory[item][1] += itemQuantity # Adds the rest of itemQuantity to the slot and returns
				updateSlotVisual(item, inventory[item][0], inventory[item][1])
				return
			else: # Add what's possible, subtracts that from itemQuantity and tries to add that to whatever space left possible
				inventory[item][1] += ableToAdd
				itemQuantity = itemQuantity - ableToAdd
				updateSlotVisual(item, inventory[item][0], inventory[item][1])
	
	# Item doesn't exist in inventory yet, add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [itemName, itemQuantity]
			updateSlotVisual(i, inventory[i][0], inventory[i][1])
			return


func updateSlotVisual(slotIndex, itemName, newQuantity):
	var slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slotIndex + 1))
	if slot.item != null:
		slot.item.setItem(itemName, newQuantity)
	else:
		slot.initializeItem(itemName, newQuantity)


func removeItem(slot: SlotClass, isHotbar: bool = false):
	if isHotbar:
		hotbar.erase(slot.slotIndex)
	else:
		inventory.erase(slot.slotIndex)



func addItemToEmptySlot(item: ItemClass, slot: SlotClass, isHotbar: bool = false):
	if isHotbar:
		hotbar[slot.slotIndex] = [item.itemName, item.itemQuantity]
	else:
		inventory[slot.slotIndex] = [item.itemName, item.itemQuantity]


func addItemQuantity(slot: SlotClass, quantityToAdd: int, isHotbar: bool = false):
	if isHotbar:
		hotbar[slot.slotIndex][1] += quantityToAdd
	else:
		inventory[slot.slotIndex][1] += quantityToAdd


func activeItemScrollUp():
	activeItemSlot = (activeItemSlot + 1) % NUM_HOTBAR_SLOTS # Loops back to slot 0 if number surpasses NUM_HOTBAR_SLOTS
	activeItemUpdated.emit()


func activeItemScrollDown():
	if activeItemSlot == 0:
		activeItemSlot = NUM_HOTBAR_SLOTS - 1
		activeItemUpdated.emit()
	else:
		activeItemSlot -= 1
		activeItemUpdated.emit()
