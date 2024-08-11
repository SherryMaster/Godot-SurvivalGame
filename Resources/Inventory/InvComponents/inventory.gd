extends Resource
class_name Inv

@export var Currency: Dictionary = {
	"Coin": 0,
}

@export var inventory: Array[InvItem]

func update_currency(type, amount):
	Currency[type] += amount
	ResourceSaver.save(self)

func insert_item(item: InvItem):
	for itm in inventory:
		if !itm:
			var index = inventory.find(itm)
			print(index)
			inventory[index] = item
			break
		elif item.name == itm.name:
			itm.amount += item.amount
			break
	
	ResourceSaver.save(self)
