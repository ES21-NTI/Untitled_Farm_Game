extends CanvasLayer

var holdingItem = null

func _input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initializeInventory()
	
	if event.is_action_pressed("ScrollUp"):
		PlayerInventory.activeItemScrollDown()
	elif event.is_action_pressed("ScrollDown"):
		PlayerInventory.activeItemScrollUp()
