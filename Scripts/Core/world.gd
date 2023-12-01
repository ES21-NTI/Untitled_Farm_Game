extends Node2D

@onready var tilemap = $Tilemap
@onready var player = $Player
var egg = preload("res://Scenes/Items/ItemDrop.tscn")

signal placeable #signal to say something could be placed

# Tilemap layers
var groundLayer = 1
var environmentLayer = 2
var cropsLayer = 3

# Custom Data (bools)
var placeSeedCD = "canPlaceSeeds"
var canHoeGroundCD = "canHoeGround" 
var cropsPlacedCD = "cropsPlaced"
var harvestCD = "harvest"

# Initialized list of all the different dirt tiles
var dirtTiles = []


func retrievingCustomData(usingPos, customDataLayer, layer):
	var tileData = tilemap.get_cell_tile_data(layer, usingPos) # Gets the tilemaps tile data from using position
	if tileData:
		return tileData.get_custom_data(customDataLayer)
	else:
		return false



func handleSeed(placingPos, level, atlasCoord, finalSeedLevel):
	var sourceID = 0
	tilemap.set_cell(cropsLayer, placingPos, sourceID, atlasCoord)
#	print(cropsLayer)
#	print(placingPos)
#	print(sourceID)
#	print(atlasCoord)
	await get_tree().create_timer(1.0).timeout # Creates a timer and sets it for 5 seconds
	
	if level == finalSeedLevel: # Checks if the current crop level is at the final level
		return
	else:
		var newAtlas = Vector2i(atlasCoord.x + 1, atlasCoord.y) # Creates a temporary new atlas and adds +1 to the x value
		handleSeed(placingPos, level + 1, newAtlas, finalSeedLevel) # Changes the tile to the next one


#func _on_reach_mouse_entered(): # Activates whenever mouse is within the Area2D Reach 
#	canReach = true


#func _on_reach_mouse_exited(): # Dectivates whenever mouse leaves the Area2D Reach 
#	canReach = false

func _on_hotbar_item_placed():
	var mousePos = get_global_mouse_position() # Gets mouse position
	var tileMousePos = tilemap.local_to_map(mousePos) # Converts mouse position to tilemap grid coordinates
	print(tileMousePos)
	var playerPos = player.position # Gets players position
	var tilePlayerPos = tilemap.local_to_map(playerPos) # Converts players position to tilemap grid coordinates
	
	var placingPos = Vector2(0,0)
	
#VVV No matter where you click the thing will happen next to the player
	if tileMousePos[0] > tilePlayerPos[0]:
		placingPos[0] = tilePlayerPos[0] + 1
	else:
		placingPos[0] = tilePlayerPos[0] - 1
		
	if tileMousePos[1] > tilePlayerPos[1]:
		placingPos[1] = tilePlayerPos[1] + 1
	else:
		placingPos[1] = tilePlayerPos[1] - 1
		
	if tileMousePos[0] == tilePlayerPos[0]:
		placingPos[0] = tilePlayerPos[0]
		
	if tileMousePos[1] == tilePlayerPos[1]:
		placingPos[1] = tilePlayerPos[1]
	
	if tileMousePos != tilePlayerPos:
		if Global.farmingMode == Global.FARMING_MODES.SEEDS:
			var atlasCoord = Vector2i(11, 1) # Coordinates for the seeds item on tilemap
			if retrievingCustomData(placingPos, placeSeedCD, environmentLayer):
				var level = 0 # First state of the crop
				var finalSeedLevel = 3 # Final state of the crop
				if retrievingCustomData(placingPos, cropsPlacedCD, cropsLayer): #Checks if there are any crops the the tile
					pass
				else:
					placeable.emit() #Tells hotbar the seeds could be placed 
					handleSeed(placingPos, level, atlasCoord, finalSeedLevel) #Places the seeds on the tilemap
		
		elif Global.farmingMode == Global.FARMING_MODES.HOE:
			if retrievingCustomData(placingPos, canHoeGroundCD, groundLayer):
				dirtTiles.append(placingPos)
				tilemap.set_cells_terrain_connect(environmentLayer, dirtTiles, 3,0)
				
		elif Global.farmingMode == Global.FARMING_MODES.SCYTHE:
			var atlasCoord = Vector2i(14, 1)
			if retrievingCustomData(placingPos, harvestCD, cropsLayer):
				print("yay")
				
				atlasCoord = Vector2i(-1, -1) # Sets the tile index to clear
				tilemap.set_cell(cropsLayer, placingPos, 0, atlasCoord) # Removes 
				
				# Spawns item
				var scene_instance = egg.instantiate() 
				add_child(scene_instance)
				scene_instance.collision_layer = 4 # Sets the collision layer to 3 so that pickupZone can detect it
				print(placingPos)
				scene_instance.global_position = tilemap.map_to_local(placingPos) # Sets the spawned item position to be tilemaps placingPos
				
#				fix drop system
				
		

