extends CharacterBody2D


const ACCELERATION = 460
const MAX_SPEED = 225


var itemName

var player = null
var beingPickedUp = false


func _ready():
	itemName = "Egg"


func _physics_process(delta):
	if beingPickedUp == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			PlayerInventory.addItem(itemName, 1)
			queue_free()
		move_and_slide()


func pickUpItem(body):
	player = body
	beingPickedUp = true
