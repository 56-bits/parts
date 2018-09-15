extends "res://menue/gui.gd"

func _network_tick():
	var player_pos = get_node("../world/players/%s" % str($"../".selfPeerID)).position
	var cell_pos = $"../world".get_cell_pos(player_pos)
	cell_pos.y = -cell_pos.y
	$VSplitContainer/HSplitContainer/coordinates.text = str(cell_pos)
	player_list()

func _on_resync_button_pressed():
	$"../".request_sync()
	$menu.visible = false
