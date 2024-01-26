extends Node2D

@onready var tilemap = $Tilemap

func _on_scene_changed():
	queue_free()

func _on_trigger_body_entered(body):
	if body.is_in_group("Player"):
		Global.change_scene("res://Scenes/Core/World.tscn")
		Global.scene_changed.connect(_on_scene_changed)
