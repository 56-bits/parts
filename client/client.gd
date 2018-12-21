extends Node

var spawn_point = Vector2(0, -200)

var selfPeerID = 0

var player_pk = preload("res://client/player/Player.tscn")
var other_player_pk = preload("res://client/player/PlayerPuppet.tscn")

var my_player

var players = PlayerList.new()

var client : NetworkedMultiplayerENet

func _ready():
	players.name = "PlayerList"
	add_child(players)
	
	#create client
	client = NetworkedMultiplayerENet.new()
	client.create_client($"/root/globals".settings.server_ip, $"/root/globals".settings.port)
	get_tree().set_network_peer(client)
	
	f.new_message("connecting to server...")
	
	selfPeerID = get_tree().get_network_unique_id()
		
	#connect functions
	
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _peer_connected(id):
	if id != 1:
		f.new_message("peer %s connected" % str(id))
		
		var player = other_player_pk.instance()
		player.name = String(id)
		player.position = spawn_point
		player.set_network_master(id)
		$world/players.add_child(player)

func _peer_disconnected(id):
	if id != 1:
		f.new_message("peer %s disconnected" % players[id]["player_name"])
		get_node("world/players/" + str(id)).queue_free()
		players.erase(id)
	else: #since the server is id 1, its is equivalent to the server disconnecting
		_server_disconnected()

func _connected_ok():
	f.new_message("connected to server", "good")
	
	my_player = player_pk.instance()
	my_player.name = String(selfPeerID)
	my_player.position = spawn_point
	my_player.set_network_master(selfPeerID)
	$world/players.add_child(my_player)
	
	$network_tick.start()

func _connected_fail():
	f.new_message("connection failed", "bad")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()

func _server_disconnected():
	f.new_message("server disconnected", "bad")
	get_tree().change_scene("res://menue/main_menue.tscn")
	$network_tick.stop()

#touch if suicidal
remote func get_player_inf():
	f.new_message("registering self as %s with %s" % [str(selfPeerID), str(my_player.get_state())])
	rpc_id(1, "register_player", selfPeerID, my_player.get_state())
	request_sync()

remote func update_players():
	for p in $"world/players".get_children():
		p.set_state(players.get_player(int(p.name))["info"])
#		p.get_node("character/Name").text = players[int(p.name)]["player_name"]
#		p.get_node("character").colour = players[int(p.name)]["colour"]

func close_network():
	get_tree().set_network_peer(null)

# network bulk synchronisation
func request_sync():
	rpc_id(1, "sync_world", selfPeerID)
	f.new_message("Resync requested")

remote func recieve_sync(n):
	f.new_message("sync started", "good")
	var ds = RPCDataStreamer.new()
	ds.name = n
	add_child(ds)
	ds.start_recieving()
	ds.connect("stream_completed", self, "sync_completed")
	
func sync_completed(data):
	$world.clear_world()	
	$world.set_world(data)
	f.new_message("sync completed", "good")

func _on_network_tick(): # is a signal from the timer
	my_player._network_tick()
	$gui._network_tick()