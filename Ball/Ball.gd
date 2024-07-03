extends CharacterBody2D

var speed = 600

func _ready():
	initialize_ball_direction()
	
func initialize_ball_direction():
	randomize()
	var x_array = [-1,1]
	var y_array = [-0.5, 0.5]
	velocity.x = x_array[randi()%2]
	velocity.y = y_array[randi()%2]
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

func stop_ball():
	speed=0
	
func start_ball():
	speed=600
	initialize_ball_direction()
	
	
