extends "res://menue/gui.gd"

func _process(delta):
	var camera_pos = $"../Camera2D".position
	var cell_pos = $"../world".get_cell_pos(camera_pos)
	cell_pos.y = -cell_pos.y
	$VSplitContainer/HSplitContainer/coordinates.text = str(cell_pos)
	player_list()

#func _on_createisland_Button_pressed():
#	$IslandDialog.popup_centered()