extends Node2D

var tile_type = 0
var alt_tile_type = -1

var click = false
var alt_click = false

var target = null
onready var m_col = $"../mouse_col"

func _ready():
	$"../gui/VSplitContainer2/ItemList".connect("item_selected", self, "_on_ItemList_item_selected")
	$"../gui/IslandDialog".connect("confirmed", self, "_on_island_create")

func _process(delta):
	
	if Input.is_action_pressed("primary_click"):
		if Input.is_key_pressed(KEY_CONTROL):
			$"../mouse_col".position = get_local_mouse_position()
			m_col.monitoring = true
		else:
			m_col.monitoring = false
	
	if click:
		target.rpc("edit_terrain", target.get_local_mouse_position(), tile_type)
	if alt_click:
		target.rpc("edit_terrain", target.get_local_mouse_position(), alt_tile_type)
	

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

func _on_island_create():
	var window = $"../gui/IslandDialog"
	var pos = Vector2(window.get_node("VBoxContainer/GridContainer/HSplitContainer/x_SpinBox").value,\
			window.get_node("VBoxContainer/GridContainer/HSplitContainer/x_SpinBox").value)
	var speed = window.get_node("VBoxContainer/GridContainer/IslandSpeed_SpinBox").value
	var active = window.get_node("VBoxContainer/IslandActivity").pressed
	$"../world".rpc("create_island", pos, speed, active)

func _on_mouse_col_body_entered(body):
	if body is Terrain:
		target = body
		$"../gui".target = body.name
