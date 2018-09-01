extends Node

var slave_npc = preload("res://characters/npc/NPCSlave.tscn")

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
	
	var npcs = {}
	
	if is_network_master():
		for npc in $npcs.get_children():
			var npc_data = {}
			
			npc_data["name"] = npc.name
			npc_data["colour"] = npc.get_node("character").colour
			
			npcs[npc.name] = npc_data
		
		data["npcs"] = npcs
	
	return data

func set_world(data):
	var terrain = data["terrain"]
	
	for type in terrain.keys():
		for pos in terrain[type]:
			$terrain.set_cellv(pos, type)
	
	if !is_network_master():
		var npcs = data["npcs"]
		print(npcs)
		for id in npcs:
			var npc = npcs[id]
			var n = slave_npc.instance()
			n.name = npc["name"]
			n.get_node("character").colour = npc["colour"]
			$npcs.add_child(n)

sync func edit_terrain(pos, type = 0):
	var cell = $terrain.world_to_map(pos)
	if cell.y < 0:
		$terrain.set_cellv(cell, type)

func get_cell_pos(pos) -> Vector2:
	return $terrain.world_to_map(pos)

func clear_world() -> void:
	$terrain.clear()