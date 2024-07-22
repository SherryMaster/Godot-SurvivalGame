extends CharacterBody2D


var speed := 100.0

var dir: String = "n"
var state: String = "idle"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprites_animation = $SpritesAnimation

func _physics_process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	
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
