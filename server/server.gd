extends Node

var player_pk = preload("res://client/player/PlayerPuppet.tscn")
var players = PlayerList.new()

export var spawn_point := Vector2(0, -200)

var npc_pk = preload("res://characters/npc/NPC.tscn")

func _ready():
	players.name = "PlayerList"
	add_child(players)
	
	for i in range(3):#round(rand_range(5, 20))):
		var n = npc_pk.instance()
		n.name = str(i)
		n.position = spawn_point + Vector2(randi()%200, 0)
		$world/npcs.add_child(n)
	
	#start server
	var server = NetworkedMultiplayerENet.new()
		
	var status = server.create_server(globals.settings.port, globals.settings.player_limit)
	
	if status == ERR_CANT_CREATE:
		f.new_message("Server could not be created", "bad")
		get_tree().change_scene("res://menue/main_menue.tscn")
	
	get_tree().set_network_peer(server)
	
	f.new_message("server created")
	
	$network_tick.start()
	
	#connect functions
	get_tree().connect("network_peer_connected", self,"_client_connected"   )
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	f.new_message("client %s connected" % str(id))
	
	players.add_player(id)
	
	#get data from player
	rpc_id(id, "get_player_inf")

func _client_disconnected(id):
	f.new_message("client %s aka %s disconnected" % [str(id), players.get_player(id)["info"]["name"]])
	
	get_node("world/players/" + str(id)).queue_free()
	
	players.erase(id)

remote func register_player(id, inf):
	players.set_player(id, inf, players.READY)
	
	#create player locally
	var player = player_pk.instance()
	player.set_state(inf)
	player.set_network_master(id)
	$world/players.add_child(player)
	
	players.synchronise()
	rpc("update_players")
	update_players()
	f.m(inf["name"] + " has registered", f.GOOD)

remote func sync_world(id : int):
	var data = $world.world_data()
	f.m("%s aka %s requested a resync" % [id, players.get_player(id)["info"]["name"]])
	rpc_id(id, "recieve_sync", data)

sync func update_players():
	for p in $"world/players".get_children():
		p.set_state(players.get_player(int(p.name))["info"])
#		p.get_node("character/Name").text = players[int(p.name)]["player_name"]
#		p.get_node("character").colour = players[int(p.name)]["colour"]

func close_network():
	get_tree().set_network_peer(null)
	f.m("Network closed")

func _on_network_tick():
	$world._network_tick()
