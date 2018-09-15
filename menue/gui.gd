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
	$VSplitContainer/HSplitContainer/coordinates.text = str(cell_pos)
	player_list()

func _process(delta):
	if Input.is_action_just_pressed("gui_exit"):
		$menu.visible = !$menu.visible

func player_list():
	var players = $"../".players
	
	for child in $VSplitContainer/VBoxContainer.get_children():
		child.queue_free()
	
	for p in players:
		var name = players[p]["player_name"]
		var pos = get_node("../world/players/%s" % str(p)).position
		var coord = $"../world".get_cell_pos(pos)
		coord.y = -coord.y
		var msg = name + ", " + str(coord)
		var label = Label.new()
		label.text = msg
		$VSplitContainer/VBoxContainer.add_child(label)

func _on_show_player_list_toggled(button_pressed):
	$VSplitContainer/VBoxContainer.visible = button_pressed
	$VSplitContainer/HSplitContainer/show_player_list.release_focus()

func _on_exit_button_pressed():
	get_tree().change_scene("res://menue/main_menue.tscn")

func _on_back_button_pressed():
	$menu.visible = false
