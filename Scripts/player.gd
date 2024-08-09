extends CharacterBody2D
signal pickup(item: PickAble)

@export var inventory: Inv

var speed := 100.0
var dir: String = "n"
var state: String = "idle"

var current_item_to_pickup: PickAble = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprites_animation = $SpritesAnimation

func _unhandled_input(event):
	if event.is_action_pressed("PickupItem"):
		if current_item_to_pickup:
			pickup_item(current_item_to_pickup)
	
	if event.is_action_pressed("ShowInv"):
		print("INVENTORY:-")
		for type in PlayerData.Inventory:
			print("{type}: ".format({"type": type.to_upper()}))
			for item in PlayerData.Inventory[type]:
				if PlayerData.Inventory[type][item]:
					print("{item}: {value}".format({"item": item, "value": PlayerData.Inventory[type][item]}))
		

func _physics_process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	velocity = direction * speed
	
	detect_pickable()
	
	# State
	if direction.x == 0 and direction.y == 0:
		state = "idle"
	else:
		state = "walk"
	
	
	# Direction
	if direction.x == 0 and direction.y < 0:
		dir = "n"
	elif direction.x == 0 and direction.y > 0:
		dir = "s"
	elif direction.x < 0 and direction.y == 0:
		dir = "w"
	elif direction.x > 0 and direction.y == 0:
		dir = "e"
	elif direction.x < 0 and direction.y < 0:
		dir = "nw"
	elif direction.x < 0 and direction.y > 0:
		dir = "sw"
	elif direction.x > 0 and direction.y < 0:
		dir = "ne"
	elif direction.x > 0 and direction.y > 0:
		dir = "se"
	move_and_slide()
	play_anim()


func play_anim():
	sprites_animation.play(state + "-" + dir)


func detect_pickable():
	var bodies = $PickupArea.get_overlapping_bodies()
	
	var items = []
	var distances = []
	var index = -1
	
	for body in bodies:
		if body is PickAble:
			if body.pickable_instantly:
				pickup_item(body)
				continue
			items.append(body)
			distances.append(global_position.distance_to(body.global_position))
	
	if distances:
		index = distances.find(distances.min())
	
	if index < 0:
		current_item_to_pickup = null
	else:
		current_item_to_pickup = items[index]

func pickup_item(item: PickAble):
	if item.item_index >= 0:
		var tree = item.get_parent().get_parent().get_parent() as FruitTree
		tree.remove_apple(item.item_index)
		pickup.emit(item)
	else:
		pickup.emit(item)
		item.queue_free()
