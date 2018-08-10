extends Node

var player_pk = preload("res://client/player/other_player.tscn")
sync var players = {}


func _ready():
	#start server
	var server = NetworkedMultiplayerENet.new()
	server.create_server($"/root/globals".settings.port, $"/root/globals".settings.player_limit)
	get_tree().set_network_peer(server)
	
	#connect functions
	get_tree().connect("network_peer_connected", self,"_client_connected"   )
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	print("client %s connected" % str(id))
	var player = player_pk.instance()
	player.name = String(id)
	player.set_network_master(id)
	$world/players.add_child(player)
	rpc_id(id, "get_player_inf")

func _client_disconnected(id):
	print("client %s disconnected" % str(id))
	
	get_node("world/players/" + str(id)).queue_free()
	
	players.erase(id)

remote func register_player(id, inf):
	players[id] = inf
	print(inf["player_name"], " has registered")
	rset("players", players)
	rpc("update_players")
	update_players()

func update_players():
	for p in $"world/players".get_children():
		p.get_node("Name").text = players[int(p.name)]["player_name"]
