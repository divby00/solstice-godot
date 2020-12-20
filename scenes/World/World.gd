extends Node

const nuclear_waste_texture = preload("res://scenes/StorageBase/nuclear_waste.png")

onready var player = $Player
onready var camera = $Camera2D
onready var camera_shake_timer = $CameraShakeTimer
onready var panel = $UI/Panel
onready var storage_base = $StorageBase
onready var circle_transition = $CircleTransition
onready var transition_out_timer = $TransitionOutTimer
onready var level_change_label = $CircleTransition/LevelChangeLabel

var new_level = null

func _ready():
	set_process(false)
	load_level("04")
	
func load_level(level_key):
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		enemy.queue_free()
	var level = get_tree().get_nodes_in_group("LevelGroup")
	if level.size() > 0:
		level[0].queue_free()
	LevelData.current_level = LevelData.levels[level_key].instance()
	LevelData.current_level_number = int(level_key)
	set_camera_limits(LevelData.current_level)
	get_tree().current_scene.add_child_below_node(camera, LevelData.current_level, false)
	call_deferred("set_initial_player_position")
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
	circle_transition.fadein()

func connect_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		Utils.connect_signal(item, "item_picked", player, "on_item_picked")

func connect_locks():
	var locks = get_tree().get_nodes_in_group("LockGroup")
	for lock in locks:
		Utils.connect_signal(lock, "lock_opened", player, "on_lock_opened")

func connect_teleporters():
	var teleporter_groups = get_tree().get_nodes_in_group("TeleporterGroup")
	for teleporter_group in teleporter_groups:
		Utils.connect_signal(teleporter_group, "teleporter_charged", player, "on_teleporter_charged")
		Utils.connect_signal(teleporter_group, "teleporter_activated", player, "on_teleporter_activated")

func connect_teleporter_pass_dispatchers():
	var dispatchers = get_tree().get_nodes_in_group("TeleporterPassDispatcherGroup")
	for dispatcher in dispatchers:
		Utils.connect_signal(dispatcher, "pass_dispatched", player, "on_pass_dispatched")

func connect_info_areas():
	var info_areas = get_tree().get_nodes_in_group("InfoAreaGroup")
	for info_area in info_areas:
		Utils.connect_signal(info_area, "info_area_entered", panel, "on_info_area_entered")

func connect_nuclear_containers():
	var nuclear_containers = get_tree().get_nodes_in_group("NuclearStorageGroup")
	for nuclear_container in nuclear_containers:
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", player, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", storage_base, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", self, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "time_tick_finished", panel, "on_time_changed")
		Utils.connect_signal(nuclear_container, "explosion_triggered", player, "on_explosion_triggered")
		nuclear_container.explosion_timer.start()

func connect_player_data():
	Utils.connect_signal(PlayerData, "health_changed", panel, "on_health_changed")
	Utils.connect_signal(PlayerData, "lives_changed", panel, "on_lives_changed")
	Utils.connect_signal(PlayerData, "thrust_changed", panel, "on_thrust_changed")
	Utils.connect_signal(PlayerData, "laser_changed", panel, "on_laser_changed")
	Utils.connect_signal(PlayerData, "time_changed", panel, "on_time_changed")
	Utils.connect_signal(PlayerData, "player_destroyed", player, "on_player_destroyed")
	Utils.connect_signal(PlayerData, "status_changed", player, "on_status_changed")
	Utils.connect_signal(player, "item_used", player, "on_item_used")
	Utils.connect_signal(player, "player_damaged", self, "on_player_damaged")
	Utils.connect_signal(player, "player_activated_elevator", self, "on_player_activated_elevator")

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
		Utils.connect_signal(enemy, "enemy_attacked", player, "on_enemy_attacked")
		Utils.connect_signal(enemy, "enemy_died", spawners, "on_enemy_died")

func connect_rails():
	var rails = get_tree().get_nodes_in_group("RailGroup")
	for rail in rails:
		Utils.connect_signal(rail, "player_has_to_move", player, "on_player_has_to_move")

func connect_elevator():
	var elevators = get_tree().get_nodes_in_group("ElevatorGroup")
	for elevator in elevators:
		Utils.connect_signal(elevator, "elevator_activated", player, "on_elevator_activated")

func on_nuclear_waste_stored(storage):
	if LevelData.current_level_number == 1:
		var sprite = Sprite.new()
		sprite.name = "CustomNuclearWaste"
		sprite.texture = nuclear_waste_texture
		sprite.global_position = Vector2(64, 328)
		get_tree().current_scene.add_child(sprite)

func on_player_activated_elevator(level_pass):
	var custom_nuclear_waste = get_node("CustomNuclearWaste")
	if custom_nuclear_waste != null:
		custom_nuclear_waste.queue_free()
	new_level = level_pass.substr(4, 2)
	PlayerData.selected_item = null
	circle_transition.fadeout()
	transition_out_timer.start()

func on_player_damaged():
	set_process(true)
	camera_shake_timer.start()

func _on_CameraShakeTimer_timeout():
	camera.offset_h = 0
	camera.offset_v = 0
	set_process(false)

func _process(delta):
	camera.offset_h = rand_range(-.03, .03)
	camera.offset_v = rand_range(-.03, .03)

func _on_TransitionOutTimer_timeout():
	level_change_label.text = "Entering level " + str(new_level) + "..."
	yield(get_tree().create_timer(1), "timeout")
	level_change_label.text = ""
	load_level(new_level)
