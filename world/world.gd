extends Node

onready var ball = $Ball
onready var screen_size = get_viewport().size
onready var start_label=$StartLabel
onready var restart_button =$RestartButton
onready var player1 = $PlayerLeft
onready var player2 =$PlayerRight
var game_paused = true

func _physics_process(delta):
	pass

func _ready():
	ClientNetwork.connect("update_player_position", self, "_on_update_player_position")
	ClientNetwork.connect("on_update_ball_position_from_server", self, "_on_update_ball_position_from_server")
	
func setup():
	for k in ServerData.players.keys():
		if ServerData.players[k].side == 0:
			player1.set_ownership(ServerData.players[k].id)
		if ServerData.players[k].side == 1:
			player2.set_ownership(ServerData.players[k].id)
	

func _on_LeftWall_body_entered(body):
	ball.position =Vector2(100 ,screen_size.y/2)
	

func _on_RightWall_body_entered(body):
	ball.position =Vector2(screen_size.x - 100 ,screen_size.y/2)


func reset_player_position():
	player1.position.x = 50
	player1.position.y=screen_size.y/2
	player2.position.x = screen_size.x-50
	player2.position.y = screen_size.y/2
	
func _on_update_player_position(player_id, position,player):
	player1.sync_position(player_id, position)
	player2.sync_position(player_id, position)
	
func _on_update_ball_position_from_server(pos):
	ball.position = pos
