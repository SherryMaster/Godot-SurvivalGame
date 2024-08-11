extends Area2D
class_name Projectile

signal max_distance_travelled

@export var damage: float = 5
@export var speed: float = 250
@export var max_distance: float = 2500

var shot_by_enemy: bool = false
var distance_travelled: float = 0

# Called when the node enters the scene tree for the first time.
func move(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta
	distance_travelled += speed * delta
	
	if distance_travelled >= max_distance:
		max_distance_travelled.emit()
