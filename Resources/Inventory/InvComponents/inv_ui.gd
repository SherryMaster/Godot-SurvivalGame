extends Control

@onready var slots = $MC/VBC/GridContainer.get_children()
@onready var coins_amount = $MC/VBC/HBC/CoinsAmount
@onready var inv: Inv = preload("res://Resources/Inventory/player_inventory.tres")


func  _process(delta):
	update_slots()
	coins_amount.text = str(inv.Currency.get("Coin"))

func update_slots():
	for i in range(inv.inventory.size()):
		slots[i].update_slot(inv.inventory[i])
