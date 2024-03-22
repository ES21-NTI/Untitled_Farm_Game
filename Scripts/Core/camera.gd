extends Camera2D

@export var tilemap: TileMap

func _ready(): # Calculates the size of the map and limits the camera from moving outside
	var mapRect = tilemap.get_used_rect() # Checks how big the world tilemap is
	var tileSize = tilemap.cell_quadrant_size # Checks the tile size
	var worldSize = mapRect.size * tileSize 
	limit_top = 0
	limit_left = 0
	limit_right = worldSize.x
	limit_bottom = worldSize.y
