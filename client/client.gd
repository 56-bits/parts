extends Node

onready var feedback = $"/root/globals".feedback

var selfPeerID = 0

var player_pk = preload("res://client/player/player.tscn")
var other_player_pk = preload("res://client/player/other_player.tscn")

sync var players = {}

onready var my_info = {
	"player_name" : $"/root/globals".settings.player_name
}

func _ready():
	#create client
	var client = NetworkedMultiplayerENet.new()
	client.create_client($"/root/globals".settings.server_ip, $"/root/globals".settings.port)
	get_tree().set_network_peer(client)
	
	feedback.new_message("connecting to server...")
	
	selfPeerID = get_tree().get_network_unique_id()
	
	$world.clear_world()
	
	#connect functions
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	

func _peer_connected(id):
	if id != 1:
		feedback.new_message("peer %s connected" % str(id))
		
		var player = other_player_pk.instance()
		player.name = String(id)
		player.set_network_master(id)
		$world/players.add_child(player)
		

func _peer_disconnected(id):
	if id != 1:
		feedback.new_message("peer %s disconnected" % str(id))
		get_node("world/players/" + str(id)).queue_free()
	else: #since the server is id 1, its is equivalent to the server disconnecting
		_server_disconnected()

func _connected_ok():
	feedback.new_message("connected to server", "good")
	
	var player = player_pk.instance()
	player.name = String(selfPeerID)
	player.set_network_master(selfPeerID)
	$world/players.add_child(player)
	
	$network_tick.start()

func _connected_fail():
	feedback.new_message("connection failed", "bad")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()

func _server_disconnected():
	feedback.new_message("server disconnected")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()
	

remote func get_player_inf():
	var inf = {
		"player_name" : $"/root/globals".settings.player_name
	}
	
	rpc_id(1, "register_player", selfPeerID, inf)

remote func update_players():
	for p in $"world/players".get_children():
		p.get_node("Name").text = players[int(p.name)]["player_name"]

remote func set_world(data):
	$world.clear_world()
	$world.set_world(data)

func _on_network_tick(): # is a signal from the timer
	get_node("world/players/%s" % str(selfPeerID))._network_tick()
