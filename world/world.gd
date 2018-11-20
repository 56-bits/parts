extends Node

var slave_npc = preload("res://characters/npc/NPCSlave.tscn")
var island = preload("res://world/structures/FloatingIsland.tscn")

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
#		var npc_data = {}
#
#		npc_data["name"] = npc.name
#		npc_data["colour"] = npc.get_node("character").colour
#
#		npcs[npc.name] = npc_data
		
		npcs[npc.name] = npc.get_state()
	
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
			var npc_state = npcs[id]
			var n = slave_npc.instance()
			n.set_state(npc_state)
			$npcs.add_child(n)
	
	var structures = data["structures"]
	for id in structures:
		var struct_state = structures[id]
		var s = island.instance()
		s.set_state(struct_state)
		$Structures.add_child(s)

sync func edit_terrain(pos, type = 0):
	var cell = $terrain.world_to_map(pos)
	$terrain.set_cellv(cell, type)

func _network_tick():
	for c in $Structures.get_children():
		c._network_tick()
	for npc in $npcs.get_children():
		npc._network_tick()

sync func create_island(pos, spd, act):
	var i = island.instance()
	i.is_active = act
	i.speed = spd
	i.position = pos
	$Structures.add_child(i)
	i.name = str($Structures.get_child_count())

func get_cell_pos(pos) -> Vector2:
	return $terrain.world_to_map(pos)

func clear_world() -> void:
	$terrain.clear()
	for c in $Structures.get_children():
		c.queue_free()
	for c in $npcs.get_children():
		c.queue_free()