extends Node2D

var tile_type = 0
var alt_tile_type = -1

var click = false
var alt_click = false

var target = null
onready var m_col = $"../mouse_col"

func _ready():
	$"../gui/VSplitContainer2/ItemList".connect("item_selected", self, "_on_ItemList_item_selected")

func _process(delta):
	
	if Input.is_action_pressed("ctrl") and Input.is_action_pressed("primary_click"):
		m_col.monitoring = true
	else:
		m_col.monitoring = false
		
		if target != null:
			if click:
				target.rpc("edit_terrain", target.get_local_mouse_position(), tile_type)
			if alt_click:
				target.rpc("edit_terrain", target.get_local_mouse_position(), alt_tile_type)
	
	$"../mouse_col".position = get_local_mouse_position()
	

func _input(event):
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

func _on_mouse_col_body_entered(body):
	target = body
	$"../gui".target = body.name
