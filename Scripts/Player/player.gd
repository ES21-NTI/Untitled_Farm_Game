extends CharacterBody2D


var speed = 100.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	
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
		
	#character animations
	if velocity.x >= 10:
		sprite.flip_h = false
		sprite.play("Sideward")
	elif velocity.x <= -10:
		sprite.flip_h = true
		sprite.play("Sideward")
	elif velocity.y >= 10:
		sprite.play("Forward")
	elif velocity.y <= -10:
		sprite.play("Backward")
	elif velocity.x == 0 && velocity.y == 0:
		sprite.play("Idle")
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("Interact"):
		if $PickupZone.itemsInRange.size() > 0:
			var pickUpItem = $PickupZone.itemsInRange.values()[0]
			pickUpItem.pickUpItem(self)
			$PickupZone.itemsInRange.erase(pickUpItem)
