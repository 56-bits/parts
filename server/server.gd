extends Node

onready var feedback = $"/root/globals".feedback

var player_pk = preload("res://client/player/PlayerSlave.tscn")
sync var players = {}

export var spawn_point := Vector2(0, -200)

var npc_pk = preload("res://characters/npc/NPC.tscn")

func _ready():
	
	for i in range(round(rand_range(5, 20))):
		var n = npc_pk.instance()
		n.name = str(i)
		n.position = spawn_point + Vector2(randi()%200, 0)
		$world/npcs.add_child(n)
	
	#start server
	var server = NetworkedMultiplayerENet.new()
	server.create_server($"/root/globals".settings.port, $"/root/globals".settings.player_limit)
	get_tree().set_network_peer(server)
	
	feedback.new_message("server created")
	
	$network_tick.start()
	
	#connect functions
	get_tree().connect("network_peer_connected", self,"_client_connected"   )
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	feedback.new_message("client %s connected" % str(id))
	
	#create player locally
	var player = player_pk.instance()
	player.name = String(id)
	player.position = spawn_point
	player.set_network_master(id)
	$world/players.add_child(player)
	
	#get data from player
	rpc_id(id, "get_player_inf")

func _client_disconnected(id):
	feedback.new_message("client %s aka %s disconnected" % [str(id), players[id]["player_name"]])
	
	get_node("world/players/" + str(id)).queue_free()
	
	players.erase(id)

remote func register_player(id, inf):
	players[id] = inf
	feedback.new_message(inf["player_name"] + " has registered", "good")
	rset("players", players)
	rpc("update_players")
	update_players()

remote func sync_world(id : int):
	var data = $world.world_data()
	feedback.new_message("%s aka %s requested a resync" % [id, players[id]["player_name"]])
	rpc_id(id, "recieve_sync", data)

func update_players():
	for p in $"world/players".get_children():
		p.get_node("character/Name").text = players[int(p.name)]["player_name"]
		p.get_node("character").colour = players[int(p.name)]["colour"]

func _on_network_tick():
	for npc in $world/npcs.get_children():
		npc._network_tick()
