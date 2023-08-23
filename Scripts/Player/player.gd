extends CharacterBody2D


var speed = 100.0



func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var directionX = Input.get_axis("MoveLeft", "MoveRight")
	
	if directionX:
		velocity.x = directionX * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var directionY = Input.get_axis("MoveUp", "MoveDown")
	if directionY:
		velocity.y = directionY * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
		
	move_and_slide()
