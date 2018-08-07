extends Node

#server parameters
const PORT = 8080
const MAX_PLAYERS = 32

var player_pk = preload("res://client/player/player.tscn")

func _ready():
	#start server
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)
	
	#connect functions
	get_tree().connect("network_peer_connected", self,"_client_connected"   )
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	print("client %s connected".format(id))
	var player = player_pk.instance()
	player.name = String(id)
	player.set_network_master(id)
	$world/players.add_child(player)

func _client_disconnected(id):
	print("client %s disconnected".format(id))
	
	get_node("world/players/" + str(id)).queue_free()

remote func make_player(id):
	