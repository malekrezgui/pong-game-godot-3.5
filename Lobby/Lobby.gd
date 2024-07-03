extends Control

@onready var host_button = $LobbyPanel/HostButton
@onready var join_button = $LobbyPanel/JoinButton

func _ready():
	if OS.has_feature("server"):
		hello("I'm a server!")
		Data.isServer=true
	else:
		hello("I'm a client!")
		Data.isServer=false
func hello(msg):
	print(msg)

func _on_HostButton_pressed():
	ServerNetwork.start_server()


func _on_JoinButton_pressed():
	ClientNetwork.connect_to_server()
	
