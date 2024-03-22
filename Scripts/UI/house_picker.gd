extends Node2D

@onready var tilemap = $TileMap

#Checks if mouse is at the house
var clickable = false

func _input(event):
	if clickable == true:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				print("click")
	

func _on_area_2d_mouse_entered():
	clickable = true
	

func _on_area_2d_mouse_exited():
	clickable = false
