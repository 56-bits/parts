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
	
	for npc in $npcs.get_children():
		var npc_data = {}
		
		npc_data["name"] = npc.name
		npc_data["colour"] = npc.get_node("character").colour
		
		npcs[npc.name] = npc_data
	
	data["npcs"] = npcs
	
	var structures = {}
	
	for struct in $Structures.get_children():
		structures[struct.name] = struct.get_state()
	
	data["structures"] = structures
	return data

func set_world(data):	
	var terrain = data["terrain"]
	
	for type in terrain.keys():
		for pos in terrain[type]:
			$terrain.set_cellv(pos, type)
	
	if !is_network_master():
		var npcs = data["npcs"]
		for id in npcs:
			var npc = npcs[id]
			var n = slave_npc.instance()
			n.name = npc["name"]
			n.get_node("character").colour = npc["colour"]
			$npcs.add_child(n)
	
	var structures = data["structures"]
	print(structures)
	for struct in structures:
		$Structures.get_node(struct).set_state(structures[struct])

sync func edit_terrain(pos, type = 0):
	var cell = $terrain.world_to_map(pos)
	$terrain.set_cellv(cell, type)

func _network_tick():
	for c in $Structures.get_children():
		c._network_tick()
	for npc in $npcs.get_children():
		npc._network_tick()

func get_cell_pos(pos) -> Vector2:
	return $terrain.world_to_map(pos)

func clear_world() -> void:
	$terrain.clear()