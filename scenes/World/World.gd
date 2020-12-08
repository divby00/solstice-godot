extends Node

onready var player = $Player
onready var camera = $Camera2D
onready var panel = $UI/Panel

onready var levels = {
	"level01": preload("res://scenes/Levels/Level01.tscn"),
	"level02": preload("res://scenes/Levels/Level02.tscn"),
}

var current_level = null

func _ready():
	load_level("level01")
	
func load_level(level_key):
	current_level = levels[level_key].instance()
	set_camera_limits(current_level)
	get_tree().current_scene.add_child_below_node(camera, current_level, false)
	call_deferred("set_initial_player_position")
	connect_items()
	connect_locks()
	connect_teleporters()
	connect_info_areas()
	
func connect_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		item.connect("player_over_item", player, "on_player_over_item")

func connect_locks():
	var locks = get_tree().get_nodes_in_group("LockGroup")
	for lock in locks:
		lock.connect("player_can_open", player, "on_player_can_open")

func connect_teleporters():
	var teleporter_groups = get_tree().get_nodes_in_group("TeleporterGroup")
	for teleporter_group in teleporter_groups:
		teleporter_group.connect("player_over_charger", player, "on_player_over_charger")
		teleporter_group.connect("teleporter_activated", player, "on_teleporter_activated")

func connect_info_areas():
	var info_areas = get_tree().get_nodes_in_group("InfoAreaGroup")
	for info_area in info_areas:
		info_area.connect("info_area_entered", panel, "on_info_area_entered")

func set_camera_limits(level):
	camera.limit_left = level.camera_limit_left
	camera.limit_top = level.camera_limit_top - 24
	camera.limit_right = level.camera_limit_right
	camera.limit_bottom = level.camera_limit_bottom + 24
	
func set_initial_player_position():
	var start_position = current_level.get_node("StartPosition")
	player.global_position = start_position.global_position
