extends Node

onready var player = $Player

func _ready():
	connect_items()
	connect_locks()

func connect_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		item.connect("player_over_item", player, "on_player_over_item")

func connect_locks():
	var locks = get_tree().get_nodes_in_group("LockGroup")
	for lock in locks:
		lock.connect("player_can_open", player, "on_player_can_open")
