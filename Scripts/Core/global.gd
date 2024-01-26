extends Node

signal scene_changed()

# All of the different modes
enum FARMING_MODES {SEEDS, HOE, SCYTHE, NONE}

var farmingMode = FARMING_MODES.NONE

var plantSelected = 1

var numOfCarrots = 0
var numOfOnions = 0

# Variables related to the recently dropped item so that the itemDrop script knows what was dropped and how much
var itemDropName
var itemDropCategory
var itemDropQuantity

# Variable used to know the current scene for a scene change
var current_scene_name

func _ready():
		current_scene_name = get_tree().get_current_scene().name
	
func change_scene(scene_path):
	# Gets the current scene
		current_scene_name = scene_path.get_file().get_basename()
		var current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	# Removes it
		current_scene.queue_free()
	# Loads new scene
		var new_scene = load(scene_path).instantiate()
		get_tree().get_root().call_deferred("add_child", new_scene) 
		get_tree().call_deferred("set_current_scene", new_scene)
		call_deferred("post_scene_change_initialization")
	

func post_scene_change_initialization():
	scene_changed.emit()
