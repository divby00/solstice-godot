extends CanvasLayer

onready var player_stats = ResourceLoader.player_stats
onready var label = $Label
onready var item_texture = $ItemTexture

func _ready():
	label.text = str(player_stats.lives)
	item_texture.texture = null
