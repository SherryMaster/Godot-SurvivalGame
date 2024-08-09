class_name PickAble
extends Node2D

@export_enum("Fruit", "Currency") var item_type = "Fruit"
@export var item_name = "Apple"
@export var value: int = 1
@export var pickable_instantly = false

var item_index = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
