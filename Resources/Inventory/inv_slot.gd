extends Panel


func update_slot(item: InvItem):
	$item_texture.texture = item.texture
