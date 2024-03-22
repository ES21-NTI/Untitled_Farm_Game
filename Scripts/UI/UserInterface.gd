extends CanvasLayer

var holdingItem = null

#Displays UI for Inventory and HousePick
func _input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initializeInventory()
	
	if event.is_action_pressed("ScrollUp"):
		PlayerInventory.activeItemScrollDown()
	elif event.is_action_pressed("ScrollDown"):
		PlayerInventory.activeItemScrollUp()
	
	if event.is_action_pressed("HousePick"):
		$HousePicker.visible = !$HousePicker.visible
