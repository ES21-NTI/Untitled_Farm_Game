extends Node2D

@onready var tilemap = $Tilemap
@onready var player = $Player


# Tilemap layers
var groundLayer = 1
var environmentLayer = 2

# Custom Data (bools)
var placeSeedCD = "canPlaceSeeds"
var canHoeGroundCD = "canHoeGround" 

# All of the different modes
enum FARMING_MODES {SEEDS, DIRT}

var farmingMode = FARMING_MODES.DIRT

# Initialized list of all the different dirt tiles
var dirtTiles = []

var canReach = false

func _input(_event):
	if Input.is_action_just_pressed("1"):
		print("Dirt Selected")
		farmingMode = FARMING_MODES.DIRT
	if Input.is_action_just_pressed("2"):
		print("Seeds Selected")
		farmingMode = FARMING_MODES.SEEDS
	if Input.is_action_just_pressed("Use"): # Left mouse button
		
		var mousePos = get_global_mouse_position() # Gets mouse position
		var tileMousePos = tilemap.local_to_map(mousePos) # Converts mouse position to tilemap grid coordinates
		
		var playerPos = player.position # Gets players position
		var tilePlayerPos = tilemap.local_to_map(playerPos) # Converts players position to tilemap grid coordinates
		
		
		if tileMousePos != tilePlayerPos && canReach == true:
		
			if farmingMode == FARMING_MODES.SEEDS:
				var atlasCoord = Vector2i(11, 1) # Coordinates for the seeds item on tilemap
				if retrievingCustomData(tileMousePos, placeSeedCD, groundLayer):
					var level = 0 # First state of the crop
					var finalSeedLevel = 3 # Final state of the crop
					handleSeed(tileMousePos, level, atlasCoord, finalSeedLevel)
			elif farmingMode == FARMING_MODES.DIRT:
				if retrievingCustomData(tileMousePos, canHoeGroundCD, groundLayer):
					dirtTiles.append(tileMousePos)
					tilemap.set_cells_terrain_connect(groundLayer, dirtTiles, 2,0)
		
		else: 
			print("Can't reach")




func retrievingCustomData(tileMousePos, customDataLayer, layer):
	var tileData = tilemap.get_cell_tile_data(layer, tileMousePos) # Gets the tilemaps tile data from mouse position
	if tileData:
		return tileData.get_custom_data(customDataLayer)
	else:
		return false



func handleSeed(tileMapPos, level, atlasCoord, finalSeedLevel):
	var sourceID = 0
	tilemap.set_cell(environmentLayer, tileMapPos, sourceID, atlasCoord)
	
	await get_tree().create_timer(5.0).timeout # Creates a timer and sets it for 5 seconds
	
	if level == finalSeedLevel: # Checks if the current crop level is at the final level
		return
	else:
		var newAtlas = Vector2i(atlasCoord.x + 1, atlasCoord.y) # Creates a temporary new atlas and adds +1 to the x value
		handleSeed(tileMapPos, level + 1, newAtlas, finalSeedLevel) # Changes the tile to the next one


func _on_reach_mouse_entered(): # Activates whenever mouse is within the Area2D Reach 
	canReach = true


func _on_reach_mouse_exited(): # Dectivates whenever mouse leaves the Area2D Reach 
	canReach = false
