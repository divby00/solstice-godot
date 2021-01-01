extends CanvasLayer

onready var item_texture = $Panel/ItemTexture

func _on_Player_item_picked(texture):
	item_texture.texture = texture

func _on_Player_item_used():
	item_texture.texture = null
