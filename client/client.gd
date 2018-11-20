extends Node

onready var feedback = globals.feedback

var spawn_point = Vector2(0, -200)

var selfPeerID = 0

var player_pk = preload("res://client/player/Player.tscn")
var other_player_pk = preload("res://client/player/PlayerSlave.tscn")

sync var players = {}

onready var my_info = {
	"player_name" : globals.settings.player_name,
	"colour" : globals.settings.colour
}

func _ready():
	#create client
	var client = NetworkedMultiplayerENet.new()
	client.create_client($"/root/globals".settings.server_ip, $"/root/globals".settings.port)
	get_tree().set_network_peer(client)
	
	feedback.new_message("connecting to server...")
	
	selfPeerID = get_tree().get_network_unique_id()
		
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
		player.position = spawn_point
		player.set_network_master(id)
		$world/players.add_child(player)

func _peer_disconnected(id):
	if id != 1:
		feedback.new_message("peer %s disconnected" % players[id]["player_name"])
		get_node("world/players/" + str(id)).queue_free()
		players.erase(id)
	else: #since the server is id 1, its is equivalent to the server disconnecting
		_server_disconnected()

func _connected_ok():
	feedback.new_message("connected to server", "good")
	
	var player = player_pk.instance()
	player.name = String(selfPeerID)
	player.position = spawn_point
	player.set_network_master(selfPeerID)
	player.get_node("character").colour = $"/root/globals".settings.colour
	$world/players.add_child(player)
	
	$network_tick.start()

func _connected_fail():
	feedback.new_message("connection failed", "bad")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()

func _server_disconnected():
	feedback.new_message("server disconnected", "bad")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()

remote func get_player_inf():
	rpc_id(1, "register_player", selfPeerID, my_info)
	request_sync()

remote func update_players():
	for p in $"world/players".get_children():
		p.get_node("character/Name").text = players[int(p.name)]["player_name"]
		p.get_node("character").colour = players[int(p.name)]["colour"]

# network bulk synchronisation
func request_sync():
	rpc_id(1, "sync_world", selfPeerID)
	feedback.new_message("Resync requested")

remote func recieve_sync(data):
	$world.clear_world()
	$world.set_world(data)
	feedback.new_message("Resync successfull", "good")

func _on_network_tick(): # is a signal from the timer
	get_node("world/players/%s" % str(selfPeerID))._network_tick()
	$gui._network_tick()
