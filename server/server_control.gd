extends Node2D

var tile_type = 0
var alt_tile_type = -1

var click = false
var alt_click = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	
	if click:
		$"../world".rpc("edit_terrain", get_local_mouse_position(), tile_type)
	if alt_click:
		$"../world".rpc("edit_terrain", get_local_mouse_position(), alt_tile_type)
	

func _unhandled_input(event):
	if event.is_action_pressed("primary_click"):
		click = true
	if event.is_action_released("primary_click"):
		click = false
	
	if event.is_action_pressed("secondary_click"):
		alt_click = true
	if event.is_action_released("secondary_click"):
		alt_click = false

func _on_ItemList_item_selected(index):
	tile_type = index - 1

func _on_ItemList_item_rmb_selected(index, at_position):
	alt_tile_type = index - 1
