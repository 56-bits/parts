extends Node

#parameters of server to connect to
const SERVER_IP = "101.174.207.22"
const SERVER_PORT = 8080

var selfPeerID = 0

var player_pk = preload("res://client/player/player.tscn")

func _ready():
	#create client
	var client = NetworkedMultiplayerENet.new()
	client.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(client)
	
	selfPeerID = get_tree().get_network_unique_id()
	
	#connect functions
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	

func _peer_connected(id):
	if id != 1:
		print("peer %s connected".format(id))
		
		var player = player_pk.instance()
		player.name = String(id)
		player.set_network_master(id)
		$world/players.add_child(player)
		

func _peer_disconnected(id):
	if id != 1:
		print("peer %s disconnected".format(id))
		get_node("world/players/" + str(id)).queue_free()
	else:
		_server_disconnected()

func _connected_ok():
	print("connected to server")
	
	var player = player_pk.instance()
	player.name = String(selfPeerID)
	player.set_network_master(selfPeerID)
	$world/players.add_child(player)


func _connected_fail():
	print("connection failed")
	get_tree().change_scene("res://menues/main_menue.tscn")
	
	
func _server_disconnected():
	print("server disconnected")
	get_tree().change_scene("res://menues/main_menue.tscn")
	
