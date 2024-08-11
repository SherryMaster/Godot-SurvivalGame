extends Panel


func update_slot(item: InvItem):
	if item:
		$item_texture.texture = item.texture
		$Amount.text = str(item.amount) if item.amount > 1 else ""
