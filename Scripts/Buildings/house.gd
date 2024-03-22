extends Node2D

@onready var tilemap = $Tilemap

<<<<<<< HEAD
func _on_scene_changed():
	queue_free()

func _on_trigger_body_entered(body):
	if body.is_in_group("Player"):
		Global.change_scene("res://Scenes/Core/World.tscn")
		Global.scene_changed.connect(_on_scene_changed)
=======
var available = false

func _input(event):
	if Input.is_action_pressed("Interact") and available == true:
		print("interact")
		# Changes scene to World
		Global.change_scene("res://Scenes/Core/world.tscn")
		# Removes scene
		queue_free()

# Tell system to change to world scene
func _on_trigger_body_entered(body):
	if body.is_in_group("Player"):
		print("player in area")
		# Change scene to house
		available = true
		

func _on_trigger_body_exited(body):
	available = false
>>>>>>> 832d077 (merged no.11 and whooooops versions)
