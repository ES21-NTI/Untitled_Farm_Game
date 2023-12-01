extends CharacterBody2D


const ACCELERATION = 460
const MAX_SPEED = 225


var itemName
var itemQuantity
var itemCategory

var player = null
var beingPickedUp = false

func _ready(): # 
	itemName = Global.itemDropName
	itemQuantity = Global.itemDropQuantity
	itemCategory = Global.itemDropCategory
	if itemName != null: # Fixes a weird instantiation glitch that crashes the game at launch
		$Sprite2D.texture = load("res://Assets/item_icons/" + itemName + ".png")


func _physics_process(delta):
	if beingPickedUp == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			PlayerInventory.addItem(itemName, itemQuantity)
			queue_free()
		move_and_slide()


func pickUpItem(body):
	player = body
	beingPickedUp = true

