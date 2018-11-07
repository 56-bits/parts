extends TileMap
class_name OccluderTileMap

func update_map(cell_v : Vector2, mask : bool) -> void:
	update_bitmask_area(cell_v)