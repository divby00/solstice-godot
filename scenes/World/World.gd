extends Node

const nuclear_waste_texture = preload("res://scenes/StorageBase/nuclear_waste.png")

onready var player = $Player
onready var camera = $Camera2D
onready var panel = $UI/Panel
onready var storage_base = $StorageBase

func _ready():
	load_level("01")
	connect_items()
	connect_teleporters()
	connect_teleporter_pass_dispatchers()
	connect_info_areas()
	connect_nuclear_containers()
	connect_locks()
	connect_player_data()
	connect_enemies()
	connect_rails()
	connect_elevator()
	
func load_level(level_key):
	var level = get_tree().get_nodes_in_group("LevelGroup")
	if level.size() > 0:
		level[0].queue_free()
	LevelData.current_level = LevelData.levels[level_key].instance()
	LevelData.current_level_number = int(level_key)
	set_camera_limits(LevelData.current_level)
	get_tree().current_scene.add_child_below_node(camera, LevelData.current_level, false)
	call_deferred("set_initial_player_position")

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

func connect_nuclear_containers():
	var nuclear_containers = get_tree().get_nodes_in_group("NuclearStorageGroup")
	for nuclear_container in nuclear_containers:
		nuclear_container.connect("nuclear_waste_stored", player, "on_nuclear_waste_stored")
		nuclear_container.connect("nuclear_waste_stored", storage_base, "on_nuclear_waste_stored")
		nuclear_container.connect("nuclear_waste_stored", self, "on_nuclear_waste_stored")
		nuclear_container.connect("time_tick_finished", panel, "on_time_changed")
		nuclear_container.connect("explosion_triggered", player, "on_explosion_triggered")
		nuclear_container.explosion_timer.start()

func connect_player_data():
	PlayerData.connect("health_changed", panel, "on_health_changed")
	PlayerData.connect("lives_changed", panel, "on_lives_changed")
	PlayerData.connect("thrust_changed", panel, "on_thrust_changed")
	PlayerData.connect("laser_changed", panel, "on_laser_changed")
	PlayerData.connect("time_changed", panel, "on_time_changed")
	PlayerData.connect("player_destroyed", player, "on_player_destroyed")
	PlayerData.connect("status_changed", player, "on_status_changed")
	player.connect("item_used", player, "on_item_used")

func set_camera_limits(level):
	camera.limit_left = level.camera_limit_left
	camera.limit_top = level.camera_limit_top - 32
	camera.limit_right = level.camera_limit_right
	camera.limit_bottom = level.camera_limit_bottom + 16
	
func set_initial_player_position():
	var start_position = LevelData.current_level.get_node("StartPosition")
	player.global_position = start_position.global_position

func connect_enemies():
	var spawners = LevelData.current_level.get_node("Spawners")
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		enemy.connect("enemy_attacked", player, "on_enemy_attacked")
		enemy.connect("enemy_died", spawners, "on_enemy_died")

func connect_rails():
	var rails = get_tree().get_nodes_in_group("RailGroup")
	for rail in rails:
		rail.connect("player_has_to_move", player, "on_player_has_to_move")

func connect_elevator():
	var elevators = get_tree().get_nodes_in_group("ElevatorGroup")
	for elevator in elevators:
		elevator.connect("elevator_activated", self, "on_elevator_activated")

func on_nuclear_waste_stored(storage):
	if LevelData.current_level_number == 1:
		var sprite = Sprite.new()
		sprite.texture = nuclear_waste_texture
		sprite.global_position = Vector2(64, 328)
		get_tree().current_scene.add_child(sprite)

func on_elevator_activated(level_pass):
	load_level(level_pass.substr(4, 2))
