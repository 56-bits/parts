extends CanvasLayer

var terrain = preload("res://world/terrain/test_set.tres")

func _ready():
	$ItemList.add_item("remove")
	for tile in terrain.get_tiles_ids():
		var icon = terrain.tile_get_texture(tile)
		var tile_name = terrain.tile_get_name(tile)
		$ItemList.add_item(tile_name, icon)

