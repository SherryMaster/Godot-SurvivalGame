class_name FruitTree
extends Node2D

@export var min_spawn_wait: float = 3
@export var max_spawn_wait: float = 5
@export var max_apples = 3

@export_category("Apple Settings")
@export var APPLE_SCENE: PackedScene = preload("res://Scenes/Objects/apple.tscn")

var apples := 0

var spawn_points: Array[Node]
var apple_spawned_at_point: Array[bool] = []

@onready var apple_respawn_timer = $AppleRespawnTimer

func _ready():
	spawn_points = %AppleSpawnPoints.get_children()
	for i in range(spawn_points.size()):
		apple_spawned_at_point.append(false)
	apple_respawn_timer.start(randf_range(min_spawn_wait, max_spawn_wait))
	
func _process(delta):

	apples = 0
	for point in spawn_points:
		apples += 1 if point.get_child_count() > 0 else 0

func _on_apple_respawn_timer_timeout():
	if not apples >= max_apples:
		var new_apple = APPLE_SCENE.instantiate() as PickAble
		var pos: Marker2D
		var selected_index: int
		
		while true:
			selected_index = randi_range(0, spawn_points.size() - 1)
			if apple_spawned_at_point[selected_index]:
				continue
			apple_spawned_at_point[selected_index] = true
			pos = spawn_points[selected_index]
			break
		
		new_apple.top_level = true
		new_apple.global_position = pos.global_position
		new_apple.item_index = selected_index
		pos.add_child(new_apple)

		
	apple_respawn_timer.start(randf_range(min_spawn_wait, max_spawn_wait))

func remove_apple(index: int):
	apple_spawned_at_point[index] = false
	spawn_points[index].get_child(0).queue_free()

