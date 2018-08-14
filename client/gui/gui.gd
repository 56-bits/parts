extends CanvasLayer

var terrain = preload("res://world/terrain/test_set.tres")

func _ready():	
	$ItemList.add_item("remove")
	for tile in terrain.get_tiles_ids():
		var icon = terrain.tile_get_texture(tile)
		var tile_name = terrain.tile_get_name(tile)
		$ItemList.add_item(tile_name, icon)

func _network_tick():
	var player_pos = get_node("../world/players/%s" % str($"../".selfPeerID)).position
	var cell_pos = $"../world".get_cell_pos(player_pos)
	cell_pos.y = -cell_pos.y
	$coordinates.text = str(cell_pos)

func _process(delta):
	if is_network_master():
		var camera_pos = $"../Camera2D".position
		var cell_pos = $"../world".get_cell_pos(camera_pos)
		cell_pos.y = -cell_pos.y
		$coordinates.text = str(cell_pos)