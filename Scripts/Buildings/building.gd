extends Node2D

var available = false

#Changes scene to house if player is in area and press E
func _input(event):
	if Input.is_action_pressed("Interact") and available == true:
		print("interact")
		Global.change_scene("res://Scenes/Buildings/house.tscn")
		Global.scene_changed.connect(_on_scene_changed)

#Detects if player is in the exit area
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("player in area")
		available = true


func _on_scene_changed():
	queue_free()


func _on_area_2d_body_exited(body):
	available = false
