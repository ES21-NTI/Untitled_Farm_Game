extends Node

const ItemClass = preload("res://Scripts/Items/Item.gd")
const SlotClass = preload("res://Scripts/Inventory/Slot.gd")
const NUM_INVENTORY_SLOTS = 28

var inventory = {
	0: ["Iron Sword", 1],  # slotIndex: [itemName, itemQuantity]
	1: ["Iron Sword", 1],
	2: ["Egg", 98],
	3: ["Egg", 45],
	4: ["Stick", 69],
}


func addItem(itemName, itemQuantity):
	for item in inventory:
		if inventory[item][0] == itemName:
			var stackSize = int(JsonData.itemData[itemName]["StackSize"]) # Finds out the stack size by acessing the json data
			var ableToAdd = stackSize - inventory[item][1] # Checks if able to add by subtracting the item quantity in slot from stack size
			if ableToAdd >= itemQuantity: # If ableToAdd is greater then the amount we want to add
				inventory[item][1] += itemQuantity # Adds the rest of itemQuantity to the slot and returns
				return
			else: # Add what's possible, subtracts that from itemQuantity and tries to add that to whatever space left possible
				inventory[item][1] += ableToAdd
				itemQuantity = itemQuantity - ableToAdd
	
	# Item doesn't exist in inventory yet, add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [itemName, itemQuantity]
			return



func removeItem(slot: SlotClass):
	inventory.erase(slot.slotIndex)



func addItemToEmptySlot(item: ItemClass, slot: SlotClass):
	inventory[slot.slotIndex] = [item.itemName, item.itemQuantity]


func addItemQuantity(slot: SlotClass, quantityToAdd: int):
	inventory[slot.slotIndex][1] += quantityToAdd
