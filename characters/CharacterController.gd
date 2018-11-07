tool
extends Node

var movement := Vector2()
var sprint := false

export var position : Vector2 setget set_pos, get_pos
var last_pos := position

func _ready():
	set_meta("editable_children", false)
	print(get_meta_list())

func _network_tick():
	if self.position != last_pos:
		rpc("update_movement", self.position, movement, sprint)
		last_pos = self.position

func set_pos(pos : Vector2) -> void:
	if has_node("character"):
		$character.position = pos
	position = pos

func get_pos() -> Vector2:
	return $character.position

func get_state() -> Dictionary:
	var state := {}
	
	state["id"] = name
	state["name"] = $character/Name.text
	state["colour"] = $character.colour
	
	return state

func set_state(state : Dictionary):
	name = state["id"]
	$character/Name.text = state["name"]
	$character.colour = state["colour"]