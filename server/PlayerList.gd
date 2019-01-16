extends Node
class_name PlayerList

sync var list = {}

onready var other_player_pk = preload("res://client/player/PlayerPuppet.tscn")
onready var player_pk = preload("res://client/player/Player.tscn")

var self_id

enum {
	READY,
	UNREADY
}

func _init():
	pass

sync func add_player(id : int, info = null, state = UNREADY):
	list[id] = {
		"info" : info,
		"state" : state,
		"ref" : null
	}
	if id == self_id:
		create_players()
		yield(get_tree(), "idle_frame")
		var s = get_node("../world/players/%s"%str(id)).get_state()
		rpc("set_player", id, s)
	else:
		create_player(id)

sync func set_player(id : int, info = null, state = null):
	if info != null :
		list[id]["info"] = info
		list[id]["ref"].set_state(info)
	if state != null :
		list[id]["state"] = state

func get_player(id : int):
	return list[id]

sync func erase(id : int):
	list.erase(id)

func print_contents():
	print(list)

func ready_players():
	var res = {}
	
	for id in list:
		if list[id]["state"] == READY:
			res[id] = list[id]
	
	return res

func synchronise(id):
	rset_id(id, "list", list)

func create_player(id):
	var player = other_player_pk.instance()
	player.name = str(id)
	player.position = get_parent().spawn_point
	player.set_network_master(id)
	get_node("../world/players").add_child(player)
	list[id]["ref"] = player

func create_players():
	var player = player_pk.instance()
	print(typeof(player), player.get_state())
	player.name = str(self_id)
	player.position = get_parent().spawn_point
	player.set_network_master(self_id)
	get_node("../world/players").add_child(player)
	list[self_id]["ref"] = player
	
	for id in list:
		if id != self_id:
			create_player(id)