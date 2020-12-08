extends Area2D

export(String) var item_name
var over_item = false

signal player_over_item(item)

func _process(delta):
	if over_item and visible:
		emit_signal("player_over_item", self)

func _on_Item_body_entered(body):
	over_item = true

func _on_Item_body_exited(body):
	over_item = false
