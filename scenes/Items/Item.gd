extends Area2D

export(String) var item_name

var over_item = false

signal item_picked(item)

func _process(delta):
	if over_item and visible and Input.is_action_just_pressed("ui_down"):
		emit_signal("item_picked", self)

func _on_Item_body_entered(body):
	over_item = true

func _on_Item_body_exited(body):
	over_item = false
