extends CharacterBody2D
signal pickup(item: PickAble)

@export var shoot_cooldown = 1

@export_category("Inventory")
@export var inventory: Inv = preload("res://Resources/Inventory/player_inventory.tres")


@onready var sprites_animation = $SpritesAnimation
@onready var shooting_cooldown = $ShootingCooldown
var arrow = preload("res://Scenes/Objects/arrow.tscn")


var speed := 100.0
var dir: String = "n"
var state: String = "idle"
var current_item_to_pickup: PickAble = null
var max_marker_distance = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#states
var aiming = false
var can_shoot = true


func _unhandled_input(event):
	if event.is_action_pressed("PickupItem"):
		if current_item_to_pickup:
			pickup_item(current_item_to_pickup)
	
	if event.is_action_pressed("Aim"):
		$AimIcon.visible = true
		aiming = true
	
	if event.is_action_released("Aim"):
		$AimIcon.visible = false
		aiming = false
	
	if event.is_action_pressed("Shoot") and aiming and can_shoot:
		shoot()
	

func _physics_process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	velocity = direction * speed
	
	detect_pickable()
	
	# The Aiming Marker
	$AimIcon.position.x = (Input.get_action_strength("R_Right") - Input.get_action_strength("R_Left")) * max_marker_distance
	$AimIcon.position.y = (Input.get_action_strength("R_Down") - Input.get_action_strength("R_Up")) * max_marker_distance
	
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
	
	if $AimIcon.visible:
		if $AimIcon.position.x == 0 and $AimIcon.position.y < 0:
			dir = "n"
		elif $AimIcon.position.x == 0 and $AimIcon.position.y > 0:
			dir = "s"
		elif $AimIcon.position.x < 0 and $AimIcon.position.y == 0:
			dir = "w"
		elif $AimIcon.position.x > 0 and $AimIcon.position.y == 0:
			dir = "e"
		elif $AimIcon.position.x < 0 and $AimIcon.position.y < 0:
			dir = "nw"
		elif $AimIcon.position.x < 0 and $AimIcon.position.y > 0:
			dir = "sw"
		elif $AimIcon.position.x > 0 and $AimIcon.position.y < 0:
			dir = "ne"
		elif $AimIcon.position.x > 0 and $AimIcon.position.y > 0:
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
	
	if item.added_to_inventory:
		var item_to_collect = InvItem.new()
		item_to_collect.name = item.item_name
		item_to_collect.texture = item.texture
		item_to_collect.amount = item.value
		inventory.insert_item(item_to_collect)
	elif item.item_type == "Currency":
		inventory.update_currency(item.item_name, item.value)
		
	
	pickup.emit(item)
	item.queue_free() if not item.item_index >= 0 else null

func shoot():
	var new_arrow = arrow.instantiate() as Projectile
	new_arrow.top_level = true
	new_arrow.global_position = global_position
	new_arrow.look_at($AimIcon.global_position)
	
	$Projectiles.add_child(new_arrow)
	can_shoot = false
	shooting_cooldown.start(shoot_cooldown)
	

func _on_shooting_cooldown_timeout():
	can_shoot = true
