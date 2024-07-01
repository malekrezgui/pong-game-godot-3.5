extends KinematicBody2D


var speed = 600
var velocity = Vector2.ZERO

func _ready():
	initialize_ball_direction()
	


func initialize_ball_direction():
	randomize()
	var x_array = [-1,1]
	var y_array = [-0.5, 0.5]
	velocity.x = x_array[randi()%2]
	velocity.y = y_array[randi()%2]
	
func _physics_process(delta):
	var colliding = move_and_collide(velocity * speed * delta)
	if colliding:
		velocity = velocity.bounce(colliding.normal)
		_send_ball_position(position)
		
func stop_ball():
	speed=0
	
func start_ball():
	speed=600
	initialize_ball_direction()
	
func _send_ball_position(pos):
	ServerNetwork._update_ball_position(pos)
	
	
	
	
	
