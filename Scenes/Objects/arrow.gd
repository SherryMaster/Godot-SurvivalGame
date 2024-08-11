extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	max_distance_travelled.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func destroy():
	queue_free()
