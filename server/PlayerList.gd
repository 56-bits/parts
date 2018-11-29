extends Node
class_name PlayerList

sync var list = {}

enum {
	READY,
	UNREADY
}

func _init():
	pass

func add_player(id : int, info = null, state = UNREADY):
	list[id] = {
		"info" : info,
		"state" : state
	}

func set_player(id : int, info = null, state = null):
	if info != null :
		list[id]["info"] = info
	if state != null :
		list[id]["state"] = state

func get_player(id : int):
	return list[id]

func erase(id : int):
	list.erase(id)

func print_contents():
	print(list)

func ready_players():
	var res = {}
	
	for id in list:
		if list[id]["state"] == READY:
			res[id] = list[id]
	
	return res

func synchronise():
	rset("list", list)
