extends TileMap
class_name Terrain

var nav = AStar.new()
var occluder_map = OccluderTileMap.new()

func _ready():
	add_child(occluder_map)

sync func direct_edit(cell, type = 0):
	set_cellv(cell, type)

sync func direct_list_edit(list : Dictionary):
	for pos in list:
		set_cellv(pos, list[pos])

sync func edit_terrain(pos, type = 0):
	var cell = world_to_map(pos)
	
	var neighbours = [
			get_cell(cell.x, cell.y + 1),
			get_cell(cell.x, cell.y - 1),
			get_cell(cell.x + 1, cell.y),
			get_cell(cell.x - 1, cell.y)
	]

	var is_placable = (get_cellv(cell) != type) and \
			(neighbours.max() > -1)

	if !is_placable and type != -1:
		return false

	set_cellv(cell, type)
	
#	var mask = tile_set.tile_get_light_occluder(type)
#	print(mask)
	
	return true

func get_state() -> Dictionary:
	var state = {}
	
	state["id"] = name
	
	var terrain = {}
	#go through every block type
	for set in tile_set.get_tiles_ids():
		# get the positions for every block type
		terrain[set] = get_used_cells_by_id(set)
	
	state["terrain"] = terrain
	return state

func set_state(state : Dictionary):
	name = state["id"]
	
	var terrain = state["terrain"]
	
	for type in terrain.keys():
		for pos in terrain[type]:
			set_cellv(pos, type)

func get_cell_pos(pos) -> Vector2:
	return $terrain.world_to_map(pos)

func clear_terrain() -> void:
	$terrain.clear()