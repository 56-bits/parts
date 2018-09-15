extends TileMap
class_name Terrain

sync func edit_terrain(pos, type = 0):
	var cell = $terrain.world_to_map(pos)
	$terrain.set_cellv(cell, type)

func get_state() -> Dictionary:
	var state = {}
	
	var terrain = {}
	#go through every block type
	for set in tile_set.get_tiles_ids():
		# get the positions for every block type
		terrain[set] = get_used_cells_by_id(set)
	
	state["terrain"] = terrain
	return state

func set_state(state : Dictionary):
	var terrain = state["terrain"]
	
	for type in terrain.keys():
		for pos in terrain[type]:
			set_cellv(pos, type)

func get_cell_pos(pos) -> Vector2:
	return $terrain.world_to_map(pos)

func clear_terrain() -> void:
	$terrain.clear()