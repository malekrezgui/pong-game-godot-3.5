extends "network.gd"

var match_started=false

func start_server():
	print("_start_server()")
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_connected", self, "_player_connected")
	network.connect("peer_disconnected", self, "_player_disconnected")
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	addPlayerOnServer(player_id)
	
func addPlayerOnServer(peer_id: int):
	ServerData.players[peer_id] = {"id": peer_id,"side":Data.PLAYER_POSITION_MAP[ServerData.players.size()]}
	print(ServerData.players)
	if ServerData.players.size() >= 2:
		match_started=true
		startMatchByServer()
		
func startMatchByServer():
	for peer_id in ServerData.players.keys():
		rpc_id(peer_id, "_onStartMatchFromServer",ServerData.players)
	

remote func _onStartMatchFromServer(players):
	print("match started:", players)
	ServerData.players = players
	ClientData.emit_signal("_on_start_match_from_server")
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	
	
remote func _update_ball_position(pos):
	broadcast_ball_position(pos)

func broadcast_ball_position(pos):
	for peer_id in ServerData.players.keys():
		rpc_id(1, "_update_ball_position_from_server", pos)
		print("from broadcast >>> ",pos)
		
signal on_update_ball_position_from_server(pos)

remote func _update_ball_position_from_server(pos):
	print("send with signal >>> ",pos)
	emit_signal("on_update_ball_position_from_server", pos)		

		

