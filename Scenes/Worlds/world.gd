extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("ShowInv"):
		$CanvasLayer/Inv_UI.visible = !$CanvasLayer/Inv_UI.visible

func _on_player_pickup(item: PickAble):
	pass
