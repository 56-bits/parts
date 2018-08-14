extends Node

func _ready():
	pass

func world_data():
	var data = {}
	
	var terrain = {}
	#go through every block type
	for set in $terrain.tile_set.get_tiles_ids():
		# get the positions for every block type
		terrain[set] = $terrain.get_used_cells_by_id(set)
	
	data["terrain"] = terrain
	
	return data

func set_world(data):
	var terrain = data["terrain"]
	
	for type in terrain.keys():
		for pos in terrain[type]:
			$terrain.set_cellv(pos, type)
		

sync func edit_terrain(pos, type = 0):
	var cell = $terrain.world_to_map(pos)
	if cell.y < 0:
		$terrain.set_cellv(cell, type)

func get_cell_pos(pos):
	return $terrain.world_to_map(pos)

func clear_world():
	$terrain.clear()