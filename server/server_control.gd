extends Node2D

var tile_type = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$"../world".rpc("edit_terrain", get_local_mouse_position(), tile_type)
	
	if get_tree().is_network_server():
		#camera controll
		if Input.is_action_pressed("move_right"):
			$"../Camera2D".position.x += 30
		if Input.is_action_pressed("move_left"):
			$"../Camera2D".position.x -= 30
		if Input.is_action_pressed("move_up"):
			$"../Camera2D".position.y -= 30
		if Input.is_action_pressed("move_down"):
			$"../Camera2D".position.y += 30


func _on_ItemList_item_selected(index):
	tile_type = index - 1
