extends "network.gd"

func connect_to_server():
	network.create_client(default_ip, port)
	multiplayer.set_multiplayer_peer(network)
	multiplayer.connect("peer_connected", Callable(self, "_player_connected"))
	multiplayer.connect("peer_disconnected", Callable(self, "_player_disconnected"))
	multiplayer.connect("connection_failed", Callable(self, "_connected_fail"))
	multiplayer.connect("server_disconnected", Callable(self, "_server_disconnected"))
	ClientData.connect("_on_start_match_from_server", Callable(self, "start_match_from_server"))

func start_match_from_server():
	var world = MatchGame.instantiate()
	get_tree().get_root().add_child(world)
	world.setup()
	get_tree().current_scene.queue_free()
	print("Match signal received, switching to game scene")
	
func _player_connected(_id):
	#Network.player_netID = multiplayer.get_network_unique_id()
	var player = {"id": _id, "position": Vector2()}
	ServerData.players[_id] = player
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	
func _connected_ok():
	print("Successfully connected to server")
	var id = multiplayer.get_unique_id()
	var player = {"id": id, "position": Vector2()}
	ServerData.players[id] = player

func _connected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")
	
func update_position_on_server(player_id,pos,player):
	rpc_id(1, "_update_position_on_server", player_id, pos,player)


@rpc("any_peer") func _update_position_on_server(player_id, pos,player):
	if ServerData.players.has(player_id) :
		ServerData.players[player_id]["position"] = pos
		broadcast_position(player_id, pos,player)

func broadcast_position(player_id, pos,player):
	for peer_id in ServerData.players.keys():
		if peer_id != player_id:
			rpc_id(peer_id, "_update_position_from_server", player_id, pos,player)
			
signal update_player_position(player_id, position,player)

@rpc("any_peer") func _update_position_from_server(player_id, position,player):
	#print("_update_position_from_server: ",player_id, "-",position)
	if ServerData.players.has(player_id):
		ServerData.players[player_id]["position"] = position
		emit_signal("update_player_position", player_id, position,player)
		



