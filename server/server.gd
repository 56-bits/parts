extends Node

onready var feedback = $"/root/globals".feedback

var player_pk = preload("res://client/player/other_player.tscn")
sync var players = {}


func _ready():
	
	#start server
	var server = NetworkedMultiplayerENet.new()
	server.create_server($"/root/globals".settings.port, $"/root/globals".settings.player_limit)
	get_tree().set_network_peer(server)
	
	feedback.new_message("server created")
		
	#connect functions
	get_tree().connect("network_peer_connected", self,"_client_connected"   )
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	feedback.new_message("client %s connected" % str(id))
	
	#create player locally
	var player = player_pk.instance()
	player.name = String(id)
	player.set_network_master(id)
	$world/players.add_child(player)
	
	#get data from player
	rpc_id(id, "get_player_inf")
	
	#send world data to player
	var data = $world.world_data()
	rpc_id(id, "set_world", data)

func _client_disconnected(id):
	feedback.new_message("client %s disconnected" % str(id))
	
	get_node("world/players/" + str(id)).queue_free()
	
	players.erase(id)

remote func register_player(id, inf):
	players[id] = inf
	feedback.new_message(inf["player_name"] + " has registered")
	rset("players", players)
	rpc("update_players")
	update_players()

func update_players():
	for p in $"world/players".get_children():
		p.get_node("Name").text = players[int(p.name)]["player_name"]
		p.get_node("character").colour = players[int(p.name)]["colour"]