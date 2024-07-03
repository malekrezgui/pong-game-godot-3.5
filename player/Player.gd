extends CharacterBody2D

var speed = 500

var owner_id : int = -1
var is_local : bool = false
@export var paddle_position: int


func set_ownership(id):
	owner_id = id
	if id == multiplayer.get_unique_id():
		is_local = true
	else:
		is_local = false

func sync_position(id, pos):
	if id == multiplayer.get_unique_id():
		return
	if is_local :
		return
	self.position.y = pos.y

func _ready():
	print(ServerData.players)
	pass


func _physics_process(delta):
	if Data.isServer:
		#print("exit for: Data.isServer")
		return
	
	if not is_local:
		#print("exit for: is_local")
		return
		
	
	#print("paddle >>>",ServerData.players)
	#print("paddle >>> ",multiplayer.get_network_unique_id())
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

	set_velocity(velocity)
	move_and_slide()
	var new_position = position
	if velocity != Vector2.ZERO:
		_send_position(new_position)

func _send_position(position):
	#print(">>ALPHA: ", multiplayer.get_network_unique_id(),"-",position,"1")
	ClientNetwork.update_position_on_server(multiplayer.get_unique_id(), position,"1")

