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
	connect_teleporter_pass_dispatchers()
	connect_info_areas()
	connect_nuclear_storages()
	connect_player_data()
	connect_enemies()
	
func connect_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		item.connect("item_picked", player, "on_item_picked")

func connect_locks():
	var locks = get_tree().get_nodes_in_group("LockGroup")
	for lock in locks:
		lock.connect("lock_opened", player, "on_lock_opened")

func connect_teleporters():
	var teleporter_groups = get_tree().get_nodes_in_group("TeleporterGroup")
	for teleporter_group in teleporter_groups:
		teleporter_group.connect("teleporter_charged", player, "on_teleporter_charged")
		teleporter_group.connect("teleporter_activated", player, "on_teleporter_activated")
		
func connect_teleporter_pass_dispatchers():
	var dispatchers = get_tree().get_nodes_in_group("TeleporterPassDispatcherGroup")
	for dispatcher in dispatchers:
		dispatcher.connect("pass_dispatched", player, "on_pass_dispatched")

func connect_info_areas():
	var info_areas = get_tree().get_nodes_in_group("InfoAreaGroup")
	for info_area in info_areas:
		info_area.connect("info_area_entered", panel, "on_info_area_entered")

func connect_nuclear_storages():
	var nuclear_storages = get_tree().get_nodes_in_group("NuclearStorageGroup")
	for nuclear_storage in nuclear_storages:
		nuclear_storage.connect("nuclear_waste_stored", player, "on_nuclear_waste_stored")

func connect_player_data():
	PlayerData.connect("health_changed", panel, "on_health_changed")
	PlayerData.connect("lives_changed", panel, "on_lives_changed")
	PlayerData.connect("thrust_changed", panel, "on_thrust_changed")
	PlayerData.connect("laser_changed", panel, "on_laser_changed")
	PlayerData.connect("time_changed", panel, "on_time_changed")
	PlayerData.connect("player_destroyed", player, "on_player_destroyed")
	PlayerData.connect("status_changed", player, "on_status_changed")

func set_camera_limits(level):
	camera.limit_left = level.camera_limit_left
	camera.limit_top = level.camera_limit_top - 32
	camera.limit_right = level.camera_limit_right
	camera.limit_bottom = level.camera_limit_bottom + 16
	
func set_initial_player_position():
	var start_position = current_level.get_node("StartPosition")
	player.global_position = start_position.global_position

func connect_enemies():
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		enemy.connect("enemy_attacked", player, "on_enemy_attacked")
		enemy.connect("enemy_attack_stopped", player, "on_enemy_attack_stopped")

